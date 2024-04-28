class CreateEntryPeople < ActiveRecord::Migration[7.1]
  def change
    create_table :entry_people do |t|
      t.references :entry, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
