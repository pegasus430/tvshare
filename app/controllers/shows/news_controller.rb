class Shows::NewsController < ActionController::Base
  #caches_action :index, expires_in: 10.minutes, cache_path: -> { request.params[:id] }

  def index
    @show = get_show
    if @show.tmsId.starts_with?('SH')
      @stories = Story.joins(:show).where(shows: { seriesId: @show.seriesId }).limit(25)
    else
      @stories = @show.stories.includes(:story_source).order(published_at: :desc).limit(25)
    end

    @stories_likes_from_followed_users = @stories.joins(:likes).where(likes: { user: @current_user&.followed_users }).group(:id).count

    render template: 'news/index'
  end

  private

  def get_show
    show = Show.find_by(tmsId: params[:id])
    if show.blank?
      ImportShowJob.perform_now(tmsId: params[:id])
      show = Show.find_by(tmsId: params[:id])
    end
    show
  end

end
