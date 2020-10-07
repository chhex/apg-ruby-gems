require_relative 'lib/apgsecrets/version'
Gem::Specification.new do |spec|
  spec.name          = "apgsecrets"
  spec.version       = Secrets::VERSION
  spec.authors       = ["Christoph Henrici"]
  spec.email         = ["chhenrici@gmail.com"]

  spec.summary       = %q{Gem for Prompting and caching passwords}
  spec.description   = %q{This Gem supports the prompting and temporary caching of passwords}
  spec.homepage      = "http://apg.ch"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.platform = 'java'

  spec.metadata["allowed_push_host"] = "https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGems"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/apgsga-it/apgsecrets.git"
  spec.add_dependency 'bcrypt','~> 3.1', '3.1.15 '
  spec.add_dependency 'filecache',  '~> 1.0', '>= 1.0.2'
  spec.add_dependency  'highline',  '~> 2.0', '>= 2.0.1'
  spec.files = Dir[ 'lib/**/*' ,'Gemfile',  '*.gemspec']
  spec.require_paths = ["lib"]
end
