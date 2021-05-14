class GuidesController < ActionController::Base
  # before_action :get_current_user
  before_action :get_lineup
  caches_action :live, expires_in: 1.minutes, cache_path: -> do
    { station_id: request.params[:network_id], timezone: request.params[:timezone] }
  end, if: -> { Rails.env.production? }

  caches_action :upcoming, expires_in: 1.minutes, cache_path: -> do
    { station_id: request.params[:network_id], timezone: request.params[:timezone] }
  end, if: -> { Rails.env.production? }

  def live
    render json: @lineup.live_now(station_id: normalized_station_id), as: :text
  end

  def upcoming
    render json: @lineup.upcoming(station_id: normalized_station_id), as: :text
  end

  # Allows for dynamic caching
  def cache_keys
    { station_id: normalized_station_id, genre: request.params[:genre], page: request.params[:page] }
  end

  private

  def get_lineup
    if @current_user && @current_user.cable_provider.present?
      @lineup = LineupCache.new(lineup: @current_user.cable_provider)
    else
      @lineup = LineupCache.new(timezone: request.params[:timezone])
    end
  end

  def normalized_station_id
    params[:station_id] || params[:network_id]
  end
end
