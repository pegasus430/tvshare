class CrewsController < ApplicationController
  before_action :set_crew, only: [:show, :update, :destroy]

  # GET /crews
  def index
    @crews = Crew.all

    render json: @crews
  end

  # GET /crews/1
  def show
    render json: @crew
  end

  # POST /crews
  def create
    @crew = Crew.new(crew_params)

    if @crew.save
      render json: @crew, status: :created, location: @crew
    else
      render json: @crew.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /crews/1
  def update
    if @crew.update(crew_params)
      render json: @crew
    else
      render json: @crew.errors, status: :unprocessable_entity
    end
  end

  # DELETE /crews/1
  def destroy
    @crew.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crew
      @crew = Crew.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def crew_params
      params.require(:crew).permit(:billingOrder, :name, :nameId, :personId, :role, :show_id)
    end
end
