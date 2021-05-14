class Comments::SubCommentsController < ApplicationController

  # GET /comments
  def index
    @sub_comments = SubComment.includes(:user, :comment).where(comment_id: params[:id]).page(params[:page])
  end

end
