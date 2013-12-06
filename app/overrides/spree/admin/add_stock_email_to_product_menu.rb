Deface::Override.new(:virtual_path => 'spree/admin/shared/_product_tabs',
                     :name => 'add_stock_email_to_product_menu',
                     :insert_bottom => '[data-hook=admin_product_tabs]',
                     :partial => 'spree/admin/products/stock_mailer_menu')