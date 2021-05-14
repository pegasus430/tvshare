class CreateCasts < ActiveRecord::Migration[6.0]
  def change
    create_table :casts do |t|
      t.string :billingOrder
      t.string :characterName
      t.string :name
      t.string :nameId
      t.string :personId
      t.string :role
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
