class AddSharesCountToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :shares_count, :bigint, default: 0
    add_column :sub_comments, :shares_count, :bigint, default: 0
  end
end
