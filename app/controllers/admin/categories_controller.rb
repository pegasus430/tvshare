class Admin::CategoriesController < AdminController
  skip_before_action :verify_authenticity_token
  before_action :set_category, only: [:update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: Category.order(position: :asc).all }
    end
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    @category.assign_attributes(category_params)
    shows = Show.where(tmsId: params[:tmsIds])
    update_show_positions if params[:tmsIds].present?

    if @category.save
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    def update_show_positions
      shows = Show.where(tmsId: params[:tmsIds])

      params[:tmsIds].each do |tmsId|
        if shows.none? { |show| show.tmsId == tmsId }
          ImportShowJob.perform_now(tmsId: tmsId)
          shows = Show.where(tmsId: params[:tmsIds])
        end
      end

      shows = Show.where(tmsId: params[:tmsIds])
      position_map = params[:tmsIds].each_with_object({}).with_index do |(tmsId, memo), index|
        memo[tmsId] = index
      end

      @category.show_categories.destroy_all
      @category.show_categories = shows.map.with_index do |show, index|
        cs = ShowCategory.new(category_id: @category.id, show_id: show.id)
        cs.position = position_map[show.tmsId]
        cs
      end
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:title, :active, :position)
    end
end
