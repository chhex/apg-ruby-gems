# frozen_string_literal: true

# The Module providing a Sequel Connection
module Sequel
  require 'sequel'
  # This class provides a Sequel connections based on Naming standards
  class Connection
    attr_reader :target
    def initialize(target)
      @target = target
    end

    def connect(user, pw)
      url = "jdbc:oracle:thin:#{user}/#{pw}@#{@target}.apgsga.ch:1521:#{@target}"
      Sequel.connect(url)
    end
  end
end
