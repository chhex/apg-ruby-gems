require 'apscli/version'
require 'java'
require_relative './apg-patch-cli-fat.jar'

# Wrapper
module Aps
  class Error < StandardError; end


  class Cli
    def self.run(args)
      include_package 'com.apgsga.patch.service.client'
      puts "Running groovy apscli from ruby, version: #{VERSION}"
      cli = PatchCli.create()
      cli.process(args)
    end
  end
  class Api
    include_package 'com.apgsga.microservice.patch.api'
    java_import com.fasterxml.jackson.databind.ObjectMapper
    java_import com.google.common.collect.Lists
    java_import java.io.File
    java_import org.apache.commons.io.FileUtils
    def self.makeList(*elems)
      return Lists.newArrayList(elems)
    end
    def self.makeFile(*args)
      return File.new(args)
    end
    def self.makeFile(file_name)
      return File.new(file_name)
    end
    def self.makeMapper()
      return ObjectMapper.new()
    end
    def self.asJsonString(obj)
      return makeMapper().writerWithDefaultPrettyPrinter().writeValueAsString(obj)
    end
    def self.asJsonFile(obj,file_name)
      json = makeMapper().writerWithDefaultPrettyPrinter().writeValueAsString(obj)
      fl = makeFile(file_name)
      FileUtils.writeStringToFile(fl,json)
    end
  end
end
