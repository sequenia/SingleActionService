class SingleActionService::ServiceError
  attr_accessor :code, :name

  def initialize(code: nil, name: nil)
    @code = code
    @name = name
  end
end
