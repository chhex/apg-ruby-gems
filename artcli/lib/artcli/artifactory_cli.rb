# frozen_string_literal: true

module Artcli
  require 'artifactory'
  require 'tty-progressbar'
  class Cli
    attr_reader :art_client, :dry_run

    def initialize(base_uri, user, passwd, dry_run = false)
      @dry_run = dry_run
      @art_client = Artifactory::Client.new(endpoint:  "https://#{base_uri}", username: user, password: passwd)
    end

    def get_storage_info_all
      result = @art_client.get('/api/storageinfo')
      data = result['repositoriesSummaryList']
      data
      hsh = Hash.new
      data.each do |row|
        hsh[row['repoKey']] = row
      end
      hsh
    end

    def get_storage_info(repo)
      hsh = get_storage_info_all
      hsh[repo]
    end


    def list_repositories(user_filter = '')
      local_repos = @art_client.get('/api/repositories', { 'type' => 'local' })
      filtered_repos = []
      local_repos.each do |repo|
        next unless user_filter.empty? || repo['key'].include?(user_filter.to_s)
        filtered_repos << repo['key']
      end
      filtered_repos
    end



    def list_artifacts_recursive(parent_path, output,progress)
      progress.advance
      storage = @art_client.get(parent_path)
      children = storage['children']
      children.each do |child|
        if child['folder'] == true
          list_artifacts_recursive(parent_path + child['uri'], output,progress)
        else
          progress.advance
          details_artifact(parent_path + child['uri'], output)
        end
      end
    end

    def details_artifact(path, output)

      detail = @art_client.get(path)
      parts = detail['path'].split("/")
      file_name = parts.pop
      version = parts.pop
      artifact_id = parts.pop
      group_id = parts.join(".")
      output << [group_id, artifact_id, version, file_name, detail['path'], detail['lastUpdated'], detail['size'], detail['mimeType']]
    end

    def list_storage_uris_first_level(repositories = [])
      storage_uris = []
      if repositories.empty?
        puts 'Empty repositories list, nothing to do'
        return storage_uris
      end
      puts "About to retrieve the first level storage uri's of the following repositories: #{repositories}"
      repositories.each do |repo_name|
        storage = @art_client.get("/api/storage/#{repo_name}")
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
      storage_uris.each do |uri|
        if !dry_run
          puts "#{uri} will be deleted"
          @art_client.delete(uri.to_s)
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
      storage_uris_to_deleted = list_storage_uris_first_level(selected_repos)
      puts "The following storage uri's have been selected to be cleaned: #{storage_uris_to_deleted}"
      ok = ask('Ok to proceed y/n: ')
      if ok != 'y'
        puts 'Processing is being terminated'
        exit
      end
      pp clean_repositories(storage_uris_to_deleted)
    end
  end
  class CsvReport
    attr_reader :art_cli, :output_file_name, :col_sep

    def initialize(art_cli,output_file_name = 'report.csv',col_sep = ',')
      @art_cli = art_cli
      @output_file_name = output_file_name
      @col_sep = col_sep
    end
    def artifacts_report(repository)
      data = @art_cli.get_storage_info(repository)
      total = data['foldersCount'] + data['filesCount']
      puts "About to process #{total} Artifactory items (folders, artifacts) of repository : #{repository}. The output is written to #{@output_file_name} "
      progress = TTY::ProgressBar.new("Progress: [:bar] :current/:total :percent ET::elapsed ETA::eta :rate/s", total: total, bar_format: :box, incomplete: " ")
      CSV.open(@output_file_name, "w", col_sep: @col_sep) do |csv|
        csv << %w[group_id artifact_id version path lastUpdated size mimeType]
        @art_cli.list_artifacts_recursive("/api/storage/#{repository}",csv,progress)
      end
    end

    def storage_info_report
      puts "Generating Artifactory storage info report to: <#{@output_file_name}> "
      data = @art_cli.get_storage_info_all
      sorted_data = data.values.sort_by { |hsh| if hsh["usedSpace"] == '0 bytes'
                                                  -1
                                                else
                                                  Filesize.from(hsh["usedSpace"]).to_i
                                                end}.reverse
      CSV.open(@output_file_name, "w", col_sep: @col_sep) do |csv|
        first = nil
        sorted_data.each do |hsh|
          if hsh['repoKey'] != 'TOTAL'
            if !first
              first = true
              csv << hsh.keys
            end
            csv << hsh.values
          end
        end
      end
      puts "Generated Artifactory storage info report to: <#{@output_file_name}>  done."
    end
  end
end
