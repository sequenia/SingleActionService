RSpec.describe SingleActionService do
  it "has a version number" do
    expect(SingleActionService::VERSION).not_to be nil
  end

  it 'kind of SingleActionService' do
    should be_kind_of(Module)
  end
end
