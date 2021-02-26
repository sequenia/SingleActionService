ERRORS_DATA = [
  { name: :one, code: :'namespace_one.one_error' },
  { name: :two, code: :'namespace_two.two_error' }
].freeze

class SingleActionService::TestService < SingleActionService::Base
  errors ERRORS_DATA
end

# rubocop:disable Metrics/BlockLength
RSpec.describe SingleActionService::TestService do
  let(:result_class_name) { "#{described_class.name}Result" }
  let(:result_class_name_without_module) { result_class_name.split('::').last }
  let(:service) { described_class.new }

  describe '.errors' do
    it 'should set right count of errors to class' do
      expect(described_class.errors.size).to eq(ERRORS_DATA.size)
    end

    it 'should convert errors data to error classes' do
      expect(described_class.errors).to all(
        be_a(SingleActionService::ServiceError)
      )
    end

    it 'should fill error names' do
      error_names = described_class.errors.map(&:name)
      errors_data_names = ERRORS_DATA.map { |error_data| error_data[:name] }
      expect(error_names).to eq(errors_data_names)
    end

    it 'should fill error codes' do
      error_codes = described_class.errors.map(&:code)
      errors_data_codes = ERRORS_DATA.map { |error_data| error_data[:code] }
      expect(error_codes).to eq(errors_data_codes)
    end

    it 'should define class for result based on service class name' do
      result_class_defined = described_class.module_parent.const_defined?(
        result_class_name_without_module
      )
      expect(result_class_defined).to be(true)
    end

    it 'should provide accessor for service result class' do
      result_class = described_class.result_class
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

    context 'returned result' do
      it 'should be object' do
        expect(result.class.name).to eq(result_class_name)
      end

      it 'should have error' do
        expect(result.error?).to eq(true)
      end

      it 'should have error code' do
        expect(result.error_code).to eq(error_code)
      end

      it 'should have data' do
        expect(result.data).to eq(data)
      end
    end
  end

  ERRORS_DATA.each do |error_data|
    error_name = error_data[:name]
    error_code = error_data[:code]
    error_method_name = "#{error_name}_error"

    describe "##{error_method_name}" do
      let(:data) { 'Error Data' }
      let(:result) { service.send(error_method_name, data) }

      context 'returned result' do
        it 'should be object' do
          expect(result.class.name).to eq(result_class_name)
        end

        it 'should have error' do
          expect(result.error?).to eq(true)
        end

        it 'should have error code' do
          expect(result.error_code).to eq(error_code)
        end

        it 'should have data' do
          expect(result.data).to eq(data)
        end

        it 'should respond to checking methods with correct values' do
          checkings = ERRORS_DATA.map do |checking_error_data|
            checking_method_name = "#{checking_error_data[:name]}_error?"
            result.send(checking_method_name)
          end

          expected_checkings = ERRORS_DATA.map do |checking_error_data|
            checking_error_data[:code] == error_code
          end

          expect(checkings).to eq(expected_checkings)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
