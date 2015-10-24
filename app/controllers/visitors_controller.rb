class VisitorsController < ApplicationController
  def index
    @users = User.all
    @current_offers = Offer.current_offers
    @latest_products = Product.last 5
  end
end
