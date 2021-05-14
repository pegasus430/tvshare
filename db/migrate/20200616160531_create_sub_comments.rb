class CreateSubComments < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_comments do |t|
      t.string :text
      t.string :hashtag
      t.text :images, array: true, default: []
      t.references :comment, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
