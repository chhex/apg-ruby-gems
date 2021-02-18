require "apgsecrets/version"

module Secrets
  require 'openssl'
  require 'tmpdir'
  require 'filecache'

  class Store
    attr_reader :cache, :input, :output

    def initialize(domain = 'credentials', expiry = 600, input = $stdin, output = $stdout)
      @input = input
      @output = output
      @cache = FileCache.new(domain, "#{Dir.tmpdir}/apgsecrets", expiry, 1)
    end

    def save(user, password)
      @cache.set(user, encrypt(password))
    end

    def prompt(text)
      @output.print("#{text}")
      if @input.tty?
        inp = @input.noecho(&:gets)
      else
        inp = @input.gets
      end
      inp.strip!
    end

    def prompt_and_save(user, text)
      pw = prompt(text)
      save(user, pw)
      pw
    end


    def prompt_only_when_not_exists(user, text, force = false)
      if force
        return prompt_and_save(user,text)
      end
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
