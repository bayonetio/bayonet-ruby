# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bayonet_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'bayonet_client'
  spec.version       = BayonetClient::VERSION
  spec.authors       = ['Bayonet']
  spec.email         = ['support@bayonet.io']

  spec.summary       = %q{Bayonet Ruby API Gem}
  spec.description   = %q{Bayonet Ruby API. See https://bayonet.io for details.}
  spec.homepage      = 'https://bayonet.io'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'httparty', '~> 0.11.0'

  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'rake'
end
