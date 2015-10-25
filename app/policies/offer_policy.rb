class OfferPolicy < ApplicationPolicy
  def is_owner?
    user == record.product.user
  end
end
