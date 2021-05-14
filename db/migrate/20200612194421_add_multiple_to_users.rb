class AddMultipleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :gender, :string
    add_column :users, :cable_provider, :string
    add_column :users, :birth_date, :string
    add_column :users, :image, :text
    add_column :users, :bio, :text
    add_column :users, :city, :string
    add_column :users, :phone_number, :string
  end
end
