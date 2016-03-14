Rails.application.routes.draw do
  resources :sales
  post 'sales/upload_file', to: 'sales#upload_file', as: 'upload_sales_file'
  resources :products
  root 'sales#index'
end
