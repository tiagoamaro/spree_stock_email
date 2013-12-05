class Spree::StockEmailsController < ApplicationController

  def create
    variant = Spree::Variant.find_by(id: stock_email_params[:variant])
    redirect_to :back and return unless variant

    current_email = spree_current_user ? spree_current_user.email : stock_email_params[:email]
    stock_email = Spree::StockEmail.new(variant: variant, email: current_email)
    if stock_email.save
      flash[:success] = Spree.t('stock_email.messages.back_in_stock_email_message', product: variant.product.name)
    else
      flash[:notice] = stock_email.errors.full_messages.join(', ')
    end

    redirect_to :back
  end

  private

    def stock_email_params
      params.require(:stock_email).permit([:variant, :email])
    end
end
