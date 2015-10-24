class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      
      @error_msg = false
      if @purchase.product.stock <= 0
        @error_msg = "Product out of stock."
      elsif @purchase.user.credits < @purchase.price
        @error_msg = "Insufficient balance in your account."
      else
        if @purchase.save
          @purchase.product.stock -= 1
          @purchase.product.save
          @purchase.user.credits -= @purchase.price
          @purchase.user.save
          format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
          format.json { render :show, status: :created, location: @purchase }
          format.js
        else
          format.html { render :new }
          format.json { render json: @purchase.errors, status: :unprocessable_entity }
          format.js
        end
      end
    
      format.js
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:user_id, :product_id, :price)
    end
end
