# frozen_string_literal: true

require_relative './test_helper'
require 'openssl'

class InvalidatorMinitest < Minitest::Test
  describe '#ping' do
    describe 'with correct key configured' do
      before do
        WebMock.disable!
        Google::AMP::Cache.configure do |config|
          config.amp_cache_domain = 'cdn.ampproject.org'
          config.private_key = File.read("#{File.dirname(__FILE__)}/private-key.pem")
        end
      end

      it 'receive sucessful response' do
        response = Google::AMP::Cache::Invalidator.new('https://limitless-tundra-65881.herokuapp.com/amp-access/sample/0').ping
        assert_equal('OK', response)
      end
    end

    describe 'with incorrect key' do
      before do
        WebMock.disable!
        Google::AMP::Cache.configure do |config|
          config.amp_cache_domain = 'cdn.ampproject.org'
          config.private_key = OpenSSL::PKey::RSA.new(2048).to_s
        end
      end

      it 'raises forbidden error' do
        assert_raises Google::AMP::Cache::ForbiddenError do
          Google::AMP::Cache::Invalidator.new('https://limitless-tundra-65881.herokuapp.com/amp-access/sample/0').ping
        end
      end
    end

    describe 'with empty key' do
      before do
        WebMock.disable!
        Google::AMP::Cache.configure do |config|
          config.amp_cache_domain = 'cdn.ampproject.org'
          config.private_key = ''
        end
      end

      it 'raises forbidden error' do
        assert_raises Google::AMP::Cache::PrivateKeyNotFound do
          Google::AMP::Cache::Invalidator.new('https://limitless-tundra-65881.herokuapp.com/amp-access/sample/0').ping
        end
      end
    end
  end

  describe 'with Bing as amp cache domain configured' do
    before do
      Timecop.freeze(Time.at(1_600_685_360))
      Google::AMP::Cache.configure do |config|
        config.amp_cache_domain = 'bing-amp.com'
        config.private_key = File.read("#{File.dirname(__FILE__)}/private-key.pem")
      end
    end

    after do
      Timecop.return
      WebMock.disable!
    end

    it 'sends invalidate requests to Bing AMP CDN instead' do
      stub_request(:get, 'https://limitless--tundra--65881-herokuapp-com.bing-amp.com/update-cache/c/s/limitless-tundra-65881.herokuapp.com/amp-access/sample/0?amp_action=flush&amp_ts=1600685360&amp_url_signature=CsQboBT-U0BynUXY_IQqhy-fUBLm9PGSvmRYIeHxrUoWaqgeOCvY2G7LA7gTBAnzqETiMPtPMfeSve3HhX9jKHQ6AcT_I4KNzC1p4xsntzmODBRZnlpOIa8zSZe2g-O51MNwf5U_gFmEHBBtATim5dUsOUFf8yWOiESSZnz2cpYFcKdjn656svx8wKZbnFe-4FG9n9U8YHLx9Qy4EXnxr0Bgo6HSEBQdbBigj97IDYcFWMtKUw0cxDr3JkKzNazTXj5wicoUEdW-Sur75HoIS9Ak0NgXKuAtPbb-QERtS-F7Lc8BKZg_sFPnqMNareYKriNmRuRAh0WEgdwj5fayUA')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host' => 'limitless--tundra--65881-herokuapp-com.bing-amp.com',
            'User-Agent' => 'Ruby'
          }
        ).to_return(status: 200, body: 'OK', headers: {})

      assert_equal('OK', Google::AMP::Cache::Invalidator.new('https://limitless-tundra-65881.herokuapp.com/amp-access/sample/0').ping)
    end
  end
end
