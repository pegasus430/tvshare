class AddWonToAwards < ActiveRecord::Migration[6.0]
  def change
    add_column :awards, :won, :boolean
  end
end
