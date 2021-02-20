errors_data = [
  { name: :one, code: :'namespace_one.one_error' },
  { name: :two, code: :'namespace_two.two_error' }
]

# rubocop:disable Metrics/BlockLength
RSpec.describe SingleActionService::Base do
  let(:service_class_name_without_module) { 'TestService' }
  let(:service_class) do
    class_object = Class.new(described_class) do
      def self.name
        # Closure does not work here =(
        # So, can not call a method - should hardcode.
        'SingleActionService::TestService'
      end
    end

    SingleActionService.const_set(
      service_class_name_without_module,
      class_object
    )

    class_object.errors(errors_data)
    class_object
  end

  let(:result_class_name) { "#{service_class.name}Result" }
  let(:result_class_name_without_module) do
    "#{service_class_name_without_module}Result"
  end

  after(:each) do
    const_names_to_remove = [service_class_name_without_module,
                             result_class_name_without_module]

    const_names_to_remove.each do |const_name|
      service_class.module_parent.send(:remove_const, const_name)
    end
  end

  let(:service) { service_class.new }

  describe '.errors' do
    it 'should set right count of errors to class' do
      expect(service_class.errors.size).to eq(errors_data.size)
    end

    it 'should convert errors data to error classes' do
      service_class.errors.each do |error|
        expect(error).to be_a(SingleActionService::ServiceError)
      end
    end

    it 'should fill error names' do
      service_class.errors.each_with_index do |error, index|
        error_data = errors_data[index]
        expect(error.name).to eq(error_data[:name])
      end
    end

    it 'should fill error codes' do
      service_class.errors.each_with_index do |error, index|
        error_data = errors_data[index]
        expect(error.code).to eq(error_data[:code])
      end
    end

    it 'should define class for result based on service class name' do
      result_class_defined = service_class.module_parent.const_defined?(
        result_class_name_without_module
      )
      expect(result_class_defined).to be(true)
    end

    it 'should provide accessor for service result class' do
      result_class = service_class.result_class
      expect(result_class.name).to eq(result_class_name)
    end
  end

  describe '#success' do
    let(:data) { 'Success Data' }
    let(:result) { service.send(:success, data) }

    it 'should return result object' do
      expect(result).to be_a(SingleActionService::Result)
    end

    it 'should return result with success' do
      expect(result.success?).to eq(true)
    end

    it 'should return result with data' do
      expect(result.data).to eq(data)
    end
  end

  describe '#error' do
    let(:data) { 'Error Data' }
    let(:error_code) { 1 }
    let(:result) { service.send(:error, data: data, code: error_code) }

    it 'should return result object' do
      expect(result).to be_a(SingleActionService::Result)
    end

    it 'should return result with error' do
      expect(result.error?).to eq(true)
    end

    it 'should return result with error code' do
      expect(result.error_code).to eq(error_code)
    end

    it 'should return result with data' do
      expect(result.data).to eq(data)
    end
  end

  errors_data.each do |error_data|
    error_name = error_data[:name]
    error_code = error_data[:code]
    error_method_name = "#{error_name}_error"

    describe "##{error_method_name}" do
      let(:data) { 'Error Data' }
      let(:result) { service.send(error_method_name, data) }

      it 'should return result object' do
        expect(result).to be_a(SingleActionService::Result)
      end

      it 'should return result with error' do
        expect(result.error?).to eq(true)
      end

      it 'should return result with error code' do
        expect(result.error_code).to eq(error_code)
      end

      it 'should return result with data' do
        expect(result.data).to eq(data)
      end

      it 'should return result with correct checking methods' do
        errors_data.each do |checking_error_data|
          checking_method_name = "#{checking_error_data[:name]}_error?"
          is_current_error = checking_error_data[:name] == error_name
          expect(result.send(checking_method_name)).to eq(is_current_error)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
