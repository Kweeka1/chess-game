Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/chess/:id', to: "chess#index"
  get '/', to: 'lobby#index'
  post 'create-room', to: 'lobby#create_room'
  post '/username', to: 'lobby#change_username'
  # Defines the root path route ("/")
  root "lobby#index"
end
