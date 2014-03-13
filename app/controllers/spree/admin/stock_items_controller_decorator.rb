Spree::Admin::StockItemsController.class_eval do

  before_filter :set_current_on_hand_value, only: :create
  after_filter :send_stock_emails, only: :create

  def set_current_on_hand_value
    @variant = Spree::Variant.find(params[:variant_id])
    @product_was_in_stock = product_in_stock?(@variant.product)
  end

  def send_stock_emails
    Spree::StockEmail.notify(@variant.product) if !@product_was_in_stock && @variant.in_stock?
  end

  private

  def product_in_stock?(product)
    product.total_on_hand > 0
  end
end
