class UsersController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    @users = User.all
    authorize User
  end

  def show
    @user = User.find(params[:id])
    authorize @user
    @added_products = @user.products
    
    @sold_products = Array.new
    if @user.products.count
      @user.products.each do |product|
        product_sales = product.purchases.collect{|purchase| purchase.product} if product.purchases.count
        product_sales.each{|product| @sold_products << product }
      end
    end
    @purchased_products = (@user.purchases.count) ? @user.purchases.collect{|purchase| purchase.product} : Array.new
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    authorize user
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end

end
