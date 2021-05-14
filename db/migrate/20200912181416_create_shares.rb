class CreateShares < ActiveRecord::Migration[6.0]
  def change
    create_table :shares do |t|
      t.references :user
      t.integer :shareable_id, null: false
      t.string :shareable_type, null: false

      t.timestamps
    end

    add_index :shares, [:shareable_id, :shareable_type]

    add_column :shows, :shares_count, :bigint, default: 0
    add_column :stories, :shares_count, :bigint, default: 0
  end
end
