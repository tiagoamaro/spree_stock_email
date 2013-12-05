require 'spec_helper'

describe Spree::StockEmailsMailer do
  let(:stock_email) { build(:stock_email) }

  it 'notifies user about in stock product' do
    mail = Spree::StockEmailsMailer.stock_email stock_email
    mail.subject.should eq Spree.t("stock_email.email.subject")
    mail.body.should have_content stock_email.product.name
    mail.body.should have_content "is back in stock"
  end
end