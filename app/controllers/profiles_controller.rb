class ProfilesController < ApplicationController
  before_action :authorize_request

  def show
    @user = @current_user
    render "users/show"
  end

  def reactions
    @comments = @current_user.comments.includes(:show).order(id: :desc).page(params[:page])
  end

  def favorites
    @likes = @current_user.likes.includes(:show).for_shows.order(id: :desc).page(params[:page])
  end

  def followers
    @users = @current_user.followers.order(id: :desc).page(params[:page])
  end

  def following
    @users = @current_user.followed_users.order(id: :desc).page(params[:page])
  end
end
