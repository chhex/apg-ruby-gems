require "apsmig/version"
require "apscli"
require 'json'
module Apsmig
  class Error < StandardError; end

  class PatchMigratorFactory
    def self.migrate(patchJson)
      migratePatch(patchJson)
    end
    def self.migratePatch(from)
      Aps::Api::Patch
        .builder()
        .patchNumber(from["patchNummer"])
        .tagNr(from["tagNr"])
        .developerBranch(from["developerBranch"])
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
                  .serviceMetaData(migrateServiceMetaInfo())
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
      if !from["dockerServices"]
        return Aps::Api::Lists.newArrayList()
      end
      Aps::Api::Lists.newArrayList(from["dockerServices"])
    end
    def self.migrateServiceMetaInfo
      pkgs = Aps::Api::Lists.newArrayList()
      pkgs.add(Aps::Api::Package
                 .builder()
                 .pkgServiceName("it21-ui")
                 .packagerName("it21-ui-pkgs/ui")
                 .starterCoordinates(Aps::Api::Lists.newArrayList(
                   "com.affichage.it21.ui:it21-ui-runtime",
                   "com.apgsga.it21.ui.mdt:it21ui-app-starter",
                   "com.apgsga.it21.ui.mdt:javaforms-starter",
                   "com.apgsga.it21:lasttests-jfmt",
                   "org.springframework.boot:spring-boot-starter-tomcat",
                   "moyosoft:moyocore_x64:3.0.4:@dll"
                 ))
                 .build())
      pkgs.add(Aps::Api::Package
                .builder()
                .pkgServiceName("jadas")
                .packagerName("it21-ui-pkgs/server")
                .starterCoordinates(Aps::Api::Lists.newArrayList(
                  "com.apgsga.it21.ui.mdt:jadas-app-starter",
                  "com.apgsga.it21.ui.mdt:jadas-framework-starter"
                 ))
                .build())
      bomCoordinates = Aps::Api::MavenArtifact
                   .builder()
                   .artifactId("dm-bom")
                   .groupId("com.affichage.common.maven")
                   .name("_dm_bom")
                   .version("9.1.0.ADMIN-UIMIG-SNAPSHOT").build()
     Aps::Api::ServiceMetaData
                  .builder()
                  .serviceName("it21")
                  .revisionPkgName("it21-ui-pkgs/revision")
                  .microServiceBranch("it21_release_9_1_1_admin_uimig")
                  .baseVersionNumber("9.1.0")
                  .revisionMnemoPart("ADMIN-UIMIG")
                  .bomCoordinates(bomCoordinates)
                  .packages(pkgs)
                  .build()

    end
  end
  class MigrationRequest
    attr_reader :target_folder,:source_folder
    def initialize(source_folder,target_folder)
      @target_folder = target_folder
      @source_folder = source_folder
    end
    def execute
      raise "Source Folder <#{@source_folder}> is not a directory" if !File.directory?(@source_folder)
      raise "Target Folder <#{@target_folder}> is not a directory" if !File.directory?(@target_folder)
      raise "Source Folder <#{@sourcdce_folder}> is not readable" if !File.readable?(@source_folder)
      raise "Target Folder <#{@target_folder}> is not writeable" if !File.writable?(@target_folder)
      file_cnt = 0
      Dir.glob("Patch[0-9]*.json", base: @source_folder) do |filename|
        file_content = File.read(File.join(@source_folder,filename))
        patch = Apsmig::PatchMigratorFactory::migrate(JSON.parse(file_content))
        target_file = File.join(@target_folder,filename)
        File.write(target_file , Aps::Api::asJsonString(patch))
        file_cnt += 1
      end
      file_cnt
    end
  end
end
