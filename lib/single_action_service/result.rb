class SingleActionService::Result
  attr_accessor :status, :data, :error_code

  def initialize(status, data: nil, error_code: nil)
    @status = status
    @data = data
    @error_code = error_code
  end

  def success?
    status
  end

  def error?
    !success?
  end

  def data!
    return data if success?

    raise SingleActionService::InvalidResult, self
  end
end
