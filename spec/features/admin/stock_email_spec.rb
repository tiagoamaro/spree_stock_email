require 'spec_helper'

describe 'Stock Email' do
  stub_authorization!

  let!(:product) { create(:product) }

  describe 'stock emails list' do
    it 'list registered emails for product variants' do
      not_product_email_list = create_list(:stock_email, 3)
      stock_email_list = create_list(:stock_email, 5, product: product)

      visit spree.admin_product_path(product)
      click_link 'Stock Mailer'

      stock_email_list.each do |se|
        within "#stock_email_#{se.id}" do
          page.should have_content se.email
          page.should have_content I18n.l(se.sent_at, format: '%a, %d %b %Y %H:%M:%S')
        end
      end

      not_product_email_list.each do |se|
        page.should_not have_content se.email
      end
    end

    it 'shows not sent registered emails' do
      not_sent_stock_email = create(:stock_email, product: product, sent_at: nil)

      visit spree.admin_product_path(product)
      click_link 'Stock Mailer'

      within "#stock_email_#{not_sent_stock_email.id}" do
        page.should have_content "Not Sent"
      end
    end
  end

  it 'edits registered emails' do
    stock_email = create(:stock_email, product: product)

    visit spree.admin_product_path(product)
    click_link 'Stock Mailer'

    page.should have_content stock_email.email
    page.should have_content I18n.l stock_email.sent_at, format: '%a, %d %b %Y %H:%M:%S'

    click_icon :edit

    fill_in 'stock_email_email', with: 'othermail@mail.com'
    fill_in 'stock_email_sent_at', with: '2013-11-11'

    click_button 'Update'

    page.should have_content 'othermail@mail.com'
    page.should have_content I18n.l Time.new(2013, 11, 11), format: '%a, %d %b %Y %H:%M:%S'
  end

  it 'deletes email from registered list', js: true do
    stock_email = create(:stock_email, product: product)

    visit spree.admin_product_path(product)
    click_link 'Stock Mailer'

    page.should have_content stock_email.email
    page.evaluate_script('window.confirm = function() { return true; }')
    click_icon :trash
    page.should_not have_content stock_email.email
  end
end