# frozen_string_literal: true

require_relative './test_helper'

class ConfigurationMinitest < Minitest::Test
  describe 'default settings' do
    describe '#amp_cache_domain' do
      it 'defaults to cdn.ampproject.org' do
        assert_equal('cdn.ampproject.org', Google::AMP::Cache::Configuration.new.amp_cache_domain)
      end
    end

    describe '#private_key' do
      it 'defaults to nil' do
        assert_nil(Google::AMP::Cache::Configuration.new.private_key)
      end
    end
  end

  describe 'configure with provided block' do
    before do
      Google::AMP::Cache.configure do |config|
        config.amp_cache_domain = 'bing-amp.com'
        config.private_key = File.read("#{File.dirname(__FILE__)}/private-key.pem")
      end
    end

    it 'sets configurations accordingly' do
      assert_equal('bing-amp.com', Google::AMP::Cache.configuration.amp_cache_domain)
      assert_equal(File.read("#{File.dirname(__FILE__)}/private-key.pem"), Google::AMP::Cache.configuration.private_key)
    end
  end

  describe 'configure individually' do
    before do
      Google::AMP::Cache.configure do |config|
        config.amp_cache_domain = 'cdn.ampproject.org'
        config.private_key = 'dummy_key'
      end
    end

    describe 'amp_cache_domain' do
      it 'sets configuration accordingly' do
        Google::AMP::Cache.configuration.amp_cache_domain = 'bing-amp.com'
        assert_equal('bing-amp.com', Google::AMP::Cache.configuration.amp_cache_domain)
      end

      it 'does not touch unrelated settings' do
        Google::AMP::Cache.configuration.amp_cache_domain = 'bing-amp.com'
        assert_equal('dummy_key', Google::AMP::Cache.configuration.private_key)
      end
    end
  end
end
