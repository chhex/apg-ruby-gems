require 'apscli'
RSpec.describe Apscli do
  it 'has a version number' do
    expect(::Apscli::VERSION).not_to be nil
  end

  it('Test Default Invocation') do
    expect{Apscli.run('-h')}.to output(/usage: apspli.sh/).to_stdout_from_any_process
  end

end
