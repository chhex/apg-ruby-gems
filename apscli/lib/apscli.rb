require 'apscli/version'
require 'java'
require_relative './apg-patch-cli-fat.jar'

# Wrapper
module Apscli
  class Error < StandardError; end

  def self.run(args)
    include_package 'com.apgsga.patch.service.client'
    puts "Running groovy apscli from ruby, version: #{VERSION}"
    cli = PatchCli.create()
    cli.process(args)
  end
  class Runner
    include Apscli
  end
  class ApsApi
    include_package 'com.apgsga.microservice.patch.api'
    java_import com.fasterxml.jackson.databind.ObjectMapper
    java_import com.google.common.collect.Lists
    java_import java.io.File
  end
end
