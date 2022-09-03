Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get '/chess/:id', to: "chess#index"
  # Defines the root path route ("/")
  root "chess#get_board"
end
