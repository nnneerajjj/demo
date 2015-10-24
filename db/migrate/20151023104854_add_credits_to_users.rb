class AddCreditsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credits, :float
  end
end
