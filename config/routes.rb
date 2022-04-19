Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/unsubscribe' => 'cart#unsubscribe'
  post '/save-cart' => 'cart#save'
  get '/home' => 'cart#home'
  post '/bounce' => 'cart#bounce'
  post '/complaint' => 'cart#complaint'

  root to: 'cart#home'

end
