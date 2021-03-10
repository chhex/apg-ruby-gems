require_relative 'lib/apscli/version'

Gem::Specification.new do |spec|
  spec.name          = "apscli"
  spec.version       = Aps::VERSION
  spec.authors       = ["Christoph Henrici"]
  spec.email         = ["chhenrici@gmail.com"]

  spec.summary       = %q{A Jruby Gem Wrapper for apscli}
  spec.description   = %q{A Jruby Wrapper of the apscli jar. This gem does'nt provide any other functionality}
  spec.homepage      = "http://apg.ch"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.platform = 'java'

  spec.metadata["allowed_push_host"] = "https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGems"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/apg-ruby-gems.git"

  spec.files = Dir[ 'lib/**/*' ,'Gemfile',  '*.gemspec']
  spec.bindir        = "bin"
  spec.executables   = 'apscli'
  spec.require_paths = ["lib"]
end
