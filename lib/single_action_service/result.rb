module SingleActionService
  class Result
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

      raise InvalidResult.new(self)
    end
  end
end
