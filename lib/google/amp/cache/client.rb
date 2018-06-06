require 'base64'
require 'rack'
require 'uri'

module Google::AMP::Cache
  class Client
    include HTTParty
    base_uri 'https://acceleratedmobilepageurl.googleapis.com/v1'

    UPDATE_CACHE_API_DOMAIN_SUFFIX = 'cdn.ampproject.org'
    DIGEST = OpenSSL::Digest::SHA256.new

    attr_reader :private_key, :google_api_key

    def initialize(api_key = nil, private_key = nil)
      @google_api_key = api_key
      @private_key = OpenSSL::PKey::RSA.new(private_key) if private_key
    end

    def batch_get(urls, lookup_strategy = :FETCH_LIVE_DOC)
      post('/ampUrls:batchGet',
        body: {
          urls: Array(urls),
          lookupStrategy: lookup_strategy
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          "X-Goog-Api-Key" => google_api_key
        })
    end

    def update_cache(url, content_type = :document)
      page_uri = URI.parse(url)
      subdomain = format_domain(page_uri.host)

      api_host = URI.parse(["https://", subdomain, '.', UPDATE_CACHE_API_DOMAIN_SUFFIX].join)
      params = {
        amp_action: 'flush',
        amp_ts: Time.now.to_i
      }

      api_path = "/update-cache/#{short_content_type(content_type)}/#{'s/' if page_uri.scheme.match?('https')}#{page_uri.host}#{page_uri.path}?#{Rack::Utils.build_query(params)}"
      sig = private_key.sign(DIGEST, api_path)
      signature = Base64.urlsafe_encode64(sig)

      result = self.class.get("#{api_host}#{api_path}&amp_url_signature=#{signature}")
      result.ok?
    end

    def short_content_type(type)
      case type.to_sym
      when :document
        'c'
      when :image
        'i'
      when :resource
        'r'
      end
    end

    def format_domain(url)
      url.gsub('-', '--').tr('.', '-')
    end

    def post(path, opts={})
      response = self.class.post(path, opts)
      response.parsed_response
    end
  end
end