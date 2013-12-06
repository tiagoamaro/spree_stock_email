Spree::Core::Engine.routes.draw do
  resources :stock_emails, only: :create

  namespace :admin do
    resources :products do
      resources :stock_emails
    end
  end
end
