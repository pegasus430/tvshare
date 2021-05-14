class Shows::GenresController < ActionController::Base
  PAGE_SIZE = 25
  caches_action :index, expires_in: 1.days, cache_path: -> { cache_keys }, if: -> { Rails.env.production? }
  caches_action :show, expires_in: 1.days, cache_path: -> { cache_keys }, if: -> { Rails.env.production? }

  # all genres each with the first PAGE_SIZE shows
  def index
    render json: GenreCache.fetch(page: params[:page] || 1, station_id: params[:station_id]), as: :text
  end

  def show
    render json: GenreCache.fetch_genre(page: params[:page] || 1, station_id: params[:station_id], genre: params[:genre]), as: :text
  end

  def cache_keys
    { station_id: request.params[:station_id], genre: request.params[:genre], page: request.params[:page] }
  end
end
