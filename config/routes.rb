FindYourAdventure::Application.routes.draw do
  
  resources :adventures
  
  namespace :api do
    namespace :v1 do
      match "markets/nearest" => 'markets#nearest'
      resources :markets
      resources :adventures
    end
  end

  root :to => 'adventures#index'
end
