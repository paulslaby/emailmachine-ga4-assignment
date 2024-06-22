require 'rails_helper'

RSpec.describe GoogleAnalyticsOperationsHelper, type: :helper do
  describe '#average_transaction_value' do
    it 'returns zero for zero transactions' do
      expect(helper.average_transaction_value(0, 0)).to eq(0)
    end

    it 'returns average transaction value' do
      expect(helper.average_transaction_value(100, 10)).to eq(10)
    end

    it 'works with integers' do
      expect(helper.average_transaction_value(100, 55)).to be_within(0.01).of(1.82)
    end
  end

  describe '#conversion_rate' do
    it 'returns zero for zero total' do
      expect(helper.conversion_rate(0, 0)).to eq(0)
    end

    it 'returns conversion rate' do
      expect(helper.conversion_rate(55, 101)).to be_within(0.01).of(54.46)
    end
  end

  describe '#roi' do
    it 'returns zero for zero costs' do
      expect(helper.roi(0, 100)).to eq(0)
    end

    it 'returns break even as zero' do
      expect(helper.roi(100, 100)).to eq(0)
    end

    it 'returns positive roi' do
      expect(helper.roi(100, 200)).to eq(100)
    end

    it 'returns negative roi' do
      expect(helper.roi(200, 100)).to eq(-50)
    end
  end
end
