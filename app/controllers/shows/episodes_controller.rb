class Shows::EpisodesController < ActionController::Base
  
  def index
    @show = get_show
    @episodes_by_season = Show.where(seriesId: @show.seriesId).where.not(seasonNum: nil, episodeNum: nil).reduce({}) do |memo, show|
      memo[show.seasonNum] ||= []
      memo[show.seasonNum].push(show)
      memo[show.seasonNum].sort_by { |show| show.episodeNum }
      memo
    end
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
