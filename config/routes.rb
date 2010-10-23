Twhistory::Application.routes.draw do

  root :to => "default#index"

  # top level pages
  match '/schedule' => 'default#schedule'
  match '/search' => 'default#search'
  match '/contact' => 'default#contact'
  match '/sitemap' => 'default#sitemap'
  match '/ping' => 'default#ping'

  resources :comments
  
  # resources :items
  # resources :characters
  # resources :authentications
  # resources :broadcasts
  # resources :scheduled_items
    
  resources :projects do
    resources :items
    resources :characters do
      resources :authentications
    end
    resources :broadcasts do
      resources :scheduled_items
    end
  end    

end
