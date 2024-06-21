class GoogleAnalyticsService
  attr_reader :client

  DIMENSION_MAP = {
    campaign: 'sessionCampaignName',
    source: 'sessionSource',
    medium: 'sessionMedium'
  }.freeze

  def initialize
    @client = Google::Analytics::Data.analytics_data do |config|
      config.credentials = ENV['GOOGLE_APPLICATION_CREDENTIALS']
    end

    @property_id = '279977912'.freeze # TODO: env
  end

  def data_by_utms(start_date, end_date, utms = {})
    dimensions = []
    filters = []
    utms.each do |utm, value|
      dimensions << { name: dimension_name_for_google(utm) }
      filters << { filter: { field_name: dimension_name_for_google(utm), string_filter: { match_type: Google::Analytics::Data::V1beta::Filter::StringFilter::MatchType::EXACT, value: value } } }
    end

    data = client.run_report(
      property: "properties/#{@property_id}",
      date_ranges: [{ start_date: start_date, end_date: end_date }],
      dimensions: dimensions.uniq,
      metrics: [{ name: 'screenPageViews' }, { name: 'activeUsers' }, { name: 'addToCarts' }, { name: 'transactions' }, { name: 'totalRevenue' }],
      dimension_filter: { and_group: { expressions: filters } }
    )
  end

  private

  def dimension_name_for_google(dimension)
    DIMENSION_MAP[dimension.to_sym] || dimension
  end
end
