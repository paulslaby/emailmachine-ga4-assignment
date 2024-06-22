require 'rails_helper'

require_relative '../../app/services/google_analytics_service'

RSpec.describe "Google Analytics Operation", type: :request do
  describe "GET /google_analytics_operation" do
    it "returns a successful response" do
      get google_analytics_operation_path
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do
      get google_analytics_operation_path
      expect(response).to render_template(:show)
    end
  end

  describe "PUT /google_analytics_operation" do

    let(:ga_service_double) { instance_double(GoogleAnalyticsService, data_by_utms: [[], 'CZK']) }
    before do
      expect(GoogleAnalyticsService).to receive(:new).and_return(ga_service_double)
    end

    it "returns a successful response" do
      put google_analytics_operation_path, params: { start_date: '2021-01-01', end_date: "2021-01-31", campaign: "campaign", source: "source", medium: "medium" }
      expect(ga_service_double).to have_received(:data_by_utms).with('2021-01-01', '2021-01-31', campaign: 'campaign', source: 'source', medium: 'medium')
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do
      put google_analytics_operation_path, params: { start_date: "2021-01-01", end_date: "2021-01-31", campaign: "campaign", source: "source", medium: "medium"}
      expect(ga_service_double).to have_received(:data_by_utms).with('2021-01-01', '2021-01-31', campaign: 'campaign', source: 'source', medium: 'medium')
      expect(response).to render_template(:show)
    end
  end
end
