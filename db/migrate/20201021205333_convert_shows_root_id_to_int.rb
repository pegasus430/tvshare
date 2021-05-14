class ConvertShowsRootIdToInt < ActiveRecord::Migration[6.0]
  def up
    # changing a column from string to integer for numerical ordering
    # temporarily renaming the camelcase columnName to snake_case.
    rename_column :shows, :rootId, :root_id
    change_column :shows, :root_id, :integer, using: 'root_id::integer'
    rename_column :shows, :root_id, :rootId

    # adding an index for quicker lookups
    add_index :shows, :rootId
  end
end
