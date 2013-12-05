require 'spec_helper'

describe Spree::StockEmail do
  it { should belong_to(:variant) }

  describe 'validation' do
    let(:variant) { create(:variant) }

    context 'is valid' do
      it 'has variant and an unique email' do
        valid_stock_email = create(:stock_email, variant: variant, sent_at: nil)
        invalid_stock_email = build(:stock_email, variant: variant, email: valid_stock_email.email, sent_at: nil)

        valid_stock_email.should be_valid
        invalid_stock_email.should_not be_valid
      end
    end
  end

  describe 'self.not_sent' do
    it 'returns not sent stock emails' do
      variant = create(:variant)
      sent_stock_emails = create_list(:stock_email, 3, variant: variant, sent_at: Time.now)
      not_sent_stock_emails = create_list(:stock_email, 5, variant: variant, sent_at: nil)

      Spree::StockEmail.not_sent(variant).should =~ not_sent_stock_emails
    end
  end

  describe 'self.notify' do
    it 'triggers .notify for unsent stock emails registered to a variant' do
      variant = create(:variant)
      not_sent_stock_emails = create_list(:stock_email, 5, variant: variant, sent_at: nil)

      Spree::StockEmail.should_receive(:not_sent).with(variant).and_return(not_sent_stock_emails)
      not_sent_stock_emails.each { |e| e.should_receive(:notify) }
      Spree::StockEmail.notify(variant)
    end
  end

  describe '.notify' do
    it 'triggers email and mark stock email as sent' do
      stock_email = create(:stock_email, sent_at: nil)

      mailer_double = double('Stock Email Mailer Double')
      Spree::StockEmailsMailer.should_receive(:stock_email).with(stock_email).and_return(mailer_double)
      mailer_double.should_receive(:deliver)

      stock_email.sent_at.should be_nil
      stock_email.notify
      stock_email.sent_at.should_not be_nil
    end
  end
end