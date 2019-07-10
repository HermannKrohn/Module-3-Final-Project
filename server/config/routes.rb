Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: 'homepage#home'
  post 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')
  post '/code', to: 'sessions#code'
  get '/.json', to: 'sessions#test'

end
