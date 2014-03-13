require 'spec_helper'

describe 'Products Stock' do
  stub_authorization!

  let!(:product) { create(:product) }

  let!(:variant1) { create(:variant, product: product) }
  let!(:variant2) { create(:variant, product: product) }

  before(:each) do
    variant1.stock_items.first.update_attribute(:backorderable, false)
    variant2.stock_items.first.update_attribute(:backorderable, false)
  end

  it 'does not send email if product is already in stock', js: true do
    Spree::StockEmail.should_receive(:notify).once.with(product)

    # Should send an email warning the user that the product is back in stock
    visit spree.stock_admin_product_path(product)
    select2 variant2.sku, from: "Variant"
    click_button "Add Stock"

    # Should not send an email
    select2 variant2.sku, from: "Variant"
    click_button "Add Stock"

    # Email is not triggered when product already has a variant in stock
    fill_in 'stock_movement_quantity', with: '10'
    select2 variant1.sku, from: "Variant"
    click_button "Add Stock"
  end
end