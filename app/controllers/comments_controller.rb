class CommentsController < ApplicationController
  before_action :get_current_user, only: [:index]
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy]

  # GET /comments
  def index
    if normalized_tms_id_param&.include?('SH')
      # return comments for every episode for this show
      show = get_show
      @comments = Comment.includes(:show, :user).where(shows: { seriesId: show.seriesId }).page(params[:page])
    elsif normalized_tms_id_param
      @comments = Comment.includes(:show, :user).where(shows: { tmsId: normalized_tms_id_param }).page(params[:page])
    elsif params[:show_id]
      @comments = Comment.includes(:show, :user).where(shows: { id: params[:show_id] }).page(params[:page])
    elsif params[:story_id]
      @comments = Comment.includes(:story, :user).where(stories: { id: params[:story_id] }).page(params[:page])
    end

    if @comments
      @comment_likes_from_followed_users = @comments.joins(:likes).where(likes: { user: @current_user&.followed_users }).group(:id).count
      @current_user_liked_ids = get_current_user_liked_comments(@comments)
      @current_user_reply_comment_ids = get_current_user_reply_comments(@comments)
    end
  end

  # GET /comments/1
  def show
    @comment = Comment.includes(:show, :user, :sub_comments, { likes: :user}).order('sub_comments.id DESC').find(params[:id])

    @comment_likes_from_followed_users = Comment.joins(:likes).where(likes: { user: @current_user&.followed_users, id: @comment.id }).group(:id).count
    @current_user_liked_ids = get_current_user_liked_comments([@comment])
    @current_user_reply_comment_ids = get_current_user_reply_comments([@comment])
  end

  # POST /comments
  def create
    @show = get_show
    show_id = @show&.id || comment_params[:show_id]
    @comment = @current_user.comments.new(text: comment_params[:text], show_id: show_id, images: comment_params[:images], videos: comment_params[:videos], story_id: comment_params[:story_id])

    @comment_likes_from_followed_users = Comment.joins(:likes).where(likes: { user: @current_user&.followed_users, id: @comment.id }).group(:id).count
    @current_user_liked_ids = get_current_user_liked_comments([@comment])
    @current_user_reply_comment_ids = get_current_user_reply_comments([@comment])


    if @comment.save
      render :show, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private

    def normalized_tms_id_param
      params[:tms_id] || params[:tmsId]
    end

    # Use callbacks to share common setup or constraints between actions.
    def get_show
      return nil if normalized_tms_id_param.blank?

      show = Show.find_by(tmsId: normalized_tms_id_param)
      if show.blank?
        ImportShowJob.perform_now(tmsId: normalized_tms_id_param)
        show = Show.find_by(tmsId: normalized_tms_id_param)
      end
      show
    end

    def get_current_user_liked_comments(comments)
      if @current_user
        @current_user.likes.where(comment_id: comments).order(id: :desc).pluck(:comment_id)
      else
        []
      end
    end

    def get_current_user_reply_comments(comments)
      if @current_user
        @current_user.sub_comments.where(comment_id: comments).order(id: :desc).pluck(:comment_id)
      else
        []
      end
    end

    def set_comment
      @comment = @current_user.comments.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def comment_params
      params.require(:comment).permit(:text, :hashtag, :show_id, :story_id, images: [], videos: [])
    end
end
