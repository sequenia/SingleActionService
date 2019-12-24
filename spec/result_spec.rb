def result(status = true)
  SingleActionService::Result.new(status)
end

RSpec.describe SingleActionService::Result do
  it "instance variable status defined?" do
    expect(result.instance_variable_defined?(:@status)).to eq(true)
  end

  it "instance variable data defined?" do
    expect(result.instance_variable_defined?(:@data)).to eq(true)
  end

  it "instance variable error_code defined?" do
    expect(result.instance_variable_defined?(:@error_code)).to eq(true)
  end

  it "result success?" do
    expect(result.success?).to eq(true)
  end

  it "result error?" do
    expect(result(false).error?).to eq(true)
  end
end
