require 'rails_helper'

describe GoogleAnalyticsService, type: :model do
  describe '#initialize' do
    let(:ga_client) { instance_double(GoogleAnalyticsService) }
    before do
      expect(Google::Analytics::Data).to receive(:analytics_data).and_return(ga_client)
    end

    it 'initializes the client with the property_id' do
      described_class.new(property_id: '12345').tap do |service|
        expect(service.instance_variable_get(:@property_id)).to eq('12345')
      end
    end
  end

  describe '#data_by_utms' do
    it 'calls the client with the correct parameters' do
      Google::Analytics::Data.analytics_data # HACK: for loading the symbol we need one line after
      client_double = instance_double(Google::Analytics::Data::V1beta::AnalyticsData::Client)
      expect(Google::Analytics::Data).to receive(:analytics_data).and_return(client_double)

      property_id = '12345'
      start_date = '2021-01-01'
      end_date = '2023-01-31'
      utms = { campaign: 'campaign', source: 'source', medium: 'medium' }

      expect(client_double).to receive(:run_report).with(
        property: "properties/#{property_id}",
        date_ranges: [{ start_date: start_date, end_date: end_date }],
        dimensions: [{ name: 'sessionCampaignName' }, { name: 'sessionSource' }, { name: 'sessionMedium' }],
        metrics: [{ name: 'screenPageViews' }, { name: 'activeUsers' }, { name: 'addToCarts' }, { name: 'transactions' }, { name: 'totalRevenue' }],
        dimension_filter: {
          and_group: {
            expressions: [
              { filter: { field_name: 'sessionCampaignName', string_filter: { match_type: Google::Analytics::Data::V1beta::Filter::StringFilter::MatchType::EXACT, value: 'campaign' } } },
              { filter: { field_name: 'sessionSource', string_filter: { match_type: Google::Analytics::Data::V1beta::Filter::StringFilter::MatchType::EXACT, value: 'source' } } },
              { filter: { field_name: 'sessionMedium', string_filter: { match_type: Google::Analytics::Data::V1beta::Filter::StringFilter::MatchType::EXACT, value: 'medium' } } }
            ]
          }
        }
      ).and_return(double(rows: [], metric_headers: [], dimension_headers: [], metadata: double(currency_code: 'CZK')))

      described_class.new(property_id: property_id).data_by_utms(start_date, end_date, utms)
    end
  end
end
