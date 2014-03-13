class Spree::StockEmailsController < ApplicationController

  def create
    product = Spree::Product.find_by(permalink: stock_email_params[:product])
    redirect_to :back and return unless product

    current_email = spree_current_user ? spree_current_user.email : stock_email_params[:email]
    stock_email = Spree::StockEmail.new(product: product, email: current_email)
    if stock_email.save
      flash[:success] = Spree.t('stock_email.messages.back_in_stock_email_message', product: product.name)
    else
      flash[:notice] = stock_email.errors.full_messages.join(', ')
    end

    redirect_to :back
  end

  private

    def stock_email_params
      params.require(:stock_email).permit([:product, :email])
    end
end
