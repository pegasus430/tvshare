# require_relative '../lib/networks'
# require_relative '../lib/url_api'

class ShowsController < ApplicationController
  # include UrlApi
  include Networks
  before_action :set_show, only: [:show, :update, :destroy]

  # GET /shows
  def index
    @shows = Show.with_tms_id.limit(100)

    render json: @shows
  end

  # GET /shows/1
  def show
    render json: @show.to_json(except:
      [
        :cached_votes_total, :cached_votes_score, :cached_votes_up, :cached_weighted_average,
        :cached_votes_down, :cached_weighted_score, :cached_weighted_total, :imdb_id
      ]
    )
  end

  # POST /shows
  def create
    #   @show = Show.new(show_params)
    # if @show.save
    #   render json: @show, status: :created, include: [:awards, :preferred_image, :keyword, :casts, :crews, :quality_rating, :ratings, :recommendations]
    # else
    #   render json: @show.errors, status: :unprocessable_entity
    # end
  end

  # PATCH/PUT /shows/1
  def update
    # if @show.update(show_params)
    #   render json: @show
    # else
    #   render json: @show.errors, status: :unprocessable_entity
    # end
  end

  # DELETE /shows/1
  def destroy
    # @show.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find_by(tmsId: params[:id])
    end

    def award_params

    end

    # Only allow a trusted parameter "white list" through.
    def show_params
      params.require(:show).permit(
        :descriptionLang,
        :entityType,
        :longDescription,
        :officialUrl,
        :origAirDate,
        :releaseDate,
        :releaseYear,
        :rootId,
        :runTime,
        :seriesId,
        :shortDescription,
        :subType,
        :title,
        :titleLang,
        :tmsId,
        :totalEpisodes,
        :totalSeasons,
        :quality_rating_attributes => {},
        :preferred_image_attributes => {},
        :keyword_attributes => {:Character => [], :Mood => [], :Setting => [], :Subject => [], :Theme => [], :Time_Period => []},
        :awards_attributes => [:awardCatId, :awardId, :awardName, :category, :name, :year],
        :casts_attributes => [:billingOrder, :characterName, :name, :nameId, :personId, :role],
        :crews_attributes => [:billingOrder, :name, :nameId, :personId, :role],
        :ratings_attributes => [:body, :code],
        :recommendations_attributes => [:rootId, :title, :tmsId],
        :advisories => [],
        :directors => [],
        :genres => [])
    end
end
