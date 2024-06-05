class AddKeywordsToEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :entries, :keywords, :string
  end
end
