RSpec.describe Apsmig do
  it "has a version number" do
    expect(Apsmig::VERSION).not_to be nil
  end

  it "Patch 7464 migrated correctly" do
    file = File.read('./testdata/migrate/Patch7464.json')
    patch = Apsmig::PatchMigratorFactory::migrate(JSON.parse(file))
    expect(patch)
    expect(patch.patchNumber).to eq("7464")
    expect(patch.developerBranch).to eq("")
    expect(patch.tagNr).to eq(3)
    expect(patch.dbPatch)
    expect(patch.dbPatch.dbPatchBranch).to eq("patch_7464")
    expect(patch.dbPatch.prodBranch).to eq("prod")
    expect(patch.dbPatch.patchTag).to eq("patch_7464_3")
    expect(patch.dbPatch.dbObjects).not_to be_empty
    expect(patch.dbPatch.dbObjects.size()).to eq(1)
    dbObject = patch.dbPatch.dbObjects.first
    expect(dbObject)
    expect(dbObject.fileName).to eq("arep.vk.xml")
    expect(dbObject.filePath).to eq("com.affichage.it21.masterdaten.arep/src/main/sql/")
    expect(dbObject.moduleName).to eq("com.affichage.it21.masterdaten.arep")
    expect(dbObject.hasConflict).to eq(false) # TODO (jhe, uge 11.3) : verify
    expect(patch.dockerServices).to be_empty
    expect(patch.services).not_to be_empty
    expect(patch.services.size()).to eq(1)
    service = patch.services.first
    expect(service)
    expect(service.serviceName).to eq("it21")
    expect(service.patchTag).to eq("patch_7464_3")
    expect(service.serviceMetaData).to be_nil  # TODO (jhe, uge, che 11.3) : verify
    expect(service.artifactsToPatch).not_to be_empty
    expect(service.artifactsToPatch.size()).to eq(1)
    artifact = service.artifactsToPatch.first
    expect(artifact.artifactId).to eq("dao-vk-domainwerte")
    expect(artifact.groupId).to eq("com.affichage")
    expect(artifact.name).to eq("com.affichage.it21.domainwerte.vk")
    expect(artifact.version).to eq("9.1.0.ADMIN-UIMIG-SNAPSHOT")
    expect(artifact.dependencyLevel).to eq(0)
    File.write('./testdata/output/Patch7464.json', Aps::Api::asJsonString(patch))
  end
end
