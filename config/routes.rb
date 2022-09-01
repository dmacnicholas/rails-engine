Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
      namespace :v1 do
         get '/items/:id/merchant', to: 'merchant_items#show'
        resources :items, only: [:index, :show, :create, :update]
        resources :merchants, only: [:index, :show] do
          resources :items, only: [:index], controller: :merchant_items
      end
    end
  end
end
