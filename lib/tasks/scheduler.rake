desc "Refresh genre cache"
task refresh_genre_cache: :environment do
  puts "Refreshing genre cache..."
  GenreCache.cache_all(clear_cache: true)
  puts "Finished refreshing genre cache."
end

desc "Refresh guide cache"
task guide_cache: :environment do
  puts "Refreshing genre cache..."

  # Update the default guide
  LineupCache.new.cache(clear_cache: true)

  LineupCache::SUPPORTED_TIME_ZONES.each do |tz|
    # Update timezone-specific guides
    LineupCache.new(timezone: tz).cache(clear_cache: true)
  end
  puts "Finished refreshing guide cache."
end

desc "Import new shows via Gracenote live guide"
task import_shows_via_live_guide: :environment do
  puts "Importing shows via live guide..."
  ImportLiveGuideJob.perform_later if Time.now.hour.even?
  puts "Finished importing shows."
end

desc "Import original shows"
task import_original_shows: :environment do
  puts "Importing Netflix Originals..."
  ImportNetflixOriginalsJob.perform_later

  puts "Importing Hulu Originals..."
  ImportHuluOriginalsJob.perform_later

  puts "Finished importing originals."
end

desc "Update existing shows"
task update_shows: :environment do
  puts "Updating existing shows..."

  Show.with_tms_id.non_episode.order(updated_at: :asc).limit(2_500).each do |show|
    ImportShowJob.perform_later(tmsId: show.tmsId)
  end

  puts "Finished updating existing shows."
end


desc "Import news for recently aired shows"
task update_recent_show_news: :environment do
  puts "Importing news recently aired shows..."
  (
    Show.airing_soon.news_imported_older_than(2.days).with_episode_title |
    Show.recently_aired.news_imported_older_than(2.days).with_episode_title
  ).each do |show|
    ImportShowNewsViaGoogleJob.perform_later(show)
  end
  puts "Finished importing news recently aired shows."
end

desc "Import news"
task import_news: :environment do
  puts "Importing news..."
  ImportNewsJob.perform_later
  puts "Finished importing news."
end

desc "Update story source iframe permissions"
task update_story_sources: :environment do
  puts "Updating story sources..."
  StorySource.find_each(&:verify_iframe_permission)
  puts "Finished updating story sources."
end

desc "Import Network Shows"
task import_network_shows: :environment do
  puts "Importing network shows..."
  Network.active.find_each { |network| ImportNetworkShowsJob.perform_later(network) } if Time.now.day.even?
  puts "Finished importing network shows."
end

desc "Update Popularity Scores"
task update_popularity_scores: :environment do
  puts "Updating popularity scores..."
  Show.with_tms_id.find_in_batches do |group|
    BulkUpdateShowPopularityJob.perform_later(group.first.id, group.last.id) if Time.now.day.even?
  end
  puts "Finished updating popularity scores."
end
