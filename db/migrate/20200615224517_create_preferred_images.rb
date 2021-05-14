class CreatePreferredImages < ActiveRecord::Migration[6.0]
  def change
    create_table :preferred_images do |t|
      t.string :category
      t.string :height
      t.string :primary
      t.text :uri
      t.string :width
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
