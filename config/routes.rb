Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/chess/:id', to: "chess#index"
  get '/chess/', to: 'chess#get_board'
  get '/', to: 'lobby#index'
  # Defines the root path route ("/")
  root "lobby#index"
end
