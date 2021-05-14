class CreateShowCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :show_categories do |t|
      t.references :show, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end

    add_index :show_categories, [:show_id, :category_id], unique: true
  end
end
