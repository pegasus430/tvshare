class LikesController < ApplicationController
  before_action :authorize_request
  before_action :set_like, only: [:show, :update, :destroy]

  # GET /likes
  def index
    @likes = get_likes
    render json: @likes
  end

  # GET /likes/1
  def show
    render json: @like
  end

  # POST /likes
  def create
    @like = get_like

    if params[:liked]
      # create like, unless it exists
      @like.save
    else
      # delete like, if it exists
      @like.destroy if @like.persisted?
    end

    @likes = get_likes
    render json: @likes
  end

  # PATCH/PUT /likes/1
  def update
    if @like.update(like_params)
      render json: @like
    else
      render json: @like.errors, status: :unprocessable_entity
    end
  end

  # DELETE /likes/1
  def destroy
    @like.destroy
  end

  private
    def get_show_like
      # If the tmsId begins with SH or MV, we can use it directly
      # If the tmsId beings with EP, we need to find its root tmsId
      # The reason being users like shows, not episodes
      if params[:tmsId]&.match(/SH|MV|/)
        show = Show.find_by(tmsId: params[:tmsId])
      else
        show = Show.find_by(rootId: params[:seriesId])
      end

      @current_user.likes.find_or_initialize_by(show_id: show.id)
    end

    def get_sub_comment_like
      @current_user.likes.find_or_initialize_by(sub_comment_id: params[:subCommentId])
    end

    def get_comment_like
      @current_user.likes.find_or_initialize_by(comment_id: params[:commentId])
    end

    def get_story_like
      @current_user.likes.find_or_initialize_by(story_id: params[:storyId])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_like
      @like = Like.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def like_params
      params.require(:like).permit(:like, :user_id, :comment_id, :show_id, :sub_comment_id)
    end

    def get_like
      if params[:commentId].present?
        get_comment_like
      elsif params[:subCommentId].present?
        get_sub_comment_like
      elsif params[:storyId].present?
        get_story_like
      else
        get_show_like
      end
    end

    def get_likes
      @current_user.likes.includes(:show, :comment, :sub_comment, :story).flat_map.reduce({
          shows: [],
          comments: [],
          sub_comments: [],
          stories: []
      }) do |memo, like|
        if like.show_id.present?
          memo[:shows].push(like.show.tmsId) if like.show.tmsId.present?
          memo[:shows].push(like.show.seriesId) if like.show.seriesId.present?
        elsif like.comment_id.present?
          memo[:comments].push(like.comment_id)
        elsif like.sub_comment_id.present?
          memo[:sub_comments].push(like.sub_comment_id)
        elsif like.story.present?
          memo[:stories].push(like.story_id)
        end
        memo
      end
    end

end
