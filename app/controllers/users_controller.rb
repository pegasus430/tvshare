class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy, :reactions, :favorites, :following, :followers]
  before_action :authorize_request, only: [:update, :destroy]

  # GET /users/:username
  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      @token = encode({ user_id: @user.id, username: @user.username })
      render json: { user: @user, token: @token }, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @current_user.id == @user.id && @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def location
    render json: request.location.postal_code
  end

  def reactions
    @comments = @user.comments.order(id: :desc).page(params[:page])

    render "profiles/reactions"
  end

  def favorites
    @likes = @user.likes.includes(:show).for_shows.order(id: :desc).page(params[:page])

    render "profiles/favorites"
  end

  def followers
    @users = @user.followers.order(id: :desc).page(params[:page])

    render "profiles/followers"
  end

  def following
    @users = @user.followed_users.order(id: :desc).page(params[:page])

    render "profiles/following"
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(username: params[:user_username] || params[:username])
      head(:not_found) if @user.blank?
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:username, :bio, :password, :password_digest, :zipcode, :email, :gender, :cable_provider, :birth_date, :image, :bio, :city, :phone_number, :streaming_service, :name)
    end
end
