class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.string :body
      t.string :code
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
