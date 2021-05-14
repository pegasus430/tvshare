class CreateStorySources < ActiveRecord::Migration[6.0]
  def change
    create_table :story_sources do |t|
      t.string :domain, null: false
      t.string :image_url
      t.boolean :iframe_enabled, default: false

      t.timestamps
    end

    add_reference :stories, :story_source, index: true
    add_index :story_sources, :domain, unique: true
    # Saving a source will automatically link it to the story_source (due to a custom before_validation method)
    Story.find_each { |source| source.save }
  end
end
