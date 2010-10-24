Twhistory::Application.routes.draw do

  root :to => "default#index"

  # top level pages
  match '/about' => 'default#about'
  match '/search' => 'default#search'
  match '/contact' => 'default#contact'
  match '/sitemap' => 'default#sitemap'
  match '/ping' => 'default#ping'

  match '/auth/:provider/callback' => 'authentications#create', :controller => 'authentications'
  match '/auth/failure' => 'authentications#failure', :controller => 'authentications'

  resources :comments
  
  # resources :items
  # resources :authentications
  resources :characters
  resources :broadcasts
  # resources :scheduled_items
    
  resources :projects do
    resources :authentications
    resources :items
    resources :characters do
      resources :authentications
    end
    resources :broadcasts do
      resources :scheduled_items
    end
  end    

end
