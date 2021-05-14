class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :title
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end
end
