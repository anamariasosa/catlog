require 'twilio-ruby'

class OrdersController < ApplicationController
  include TwilioNotify

  before_action :set_product
  before_action :set_payment_methods, only: [:new]
  before_action :authenticate_user!
  before_action :only_customers, only: [:new]

  def new
    order = Order.new
    order.total = @product.price
    @order = order
  end

  def create
    @order = Order.new(params.require(:order).permit(:address, :payment_method, :details))
    customer = current_user

    respond_to do |format|
      @order.customer_id = current_user.id
      @order.store_id = @product.store.id
      @order.product_id = @product.id
      @order.total = @product.price
      @order.status = 'En Proceso'

      if @order.save
        # order needs to be trackable
        @order.create_activity :create, owner: @order.store
        @order.create_activity :create, owner: @order.customer

        format.html { redirect_to thnks_fr_th_mmrs_product_orders_path(order: @order), notice: "Tu orden ha sido creada" }
        format.json { render :index, status: :created, location: @product }
      else
        set_payment_methods
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def thnks_fr_th_mmrs
    @result = current_user.orders.last

    notify('customer', @result, true)
    notify('store', @result, true)
  end

  private

    def only_customers
      if current_user.type == "Store"
        flash[:error] = t('user.no_customer')
        redirect_to :back
      end
    end

    def set_product
      @product = Product.find params[:product_id]
    end

    def set_payment_methods
      @payment_methods = ['Contra Entrega']
      
      if Store.find(@product.store.id).bank_account?
        @payment_methods.push('Consignación')
      end
    end

end
