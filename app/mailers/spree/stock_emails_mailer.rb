module Spree
  class StockEmailsMailer < BaseMailer
    def stock_email(stock_email)
      @stock_email = stock_email
      mail(to: @stock_email.email, from: from_address, subject: Spree.t("stock_email.email.subject", product: @stock_email.variant.product.name))
    end
  end
end
