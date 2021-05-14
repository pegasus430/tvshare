class CreateAwards < ActiveRecord::Migration[6.0]
  def change
    create_table :awards do |t|
      t.string :awardCatId
      t.string :awardId
      t.string :awardName
      t.string :category
      t.string :name
      t.string :year
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
