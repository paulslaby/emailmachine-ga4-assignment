class GoogleAnalyticsOperationsController < ApplicationController
  def show
  end

  def update
    @data, @currency = GoogleAnalyticsService.new.data_by_utms(params[:start_date], params[:end_date], campaign: params[:campaign], source: params[:source], medium: params[:medium])

    render :show
  end
end
