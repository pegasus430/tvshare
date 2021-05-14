class CreateNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :networks do |t|
      t.string :name
      t.string :display_name
      t.boolean :streaming

      t.timestamps
    end

    add_index :networks, :name, unique: true
    change_column_default :networks, :streaming, false
  end
end
