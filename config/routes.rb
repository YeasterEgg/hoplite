Rails.application.routes.draw do

  root "products#index"


  # ## Product routes
  # root 'products#index'
  resources :products, param: :code, only: [:index, :show]
  # get 'products/:code/graph_data', to: 'products#graph_data', defaults: { format: 'json' }, as: 'plot_graphs'
  # resources :panoplies, param: :couple, only: [:show]

  # ## Tools routes
  # get 'cthulhu', to: 'tools#destroy_all', as: 'cthulhu'
  # get 'logs', to: 'tools#show_logger', as: 'logs'
  # get 'logs/:file', to: 'tools#log_to_ajax', as: 'ajax_logs'
  # get 'match_maker', to: 'tools#match_maker', as: 'compute_matches'
  # get 'product_finder', to: 'tools#product_finder', as: 'namefinder'
  # get 'some_data', to: 'tools#show_data', as: 'show_real_data'
  # post 'upload_file', to: 'tools#upload_file', as: 'upload_sales_file'
  # delete 'logs/:file', to: 'tools#delete_log', as: 'delete_log'

  # ## Help routes
  # get 'help', to: 'help#help', as: 'help'
  # get 'help/:id', to: 'help#help_to_ajax', as: 'ajax_help'
  # get 'mcgyver', to: 'help#new_help', as: 'new_help'
  # post 'mcgyver', to: 'help#create_help', as: 'create_help'
  # delete 'help/:id', to: 'help#delete_help', as: 'delete_help'
end
