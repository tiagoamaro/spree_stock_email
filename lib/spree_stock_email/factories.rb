FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_stock_email/factories'

  factory :stock_email, class: Spree::StockEmail do
    product
    sequence(:email) { |n| "name#{n}@email.com" }
    sent_at Time.now
  end
end
