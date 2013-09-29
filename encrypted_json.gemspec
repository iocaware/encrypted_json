# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encrypted_json/version'

Gem::Specification.new do |spec|
  spec.name          = "encrypted_json"
  spec.version       = EncryptedJson::VERSION
  spec.authors       = ["Matt Jezorek"]
  spec.email         = ["mjezorek@gmail.com"]
  spec.description   = %q{This gem will enable you to sign and encrypt JSON for webservice calls or other reasons with public/private keys}
  spec.summary       = %q{Public/Private key encryption and signing of JSON}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
