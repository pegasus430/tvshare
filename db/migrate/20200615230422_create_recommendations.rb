class CreateRecommendations < ActiveRecord::Migration[6.0]
  def change
    create_table :recommendations do |t|
      t.string :rootId
      t.string :title
      t.string :tmsId
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
