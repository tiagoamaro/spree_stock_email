module Spree
  module Admin
    class StockEmailsController < ResourceController
      before_filter :load_data

      def collection_url(options = {})
        admin_product_stock_emails_url
      end

      def load_data
        @product = Product.find_by_permalink(params[:product_id])
        @stock_emails = Spree::StockEmail.where(product_id: @product.id)
      end
    end
  end
end