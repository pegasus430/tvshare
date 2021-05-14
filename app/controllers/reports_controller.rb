class ReportsController < ApplicationController
  before_action :authorize_request

  def create
    Report.create(report_params.merge(user: @current_user))
    head :ok
  end

  private

  def report_params
    params.require(:report).permit(:reportable_type, :reportable_id, :message, :url)
  end
end
