Twhistory::Application.routes.draw do

  root :to => "default#index"

  # top level pages
  match '/schedule' => 'default#schedule'
  match '/search' => 'default#search'
  match '/contact' => 'default#contact'
  match '/sitemap' => 'default#sitemap'
  match '/ping' => 'default#ping'

  resources :comments

  resources :projects do
    resources :items
    resources :characters do
      resources :authentications
    end
  end    

end
