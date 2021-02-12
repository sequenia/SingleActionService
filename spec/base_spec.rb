# rubocop:disable Metrics/BlockLength
RSpec.describe SingleActionService::Base do
  let(:service) { described_class.new }

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
end
# rubocop:enable Metrics/BlockLength
