class SingleActionService::Base
  protected

  def success(data = nil)
    SingleActionService::Result.new(true, data: data)
  end

  def error(data: nil, code: nil)
    SingleActionService::Result.new(false, data: data, error_code: code)
  end
end
