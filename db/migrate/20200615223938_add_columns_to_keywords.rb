class AddColumnsToKeywords < ActiveRecord::Migration[6.0]
  def change
    add_column :keywords, :Character, :string, array: true, default: []
    add_column :keywords, :Mood, :string, array: true, default: []
    add_column :keywords, :Setting, :string, array: true, default: []
    add_column :keywords, :Subject, :string, array: true, default: []
    add_column :keywords, :Theme, :string, array: true, default: []
    add_column :keywords, :Time_Period, :string, array: true, default: []
    add_reference :keywords, :show, foreign_key: true
  end
end
