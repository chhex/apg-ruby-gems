require "apgsecrets/version"

module Secrets
  require 'openssl'
  require 'tmpdir'
  require 'filecache'
  require 'readline'
  require 'highline/import'

  class Store
    attr_reader :cache, :terminal

    def initialize(expiry = 600, input = $stdin, output = $stdout)
      @terminal = HighLine.new(input, output)
      @cache = FileCache.new("credentials", "#{Dir.tmpdir}/apgsecrets", 600, 1)
    end

    def save(user, password)
      @cache.set(user, encrypt(password))
    end

    def prompt(text)
      if @terminal.input.tty?
        @terminal.ask("#{text}") { |q| q.echo = false }
      else
        @terminal.ask("#{text}")
      end
    end

    def prompt_and_save(user, text)
      pw = if @terminal.input.tty?
             @terminal.ask("#{text}") { |q| q.echo = false }
           else
             @terminal.ask("#{text}")
           end
      save(user, pw)
      pw
    end


    def prompt_only_when_not_exists(user, text)
      if exist(user)
        return retrieve(user)
      end

      prompt_and_save(user, text)
    end

    def exist(user)
      c = @cache.get(user)
      c != nil
    end

    def retrieve(user)
      raise Secrets::SecretsError, "User #{user} has not been saved" if !exist(user)

      c = @cache.get(user)
      decrypt(c)
    end

    private def encrypt(pw)
      cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
      key = cipher.random_key
      cipher.key = key
      s = cipher.update(pw) + cipher.final
      Credentials.new(key, s.unpack('H*')[0].upcase)
    end

    private def decrypt(user)
      cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
      cipher.key = user.key
      s = [user.pw].pack("H*").unpack("C*").pack("c*")
      cipher.update(s) + cipher.final
    end
  end

  class Credentials
    attr_reader :key, :pw

    def initialize(key, pw)
      @key = key
      @pw = pw
    end
  end

  class SecretsError < StandardError; end
end
