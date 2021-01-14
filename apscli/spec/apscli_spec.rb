require 'apscli'
RSpec.describe Apscli do
  it 'has a version number' do
    expect(::Apscli::VERSION).not_to be nil
  end

  it('Test Default Invocation') do
    expect{Apscli.run('-h')}.to output(/usage: apspli.sh/).to_stdout_from_any_process
  end

  it('Build Patch') do
    dbPatch = Apscli::ApsApi::DBPatch.builder().dbPatchBranch("db_patch_branch").prodBranch("prod_branch").build()
    dbPatch.addDbObject(Apscli::ApsApi::DbObject.builder().
        fileName("somefileName").
        filePath("a/b/c").moduleName("Dboject1").build())
    dbPatch.addDbObject(Apscli::ApsApi::DbObject.builder().
        fileName("anotherFile").
        filePath("a/b/d").moduleName("Dboject2").build())
    patch = Apscli::ApsApi::Patch.builder().patchNumber("9300")
                       .dbPatch(dbPatch)
                       .developerBranch("developer_branch")
                       .dockerServices(Apscli::ApsApi::Lists.newArrayList("dockerService1", "dockerService2", "dockerServices3"))
                       .services(Apscli::ApsApi::Lists.newArrayList(
                         Apscli::ApsApi::Service.builder().serviceName("aService").
                           artifactsToPatch(Apscli::ApsApi::Lists.newArrayList(
                             Apscli::ApsApi::MavenArtifact.builder().artifactId("someId").groupId("grpId").version("1.0").build(),
                             Apscli::ApsApi::MavenArtifact.builder().artifactId("anotherId").groupId("anotherGrpId").version("1.1").build()
                           )).build()
                       ))
    expect(patch.build())
  end

end
