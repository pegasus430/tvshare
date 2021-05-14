class CreateShowSearches < ActiveRecord::Migration[6.0]
  def change
    create_view :show_searches, materialized: true
  end
end
