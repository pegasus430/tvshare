class AddPersonIdToAwards < ActiveRecord::Migration[6.0]
  def change
    add_column :awards, :personId, :string
  end
end
