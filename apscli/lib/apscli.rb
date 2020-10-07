require 'apscli/version'
require 'java'
require_relative './apg-patch-cli-fat-2.0.DEVD1.jar'
# Wraooer
module Apscli
  class Error < StandardError; end

  def self.run(args)
    puts 'Running groovy apscli from ruby'
    cli = com.apgsga.patch.service.client.PatchCli.create()
    cli.process(args)
  end
  class Runner
    include Apscli
  end
end
