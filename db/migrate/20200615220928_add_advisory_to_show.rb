class AddAdvisoryToShow < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :advisories, :string, array: true, default: []
  end
end
