class AddStationIdToNetworks < ActiveRecord::Migration[6.0]
  def change
    add_column :networks, :station_id, :string
  end
end
