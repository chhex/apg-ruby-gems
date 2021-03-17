require_relative 'lib/apsmig/version'

Gem::Specification.new do |spec|
  spec.name          = "apsmig"
  spec.version       = Apsmig::VERSION
  spec.authors       = ["Christoph Henrici"]
  spec.email         = ["chhenrici@gmail.com"]

  spec.summary       = %q{Migration Gem for Multiservice_cm Introduction}
  spec.description   = %q{Migrates the Patch*.json Files from Java8Mig to Multiservice_cm}
  spec.homepage      = "http://apg.ch"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.platform = 'java'

  spec.metadata["allowed_push_host"] = "https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGems"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/apgsga-it/apg-ruby-gems.git"

  spec.add_dependency 'slop',  '~> 4.8', '>= 4.8.2'
  spec.add_dependency 'apscli',  '~> 0.8', '>= 0.8.2'
  spec.add_dependency 'tty-spinner'

  spec.files = Dir[ 'lib/**/*' ,'Gemfile',  '*.gemspec']

  spec.bindir        = "bin"
  spec.executables   = 'apsmig'
  spec.require_paths = ["lib"]
end
