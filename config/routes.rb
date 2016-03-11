Rails.application.routes.draw do
  resources :sales
  resources :products
  root 'sales#index'
end
