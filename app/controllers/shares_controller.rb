class SharesController < ApplicationController
  before_action :get_current_user

  def create
    if params[:comment_id]
      shareable = Comment.find(params[:comment_id])
    elsif params[:show_id]
      shareable = Show.find(params[:show_id])
    elsif params[:story_id]
      shareable = Story.find(params[:story_id])
    end

    # Can be saved with or without a user
    shareable.shares.create(user_id: @current_user&.id)
    render json: { shares_count: shareable.shares_count }
  end
end
