class AddUniqueConstraintToShowsTmsId < ActiveRecord::Migration[6.0]
  def change
    add_index :shows, :tmsId, unique: true
  end
end
