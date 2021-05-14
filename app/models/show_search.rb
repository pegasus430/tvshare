class ShowSearch < ApplicationRecord
  scope :by_title, -> (query) { where('lower_title LIKE ?', "%#{query.downcase}%") }
  scope :ordered_by_match_and_popularity, -> (query) do
    order("
      case
      when lower_title LIKE '#{query.downcase}' then 10 + popularity_score
      when lower_title LIKE '#{query.downcase}%' then 6 + popularity_score
      when lower_title LIKE '%#{query.downcase}%' then 3 + popularity_score
        else 1 + popularity_score
      end DESC")
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false, cascade: false)
  end
end
