class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.integer :stock
      t.float :price
      t.string :status

      t.timestamps null: false
    end
  end
end
