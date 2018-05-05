module Google::AMP::Cache
  class Client
    include HTTParty
    base_uri 'https://acceleratedmobilepageurl.googleapis.com/v1'

    def initialize(api_key)
      @google_api_key = api_key
    end

    def batch_get(urls, lookup_strategy = :FETCH_LIVE_DOC)
      post('/ampUrls:batchGet',
        body: {
          urls: Array(urls),
          lookupStrategy: lookup_strategy
        }.to_json,
        headers: {
          'Content-Type' => 'application/json',
          "X-Goog-Api-Key" => @google_api_key
        })
    end

    def post(method, opts={})
      response = self.class.post(method, opts)
      response.parsed_response
    end
  end
end