Rails.application.routes.draw do

  root 'products#index'
  resources :products, param: :code, only: [:index, :show]

  post 'sales/upload_file', to: 'sales#upload_file', as: 'upload_sales_file'
  get 'products/:code/graph_data', to: 'products#graph_data', defaults: { format: 'json' }, as: 'plot_graphs'

  get 'cthulhu', to: 'tools#destroy_all', as: 'cthulhu'

  get 'guests', to: 'tools#ahoy_mates', as: 'ahoy_mates'

  get 'onan', to: 'tools#onan', as: 'onan'

end
