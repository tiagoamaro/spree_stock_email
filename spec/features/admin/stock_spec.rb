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
    Spree::StockEmail.should_receive(:notify).once.with(variant2)

    visit spree.stock_admin_product_path(product)
    select2 variant2.sku, from: "Variant"
    click_button "Add Stock"

    select2 variant2.sku, from: "Variant"
    click_button "Add Stock"
  end
end