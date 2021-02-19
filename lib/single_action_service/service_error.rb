class SingleActionService::ServiceError
  attr_accessor :code, :name, :data_converter

  def initialize(code: nil, name: nil, data_converter: ->(data) { data })
    @code = code
    @name = name
    @data_converter = data_converter
  end
end
