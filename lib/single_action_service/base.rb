module SingleActionService
  class Base
    protected

    def success(data = nil)
      Result.new(true, data: data)
    end

    def error(data = nil, code: nil)
      Result.new(false, data: data, error_code: code)
    end
  end
end
