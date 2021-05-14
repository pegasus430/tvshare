class CreateShowsNetworks < ActiveRecord::Migration[6.0]
  def change
    create_table :networks_shows, id: false do |t|
      t.belongs_to :show
      t.belongs_to :network
    end

    add_index :networks_shows, [:show_id, :network_id], unique: true
  end
end
