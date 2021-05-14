class QualityRatingsController < ApplicationController
  before_action :set_quality_rating, only: [:show, :update, :destroy]

  # GET /quality_ratings
  def index
    @quality_ratings = QualityRating.all

    render json: @quality_ratings
  end

  # GET /quality_ratings/1
  def show
    render json: @quality_rating
  end

  # POST /quality_ratings
  def create
    @quality_rating = QualityRating.new(quality_rating_params)

    if @quality_rating.save
      render json: @quality_rating, status: :created, location: @quality_rating
    else
      render json: @quality_rating.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /quality_ratings/1
  def update
    if @quality_rating.update(quality_rating_params)
      render json: @quality_rating
    else
      render json: @quality_rating.errors, status: :unprocessable_entity
    end
  end

  # DELETE /quality_ratings/1
  def destroy
    @quality_rating.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quality_rating
      @quality_rating = QualityRating.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def quality_rating_params
      params.require(:quality_rating).permit(:ratingsBody, :value, :show_id)
    end
end
