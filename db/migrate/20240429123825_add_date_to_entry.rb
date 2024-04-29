class AddDateToEntry < ActiveRecord::Migration[7.1]
  def change
    add_column :entries, :date, :string
  end
end
