# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google/amp/cache/version'

Gem::Specification.new do |spec|
  spec.name          = 'google-amp-cache'
  spec.version       = Google::AMP::Cache::VERSION
  spec.authors       = ['Richard Lee']
  spec.email         = ['rl@polydice.com']

  spec.required_ruby_version = '>= 2.4.0'

  spec.summary       = 'A Ruby wrapper for Google AMP Cache API'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/polydice/google-amp-cache'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'LICENSE.txt', 'CHANGELOG.md', 'README.md']
  spec.test_files    = Dir['test/**/*', 'Rakefile']
  spec.executables   = Dir.glob('bin/*').map { |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday', '~> 1.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 1.0'
  spec.add_runtime_dependency 'rack'

  spec.add_development_dependency 'minitest', '~> 5.3'
  spec.add_development_dependency 'minitest-reporters', '~> 1.2'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'timecop', '~> 0.9.1'
  spec.add_development_dependency 'webmock', '~> 3.9.1'
end
