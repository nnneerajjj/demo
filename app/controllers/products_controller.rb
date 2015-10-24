class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @discount_percent = 0
    offer_valid = false
    now = Time.now
    @product.offers.each do |o|
      if((now > o.start_time) and (now < o.end_time))
        if o.repeat == 'daily'
          if ((now > o.start_time.to_s(:time).to_time) and (now < o.start_time.to_s(:time).to_time + o.duration.send(o.duration_type) ))
            offer_valid = true
          end
        elsif o.repeat == 'weekly'
          if ((now.wday == o.start_time.wday) and (now > o.start_time.to_s(:time).to_time) and (now < o.start_time.to_s(:time).to_time + o.duration.send(o.duration_type) ))
            offer_valid = true
          end
        end
        @discount_percent = (o.discount_percent > @discount_percent) ? o.discount_percent : @discount_percent if offer_valid
      end
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:category_id, :user_id, :title, :description, :stock, :price, :status)
    end
end
