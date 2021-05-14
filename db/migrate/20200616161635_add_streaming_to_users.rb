class AddStreamingToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :streaming_service, :string
    add_column :comments, :images, :text, array: true, default: []
  end
end
