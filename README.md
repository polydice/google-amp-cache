# google-amp-cache

A simple Ruby API wrapper for [Google AMP Cache](https://developers.google.com/amp/cache/).

## Usage

Create API client using Google API key:

```ruby
client = Google::AMP::Cache::Client.new MY_GOOGLE_API_KEY
```

### Match URLs to AMP URLs

Then you can query AMP URLs from Google AMP Cache:

```ruby
client.batch_get("https://www.theguardian.com/membership/2016/feb/24/todays-release-of-accelerated-mobile-pages-amp")
# => {"ampUrls"=>[{"originalUrl"=>"https://www.theguardian.com/membership/2016/feb/24/todays-release-of-accelerated-mobile-pages-amp", "ampUrl"=>"https://amp.theguardian.com/membership/2016/feb/24/todays-release-of-accelerated-mobile-pages-amp", "cdnAmpUrl"=>"https://amp-theguardian-com.cdn.ampproject.org/c/s/amp.theguardian.com/membership/2016/feb/24/todays-release-of-accelerated-mobile-pages-amp"}]}
```

Or multiple URLs:

```ruby
client.batch_get(["URL A", "URL B"])
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
