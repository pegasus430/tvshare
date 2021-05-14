class Shows::OriginalsController < ApplicationController
  # all original shows
  def index
    shows = Show.originals
    render json: shows
  end

  # all original shows for a given network (netflix, hulu, etc)
  def show
    shows = Show.originals.with_tms_id.where(original_streaming_network: params[:network]&.downcase).map do |show|
      show = show.attributes
      show[:callSign] = params[:network].titlecase
      show
    end
    render json: shows
  end
end
