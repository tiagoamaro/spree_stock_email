#SpreeStockEmail

[![Build Status](https://travis-ci.org/tiagoamaro/spree_stock_email.png?branch=2-2-stable)](https://travis-ci.org/tiagoamaro/spree_stock_email)
[![Coverage Status](https://coveralls.io/repos/tiagoamaro/spree_stock_email/badge.png?branch=2-2-stable)](https://coveralls.io/r/tiagoamaro/spree_stock_email?branch=2-1-stable)

> Note:
> This fork uses products' variants to notify users

Allow users to create notifications of when products are back in stock.

This extension has no views, you will have to add those yourself sadly. If the current user is logged in then emails will be created based on their current email address, otherwise they are prompted to enter one.

Here is a basic partial:

```erb
<% if spree_current_user %>
  <%= link_to stock_emails_path(stock_email: {product: @variant.id}), method: :post do %>
      Notify me
  <% end %>
<% else %>
  <%= form_for :stock_email, url: stock_emails_path do |form| %>
    <%= form.hidden_field :product, value: @variant.id %>
    <%= form.label :email, "Your email address" %>
    <%= form.text_field :email %>
    <%= button_tag class: 'button', type: :submit do %>
      Notify me
    <% end %>
  <% end %>
<% end %>
```

##Installation

Add spree_stock_email to your Gemfile:

```ruby
gem 'spree_stock_email'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_stock_email:install
```
