class Purchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :user, :presence => true
  validates :product, :presence => true
  validates :price, :presence => true, numericality: { greater_than: 0 }
end
