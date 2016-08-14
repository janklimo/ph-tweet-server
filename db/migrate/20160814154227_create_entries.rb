class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.date :date

      t.timestamps null: false
    end
  end
end
