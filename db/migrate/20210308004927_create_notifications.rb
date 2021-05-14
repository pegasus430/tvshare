class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.references :actor, user: true, null: false
      t.references :owner, user: true, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.timestamp :read_at

      t.timestamps
    end

    add_index :notifications, :read_at
  end
end
