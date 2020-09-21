# frozen_string_literal: true

require 'net/http'
require_relative './signatory'
require_relative './errors'

module Google
  module AMP
    module Cache
      class Invalidator
        CONTENT_TYPE_MAPPING = {
          document: :c,
          image: :i,
          resource: :r
        }.freeze

        PROTOCOL_MAPPING = {
          https: :s,
          http: nil
        }.freeze

        def initialize(url, content_type: :document)
          @url = url
          @content_type = CONTENT_TYPE_MAPPING.fetch(content_type.to_sym, :c)
        end

        def ping
          response = Net::HTTP.get_response(signed_uri)

          case response.code.to_i
          when 200
            response.body
          when 403
            # rubocop:disable Layout/LineLength
            raise Google::AMP::Cache::ForbiddenError, 'Invalidate request forbidden, ensure you have private key and public properly configured'
            # rubocop:enable Layout/LineLength
          else
            raise response
          end
        end

        private

        def signed_uri
          @signed_uri = update_cache_uri
          @signed_uri.query = URI.encode_www_form(signed_params)
          @signed_uri
        end

        def uri
          URI.parse(@url)
        end

        def request_params
          @request_params ||= {
            amp_action: :flush,
            amp_ts: Time.now.to_i
          }
        end

        def signed_params
          @signed_params ||= request_params.merge(
            amp_url_signature: Base64.urlsafe_encode64(signature, padding: false)
          )
        end

        def signature
          Google::AMP::Cache::Signatory.new(update_cache_uri.request_uri).sign
        end

        def protocol
          PROTOCOL_MAPPING.fetch(uri.scheme, :s)
        end

        def request_path
          Pathname.new('/update-cache').join(
            @content_type.to_s,
            protocol.to_s,
            uri.host,
            Pathname.new(uri.path).relative_path_from(Pathname.new(uri.path.empty? ? '' : '/'))
          )
        end

        def update_cache_uri
          return @update_cache_uri if @update_cache_uri

          @update_cache_uri = URI.parse(['https://', cache_host, request_path].join)
          @update_cache_uri.query = URI.encode_www_form(request_params)
          @update_cache_uri
        end

        def cache_domain
          Google::AMP::Cache.configuration.amp_cache_domain
        end

        def cache_subdomain
          uri.host.gsub('-', '--').tr('.', '-')
        end

        def cache_host
          [cache_subdomain, cache_domain].join('.')
        end
      end
    end
  end
end
