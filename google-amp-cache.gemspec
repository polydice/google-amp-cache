
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "google/amp/cache/version"

Gem::Specification.new do |spec|
  spec.name          = "google-amp-cache"
  spec.version       = Google::AMP::Cache::VERSION
  spec.authors       = ["Richard Lee"]
  spec.email         = ["rl@polydice.com"]

  spec.summary       = %q{A Ruby wrapper for Google AMP Cache API}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/polydice/google-amp-cache"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "multi_json", "~> 1.3"
  spec.add_runtime_dependency "httparty", ">= 0.7.6"
  spec.add_runtime_dependency "rack"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.3"
  spec.add_development_dependency "minitest-reporters", "~> 1.2"
end
