class ConvertShowsOrigAirDateToDate < ActiveRecord::Migration[6.0]
  def up
    change_column :shows, :origAirDate, 'date USING CAST("origAirDate" AS date)'
    add_index :shows, :origAirDate
  end

  def down
    change_column :shows, :origAirDate, :string
    remove_index :shows, :origAirDate
  end
end
