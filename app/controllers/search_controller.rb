class SearchController < ApplicationController
  def index
    return render_empty if params[:query].blank?

    render json: [
      { label: 'Programs', options: program_options },
      { label: 'News', options: news_options },
      { label: 'Comments', options: comment_options },
    ]
  end

  private

  def render_empty
    render json: [
      { label: 'Programs', options: [] },
      { label: 'News', options: [] },
      { label: 'Comments', options: [] },
    ]
  end

  def program_options
    ShowSearch
      .by_title(params[:query])
      .ordered_by_match_and_popularity(params[:query])
      .limit(10)
      .map do |show|
        {
          type: 'show',
          value: show.tmsId,
          label: show.title,
          year: show.releaseYear,
          image: show.preferred_image_uri,
          genre: show.genres&.first,
          sub_type: show.subType,
          cast: show.cast&.first(2)&.map { |cast| cast['name'] }&.join(', ')
        }
      end
  end

  def news_options
    Story
    .joins(:show)
    .where.not(image_url: nil)
    .where("LOWER(stories.title) LIKE ?", "%#{params[:query].downcase}%")
    .limit(5).each.map do |story|
      {
        type: 'story',
        value: story.id,
        show_tms_id: story.show.tmsId,
        label: story.title,
        image: story.image_url,
        source: story.get_source_domain
      }
    end
  end

  def comment_options
    Comment
    .includes(:show, :user)
    .where("LOWER(text) LIKE ?", "%#{params[:query].downcase}%")
    .limit(5).each.map do |comment|
      {
        type: 'comment',
        value: comment.id,
        show_tms_id: comment.show.tmsId,
        label: comment.text,
        image: comment.images&.first,
        username: comment.user.username
      }
    end
  end
end
