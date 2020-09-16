require 'faraday'
require 'faraday_middleware'
require 'base64'
require 'uri'
require 'openssl'

module Google::AMP::Cache
  class Client
    UPDATE_CACHE_API_DOMAIN_SUFFIX = 'cdn.ampproject.org'
    DIGEST = OpenSSL::Digest::SHA256.new

    attr_reader :private_key, :google_api_key

    def initialize(api_key = nil, private_key = nil)
      @google_api_key = api_key
      @private_key = OpenSSL::PKey::RSA.new(private_key) if private_key
    end

    def batch_get(urls, lookup_strategy = :FETCH_LIVE_DOC)
      Faraday.new('https://acceleratedmobilepageurl.googleapis.com/',
                  headers: {
                      "X-Goog-Api-Key" => google_api_key
                  }) do |conn|
        conn.request :json
        conn.response :json
        conn.response :raise_error
      end.post('/v1/ampUrls:batchGet', {
          urls: Array(urls),
          lookupStrategy: lookup_strategy
      }).body
    end

    def update_cache(url, content_type = :document)
      page_uri = URI.parse(url)
      subdomain = format_domain(page_uri.host)

      path_components = ["update-cache", short_content_type(content_type)]
      path_components << 's' if page_uri.scheme.match?('https')
      path_components << "#{page_uri.host}#{page_uri.path}"
      path = path_components.join('/')

      params = Faraday::Utils::ParamsHash[{ amp_action: 'flush', amp_ts: Time.now.to_i }]

      sig = private_key.sign(DIGEST, "/#{path}?#{params.to_query}")
      params[:amp_url_signature] = Base64.urlsafe_encode64(sig)

      Faraday.new("https://#{subdomain}.cdn.ampproject.org/") do |conn|
        conn.response :raise_error
      end.get(path, params).body
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
  end
end