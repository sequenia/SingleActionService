class SingleActionService::Base
  protected

  class << self
    unless respond_to?(:module_parent)
      include SingleActionService::ModuleHelper
    end

    def errors(errors_data = nil)
      return @errors if errors_data.nil?

      parse_errors(errors_data)
      create_result_class
      define_methods_to_create_error_results
    end

    def parse_errors(errors_data)
      @errors = errors_data.map do |error_data|
        SingleActionService::ServiceError.new(**error_data)
      end
    end

    def create_result_class
      demodulized_name = name.split('::').last
      result_class_name = "#{demodulized_name}Result"
      return if module_parent.const_defined?(result_class_name)

      errors = @errors
      @result_class = Class.new(SingleActionService::Result) do
        def self.define_error_checking_method(error)
          method_name = "#{error.name}_error?"

          define_method(method_name) do
            error_code == error.code
          end
        end

        errors.each do |error|
          define_error_checking_method(error)
        end
      end

      module_parent.const_set(result_class_name, @result_class)
    end

    def define_methods_to_create_error_results
      @errors.each do |error_object|
        data_converter = error_object.data_converter

        if data_converter.is_a?(Symbol)
          data_converter = data_converters[error_object.data_converter]
        end

        result_method_name = "#{error_object.name}_error"
        define_method(result_method_name) do |data = nil|
          error(code: error_object.code, data: data_converter.call(data))
        end
      end
    end

    def result_class
      @result_class ||= SingleActionService::Result
    end

    def data_converters
      @data_converters ||= {
        detailed_messages: ->(object) do
          object.errors.detailed_messages(wrap_attributes_to: :fields)
        end
      }
    end
  end

  def success(data = nil)
    SingleActionService::Result.new(true, data: data)
  end

  def error(data: nil, code: nil)
    SingleActionService::Result.new(false, data: data, error_code: code)
  end
end
