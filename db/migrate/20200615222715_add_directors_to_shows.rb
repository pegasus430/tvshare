class AddDirectorsToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :directors, :string, array: true, default: []
    add_column :shows, :genres, :string, array: true, default: []
  end
end
