RSpec.describe Secrets do
  it 'has a version number' do
    expect(::Secrets::VERSION).not_to be nil
  end

  it 'Test save, retrieve and exists of User Password' do
    s = Secrets::Store.new
    s.save('someuser', 'verysecrectpassword')
    expect(s.exist('someuser')).to eq(true)
    expect(s.retrieve('someuser')).to eq('verysecrectpassword')
  end

  it 'Test user not exists' do
    s = Secrets::Store.new
    expect(s.exist('someuserother')).to eq(false)
  end

  it 'Test Retrieval not exists' do
    s = Secrets::Store.new
    expect{s.retrieve('verydifferentuser')}.to raise_error(an_instance_of(Secrets::SecretsError).and having_attributes(message: 'User verydifferentuser has not been saved'))
  end

  it 'Test prompt for input' do
    input    = StringIO.new
    output   = StringIO.new
    password = 'Somepassword'
    input << password << "\n"
    input.rewind
    s = Secrets::Store.new('test',10,input,output)
    result = s.prompt('Some Display text')
    expect(result).to eq(password)
  end

  it 'Test prompt for input and save' do
    input    = StringIO.new
    output   = StringIO.new
    password = 'Somepassword'
    input << password << "\n"
    input.rewind
    s = Secrets::Store.new('test',10,input,output)
    result = s.prompt_and_save('yetanotheruser', 'Some Display text')
    expect(result).to eq(password)
    expect(s.exist('yetanotheruser')).to eq(true)
    expect(s.retrieve('yetanotheruser')).to eq('Somepassword')
  end

  it 'Test prompt for input and save when exists' do
    s = Secrets::Store.new
    s.save('andyetanother', 'verysecrectpassword')
    result = s.prompt_only_when_not_exists('andyetanother', 'Some Display text')
    expect(result).to eq('verysecrectpassword')
    expect(s.exist('andyetanother')).to eq(true)
  end

  it 'Test prompt for input and save when not exists' do
    input    = StringIO.new
    output   = StringIO.new
    password = 'Somepassword'
    input << password << "\n"
    input.rewind
    s = Secrets::Store.new('test',10,input,output)
    s.prompt_only_when_not_exists('yetanotheruserrrrrr', 'Some Display text')
    expect(s.exist('yetanotheruserrrrrr')).to eq(true)
    expect(s.retrieve('yetanotheruserrrrrr')).to eq('Somepassword')
  end

end
