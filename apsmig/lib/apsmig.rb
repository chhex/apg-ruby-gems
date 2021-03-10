require "apsmig/version"
require "apscli"
require 'json'
module Apsmig
  class Error < StandardError; end
  def self.migrate(patchJson)
    puts "Migrating from : #{JSON.pretty_generate(patchJson)}"
    patch = migratePatch(patchJson)
    puts "To: #{Aps::Api::asJsonString(patch)}"
  end
  def self.migratePatch(from)
    Aps::Api::Patch
      .builder()
      .patchNumber(from["patchNummer"])
      .tagNr(from["tagNr"])
      .dockerServices(migrateDockerServices(from))
      .dbPatch(migrateDbPatch(from))
      .services(migrateService(from)).build()
  end
  def self.migrateDbPatch(from)
    Aps::Api::DBPatch
      .builder()
      .dbPatchBranch(from["dbPatchBranch"])
      .prodBranch(from["prodBranch"])
      .patchTag(from["patchTag"])
      .dbObjects(migrateDbObjects(from))
      .build()
  end
  def self.migrateDbObjects(from)
    list = Aps::Api::Lists.newArrayList()
    from["dbObjects"].each do
      |dbObject|
      list.add(Aps::Api::DbObject
                 .builder()
                 .fileName(dbObject["fileName"])
                 .filePath(dbObject["filePath"])
                 .moduleName(dbObject["moduleName"])
                 .hasConflict(false)
                 .build())
    end
    list
  end
  def self.migrateService(from)
    service = Aps::Api::Service
                .builder()
                .serviceName("it21")
                .patchTag(from["patchTag"])
                .artifactsToPatch(migrateMavenArtifacts(from))
                .build()
    Aps::Api::Lists.newArrayList(service)
  end
  def self.migrateMavenArtifacts(from)
    list = Aps::Api::Lists.newArrayList()
    from["mavenArtifacts"].each do
      |artifact|
      list.add(Aps::Api::MavenArtifact
        .builder()
        .artifactId(artifact["artifactId"])
        .groupId(artifact["groupId"])
        .name(artifact["name"])
        .dependencyLevel(artifact["dependencyLevel"])
        .version(artifact["version"]).build())
    end
    list
  end
  def self.migrateDockerServices(from)
    Aps::Api::Lists.newArrayList(from["dockerServices"])
  end

end
