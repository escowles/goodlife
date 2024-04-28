class CreateEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :entries do |t|
      t.references :type, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :location

      t.timestamps
    end
  end
end
