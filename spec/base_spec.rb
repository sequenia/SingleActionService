class DiscountApplicator < SingleActionService::Base
  ERROR_CODE = 0

  def call(valid)
    if valid
      success
    else
      error(code: ERROR_CODE)
    end
  end
end

RSpec.describe SingleActionService::Base do
  it "successful action service" do
    expect(DiscountApplicator.new.call(true).success?).to eq(true)
  end

  it "errorful action service" do
    expect(DiscountApplicator.new.call(false).error?).to eq(true)
  end
end
