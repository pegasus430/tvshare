class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :message
      t.references :user, user: true, null: false, foreign_key: true
      t.references :reportable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
