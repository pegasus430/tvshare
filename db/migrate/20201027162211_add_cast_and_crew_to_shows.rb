class AddCastAndCrewToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :cast, :json, array: true, default: []
    add_column :shows, :crew, :json, array: true, default: []
  end
end
