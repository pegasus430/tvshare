class AddUrlToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :url, :string
  end
end
