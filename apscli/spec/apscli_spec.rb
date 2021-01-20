require 'apscli'
RSpec.describe Aps do
  it 'has a version number' do
    expect(::Aps::VERSION).not_to be nil
  end

  it('Test Default Invocation') do
    expect{Aps::Cli.run('-h')}.to output(/usage: apspli.sh/).to_stdout_from_any_process
  end

  it('Build Patch') do
    dbPatch = Aps::Api::DBPatch.builder().dbPatchBranch("db_patch_branch").prodBranch("prod_branch").build()
    dbPatch.addDbObject(Aps::Api::DbObject.builder().
        fileName("somefileName").
        filePath("a/b/c").moduleName("Dboject1").build())
    dbPatch.addDbObject(Aps::Api::DbObject.builder().
        fileName("anotherFile").
        filePath("a/b/d").moduleName("Dboject2").build())
    patch = Aps::Api::Patch.builder().patchNumber("9300")
                       .dbPatch(dbPatch)
                       .developerBranch("developer_branch")
                       .dockerServices(Aps::Api::makeList("dockerService1", "dockerService2", "dockerServices3"))
                       .services(Aps::Api::makeList(
                         Aps::Api::Service.builder().serviceName("aService").
                           artifactsToPatch(Aps::Api::makeList(
                             Aps::Api::MavenArtifact.builder().artifactId("someId").groupId("grpId").version("1.0").build(),
                             Aps::Api::MavenArtifact.builder().artifactId("anotherId").groupId("anotherGrpId").version("1.1").build()
                           )).build()
                       ))
    result = patch.build()
    json = Aps::Api::asJsonString(result)
    puts json
    Aps::Api::asJsonFile(result,"testoutput/Test.json")
    expect(json)
  end

end
