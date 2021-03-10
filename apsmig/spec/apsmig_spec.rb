RSpec.describe Apsmig do
  it "has a version number" do
    expect(Apsmig::VERSION).not_to be nil
  end

  it "Simple Test" do
    file = File.read('./testdata/old/Patch7464.json')
    Apsmig::migrate(JSON.parse(file))
  end
end
