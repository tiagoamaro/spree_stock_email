require 'spec_helper'

describe Spree::StockEmailsMailer do
  let(:stock_email) { build(:stock_email) }

  it 'notifies user about in stock product' do
    mail = Spree::StockEmailsMailer.stock_email stock_email
    mail.subject.should eq "Product #{stock_email.variant.product.name} is back in stock!"
    mail.body.should have_content stock_email.variant.product.name
    mail.body.should have_content stock_email.variant.options_text
    mail.body.should have_content "is back in stock"
  end

  it 'sends email based on spree mailer configuration' do
    Spree::Config[:mails_from] = 'sent@email.com'
    mail = Spree::StockEmailsMailer.stock_email stock_email
    mail.from.should eq ['sent@email.com']
    mail.to.should eq [stock_email.email]
  end
end