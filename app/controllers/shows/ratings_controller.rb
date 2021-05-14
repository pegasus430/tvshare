class Shows::RatingsController < ApplicationController
  before_action :set_show
  before_action :authorize_request

  def create
    if params[:rating].present?
      @show.rate(@current_user, params[:rating])
    else
      head(:not_acceptable) and return
    end
  end

  private

  def set_show
    @show = Show.find_by!(normalized_lookup_param)
  end

  # Lookup via ID or TMS ID
  def normalized_lookup_param
    if params[:tmsId].present?
      { tmsId: params[:tmsId] }
    elsif params[:tms_id].present?
      { tmsId: params[:tms_id] }
    elsif params[:id].present?
      { id: params[:id] }
    end
  end
end
