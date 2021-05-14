episode_data = []
@episodes_by_season.each do |season, episodes|
  episodes.each do |episode|
    episode_data.push({
      season_number: episode.seasonNum,
      episode_number: episode.episodeNum,
      tmsId: episode.tmsId,
      formatted_episode_number: episode.season_and_episode_number,
      shares_count: episode.shares_count,
      likes_count: episode.likes_count,
      comments_count: episode.comments_count,
      stories_count: episode.stories_count,
      activity_count: episode.activity_count
      })
  end
end

json.episodes episode_data.sort_by { |e| [e[:season_number], e[:episode_number]] }
