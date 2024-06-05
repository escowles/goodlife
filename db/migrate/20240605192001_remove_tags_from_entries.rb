class RemoveTagsFromEntries < ActiveRecord::Migration[7.1]
  def change
    drop_table :entry_tags
    drop_table :tags
  end
end
