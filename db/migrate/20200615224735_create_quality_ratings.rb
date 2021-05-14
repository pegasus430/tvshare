class CreateQualityRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :quality_ratings do |t|
      t.string :ratingsBody
      t.string :value
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
