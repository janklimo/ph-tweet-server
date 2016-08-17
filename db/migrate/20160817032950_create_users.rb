class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :role
      t.string :twitter
      t.string :image_url
      t.references :post, index: true, foreign_key: true
      t.string :name

      t.timestamps null: false
    end
  end
end
