Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/unsubscribe' => 'cart#unsubscribe'
  post '/save-cart' => 'cart#save'
  get '/home' => 'cart#home'
  post '/bounce' => 'cart#bounce'
  post '/complaint' => 'cart#complaint'

  post '/new-order' => "order#new_order"
  get '/get-order' => "order#fetch_order"
  get '/sync-orders' => "order#sync_orders"

  root to: 'cart#home'

end
