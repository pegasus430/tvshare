class CategoriesController < ActionController::Base
  before_action :set_category, only: [:show]
  caches_action :index, expires_in: 5.minutes, if: -> { Rails.env.production? }
  caches_action :show, expires_in: 5.minutes, if: -> { Rails.env.production? }

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    render formats: :json
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.includes(shows: :networks).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:title, :active, :position)
    end
end
