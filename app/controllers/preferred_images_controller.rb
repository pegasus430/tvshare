class PreferredImagesController < ApplicationController
  before_action :set_preferred_image, only: [:show, :update, :destroy]

  # GET /preferred_images
  def index
    @preferred_images = PreferredImage.all

    render json: @preferred_images
  end

  # GET /preferred_images/1
  def show
    render json: @preferred_image
  end

  # POST /preferred_images
  def create
    @preferred_image = PreferredImage.new(preferred_image_params)

    if @preferred_image.save
      render json: @preferred_image, status: :created, location: @preferred_image
    else
      render json: @preferred_image.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /preferred_images/1
  def update
    if @preferred_image.update(preferred_image_params)
      render json: @preferred_image
    else
      render json: @preferred_image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /preferred_images/1
  def destroy
    @preferred_image.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preferred_image
      @preferred_image = PreferredImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def preferred_image_params
      params.require(:preferred_image).permit(:category, :height, :primary, :uri, :width, :show_id)
    end
end
