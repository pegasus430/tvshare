class BulkUpdateShowPopularityJob < ApplicationJob
  queue_as :default

  def perform(start_id, end_id)
    Show.with_tms_id.includes(:awards).find_each(start: start_id, finish: end_id) do |show|
      show.set_popularity_score
    end
  end
end
