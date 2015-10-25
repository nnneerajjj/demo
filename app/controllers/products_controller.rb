class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    authorize Product
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @discount_percent = @product.discount_percent
    @effective_price = (@discount_percent > 0) ? (@product.price - ( ( @product.price / 100 ) * @discount_percent ) ).round(2) : @product.price
    @purchase = @product.purchases.build(user_id: current_user.id, price: @effective_price) if current_user
  end

  # GET /products/new
  def new
    @product = Product.new
    authorize @product
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    authorize @product
    respond_to do |format|
      @product.status = 'sale'
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      authorize @product
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:category_id, :user_id, :title, :description, :stock, :price, :status, :picture)
    end
end
