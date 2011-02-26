Twhistory::Application.routes.draw do

  root :to => "default#index"

  # top level pages
  match '/about' => 'default#about'
  match '/people' => 'default#people'
  match '/teachers' => 'default#teachers'
  match '/search' => 'default#search'
  match '/contact' => 'default#contact'
  match '/sitemap' => 'default#sitemap'
  match '/ping' => 'default#ping'

  match '/auth/:provider/callback' => 'authentications#create', :controller => 'authentications'
  match '/auth/failure' => 'authentications#failure', :controller => 'authentications'

  #match '/profiles/:id' => 'profiles#show', :as => :public_user
  
  resources :contents
  resources :comments  
  resources :items
  resources :scheduled_items
  resources :broadcasts do
    resource :authentication
  end
  resources :characters do
    resource :authentication
  end
  resources :authentications
  resources :projects do
    resources :items
    resources :characters
    resources :broadcasts do
      resources :scheduled_items
    end
  end    

end