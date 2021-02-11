# rubocop:disable Metrics/BlockLength
RSpec.describe SingleActionService::Result do
  let(:result) { described_class.new(nil) }

  let(:success_data) { 'Success Data' }
  let(:error_data) { 'Erro Data' }

  let(:success_result) { described_class.new(true, data: success_data) }
  let(:error_result) { described_class.new(false, data: error_data) }

  describe '#status' do
    it 'attr accessor defined' do
      expect(result).to have_attr_accessor(:status)
    end
  end

  describe '#success?' do
    it 'method defined' do
      expect(result.respond_to?(:success?)).to eq(true)
    end

    context 'with positive status' do
      it 'should be true' do
        expect(success_result.success?).to eq(true)
      end
    end

    context 'with negative status' do
      it 'should be false' do
        expect(error_result.success?).to eq(false)
      end
    end
  end

  describe '#error?' do
    it 'method defined' do
      expect(result.respond_to?(:error?)).to eq(true)
    end
  end

  describe '#data' do
    it 'attr accessor defined' do
      expect(result).to have_attr_accessor(:data)
    end

    context 'with positive status' do
      it 'should be false' do
        expect(success_result.error?).to eq(false)
      end
    end

    context 'with negative status' do
      it 'should be true' do
        expect(error_result.error?).to eq(true)
      end
    end
  end

  describe '#error_code' do
    it 'attr accessor defined' do
      expect(result).to have_attr_accessor(:error_code)
    end
  end

  describe '#data!' do
    it 'method defined' do
      expect(result.respond_to?(:data)).to eq(true)
    end

    context 'with positive status' do
      it 'should return' do
        expect(success_result.data!).to eq(success_data)
      end
    end

    context 'with negative status' do
      it 'should raise exception' do
        expect { error_result.data! }.to raise_error do |error|
          expect(error).to be_a(SingleActionService::InvalidResult)
        end
      end

      it 'should store result in exception' do
        expect { error_result.data! }.to raise_error do |error|
          expect(error.result).to eq(error_result)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
