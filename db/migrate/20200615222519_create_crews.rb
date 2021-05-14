class CreateCrews < ActiveRecord::Migration[6.0]
  def change
    create_table :crews do |t|
      t.string :billingOrder
      t.string :name
      t.string :nameId
      t.string :personId
      t.string :role
      t.references :show, foreign_key: true

      t.timestamps
    end
  end
end
