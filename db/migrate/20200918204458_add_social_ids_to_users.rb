class AddSocialIdsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :google_id, :string
    add_column :users, :facebook_id, :string

    add_index :users, :google_id, unique: true
    add_index :users, :facebook_id, unique: true
  end
end
