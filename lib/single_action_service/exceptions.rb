# frozen_string_literal: true

module SingleActionService
  class Error < StandardError; end

  class InvalidResult < ArgumentError
    attr_reader :result

    def initialize(result)
      @result = result
    end
  end
end
