class CreateStories < ActiveRecord::Migration[6.0]
  def change
    create_table :stories do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.text :source
      t.string :image_url
      t.string :url, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :stories, :url, unique: true
  end
end
