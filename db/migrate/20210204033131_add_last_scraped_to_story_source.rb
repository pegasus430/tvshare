class AddLastScrapedToStorySource < ActiveRecord::Migration[6.0]
  def change
    add_column :story_sources, :last_scraped_at, :time
    add_column :story_sources, :enabled, :boolean, default: true
    add_index :story_sources, :enabled
  end
end
