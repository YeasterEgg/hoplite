Rails.application.routes.draw do

  root 'products#index'

  post 'sales/upload_file', to: 'sales#upload_file', as: 'upload_sales_file'

  resources :products, only: [:index, :show]

end
