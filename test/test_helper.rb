# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/reporters'
Minitest::Reporters.use!

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'google/amp/cache'
