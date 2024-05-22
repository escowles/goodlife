class AddEndDateToEntries < ActiveRecord::Migration[7.1]
  def change
    add_column :entries, :end_date, :string
  end
end
