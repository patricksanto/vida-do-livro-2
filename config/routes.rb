Rails.application.routes.draw do
  root to: "pages#main"

  get 'leads/new'
  get 'leads/create'

  devise_for :users
  get '/ofuturodolivro_masterclass', to: 'pages#home'

  # get '/workshop', to: 'pages#workshop'


  resources :pages, only: [] do
    post 'submit', on: :collection
  end

  post '/waiting_list', to: 'leads#waiting_list'

  resources :leads, only: [:create]
  get '/ofuturodolivro', to: 'leads#new'
  get '/futurodolivro', to: 'leads#new'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
