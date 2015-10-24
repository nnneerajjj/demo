class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :product, index: true, foreign_key: true
      t.float :discount_percent
      t.datetime :start_time
      t.integer :duration
      t.string :duration_type
      t.string :repeat
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
