class AddPreferredImageUriToShows < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :preferred_image_uri, :string
  end
end
