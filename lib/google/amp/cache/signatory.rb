# frozen_string_literal: true

require 'openssl'
require 'fileutils'
require_relative './configuration'
require_relative './errors'

module Google
  module AMP
    module Cache
      class Signatory
        attr_reader :request, :signature

        def initialize(request)
          @request = request
        end

        def sign
          @signature = signer.sign(OpenSSL::Digest.new('SHA256'), request)
        end

        private

        def signer
          raise Google::AMP::Cache::PrivateKeyNotFound if private_key.blank?

          OpenSSL::PKey::RSA.new(private_key)
        end

        def private_key
          Google::AMP::Cache.configuration.private_key
        end
      end
    end
  end
end
