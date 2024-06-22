class GoogleAnalyticsService
  attr_reader :client

  DIMENSION_MAP = {
    campaign: 'sessionCampaignName',
    source: 'sessionSource',
    medium: 'sessionMedium'
  }.freeze

  def initialize(property_id: nil)
    @client = Google::Analytics::Data.analytics_data do |config|
      config.credentials = ENV['GOOGLE_APPLICATION_CREDENTIALS']
    end

    @property_id = property_id
  end

  def data_by_utms(start_date, end_date, utms = {})
    dimensions = []
    filters = []
    utms.each do |utm, value|
      next if value.blank?

      dimensions << { name: dimension_name_for_google(utm) }
      filters << { filter: { field_name: dimension_name_for_google(utm), string_filter: { match_type: Google::Analytics::Data::V1beta::Filter::StringFilter::MatchType::EXACT, value: value } } }
    end

    response = client.run_report(
      property: "properties/#{@property_id}",
      date_ranges: [{ start_date: start_date, end_date: end_date }],
      dimensions: dimensions.uniq,
      metrics: [{ name: 'screenPageViews' }, { name: 'activeUsers' }, { name: 'addToCarts' },
                { name: 'transactions' }, { name: 'totalRevenue' }],
      dimension_filter: { and_group: { expressions: filters } }
    )

    data = response.rows.map do |row|
      metric_names = response.metric_headers.map(&:name)
      metric_values = row.metric_values.map { |m| m.value.to_f }

      dimension_names = response.dimension_headers.map(&:name)
      dimension_values = row.dimension_values.map(&:value)

      dimension_names.zip(dimension_values).to_h.merge(metric_names.zip(metric_values).to_h)
    end

    currency = response.metadata.currency_code
    [data, currency]
  end

  private

  def dimension_name_for_google(dimension)
    DIMENSION_MAP[dimension.to_sym] || dimension
  end
end
