class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :rank
      t.integer :external_id
      t.string :name
      t.text :url
      t.integer :votes
      t.text :series, array: true, default: []
      t.references :entry, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
