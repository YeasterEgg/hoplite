Rails.application.routes.draw do

  ## Base routes
  root 'products#index'
  resources :products, param: :code, only: [:index, :show]
  post 'upload_file', to: 'tools#upload_file', as: 'upload_sales_file'

  ## Ajax date routes
  get 'products/:code/graph_data', to: 'products#graph_data', defaults: { format: 'json' }, as: 'plot_graphs'
  get 'some_data', to: 'tickets#show_data', as: 'show_real_data'

  ## Tools routes
  get 'cthulhu', to: 'tools#destroy_all', as: 'cthulhu'
  get 'logz', to: 'tools#show_logger', as: 'logs'
  get 'logs/:file', to: 'tools#log_to_ajax', as: 'ajax_logs'
  get 'random_pics', to: 'tools#random_pics', as: 'random_pics'

  ## Help routes
  get 'help', to: 'help#help', as: 'help'
  get 'help/:id', to: 'help#help_to_ajax', as: 'ajax_help'
  get 'mcgyver', to: 'help#new_help', as: 'new_help'
  post 'mcgyver', to: 'help#create_help', as: 'create_help'
  delete 'help/:id', to: 'help#delete_help', as: 'delete_help'
end
