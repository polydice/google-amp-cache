require 'bundler/setup'

require 'minitest/autorun'
require 'minitest/spec'
require "minitest/reporters"
Minitest::Reporters.use!

$:.unshift File.expand_path("../../lib", __FILE__)
require 'google/amp/cache'