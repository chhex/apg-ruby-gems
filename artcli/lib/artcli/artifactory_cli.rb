# frozen_string_literal: true

module Artcli
  require 'artifactory'
  require 'json'
  class Cli
    attr_reader :base_uri, :user, :passwd, :dry_run

    def initialize(base_uri, user, passwd, dry_run = false)
      @user = user
      @passwd = passwd
      @base_uri = "https://#{base_uri}"
      @dry_run = dry_run
    end

    def list_repositories(user_filter = '')
      client = Artifactory::Client.new(endpoint: @base_uri, username: @user, password: @passwd)
      local_repos = client.get('/api/repositories', { 'type' => 'local' })
      filtered_repos = []
      local_repos.each do |repo|
        next unless user_filter.empty? || repo['key'].include?(user_filter.to_s)

        filtered_repos << repo['key']
      end
      filtered_repos
    end

    def list_storage_uris(repositories = [])
      storage_uris = []
      if repositories.empty?
        puts 'Empty repositories list, nothing to do'
        return storage_uris
      end
      puts "About to retrieve the first level storage uri's of the following repositories: #{repositories}"
      client = Artifactory::Client.new(endpoint: @base_uri, username: @user, password: @passwd)
      repositories.each do |repo_name|
        storage = client.get("/api/storage/#{repo_name}")
        puts storage
        children = storage['children']
        children.each do |child|
          storage_uris << "#{@base_uri}/#{repo_name}#{child['uri']}"
        end
      end
      storage_uris
    end

    def clean_repositories(storage_uris = [], dry_run = false)
      if storage_uris.empty?
        puts 'Nothing to clean, filtered repositories empty'
        return
      end
      client = Artifactory::Client.new(endpoint: @base_uri, username: @user, password: @passwd)
      storage_uris.each do |uri|
        if !dry_run
          puts "#{uri} will be deleted"
          client.delete(uri.to_s)
          puts 'done'
        else
          puts "dry run: #{uri} would be deleted"
        end
      end
    end

    def clean_repositories_interactive(user_filter = '')
      puts "Filtered Local Repositories with filter: #{user_filter} "
      selected_repos = list_repositories(user_filter)
      puts "The following repos have been selected to be cleaned: #{selected_repos}"
      ok = ask('Ok to proceed y/n: ')
      if ok != 'y'
        puts 'Processing is beeing terminated'
        exit
      end
      storage_uris_to_deleted = command.list_storage_uris(selected_repos)
      puts "The following storage uri's have been selected to be cleaned: #{storage_uris_to_deleted}"
      ok = ask('Ok to proceed y/n: ')
      if ok != 'y'
        puts 'Processing is beeing terminated'
        exit
      end
      pp command.clean_repositories(storage_uris_to_deleted)
    end
  end
end
