# frozen_string_literal: true

require_relative './test_helper'

class ClientMinitest < Minitest::Test
  describe '#format_domain' do
    it 'replaces - with --' do
      client = Google::AMP::Cache::Client.new(nil)
      assert_equal client.format_domain('pub-pub.com'), 'pub--pub-com'
    end

    it 'reaplces . with .' do
      client = Google::AMP::Cache::Client.new(nil)
      assert_equal client.format_domain('pub.com'), 'pub-com'
    end
  end

  describe '#short_content_type' do
    it 'converts content type for document' do
      client = Google::AMP::Cache::Client.new(nil)
      assert_equal client.short_content_type(:document), 'c'
    end
  end

  describe '#update_cache' do
    before do
      @client = Google::AMP::Cache::Client.new(nil, File.read(File.dirname(__FILE__) + '/private-key.pem'))
    end

    it 'flushes cache' do
      assert @client.update_cache('https://limitless-tundra-65881.herokuapp.com/amp-access/sample/0')
    end
  end
end
