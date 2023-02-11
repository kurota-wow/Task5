Rails.application.routes.draw do
  root 'top#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resource :users, only: %i[show edit update]
  get 'search' => 'rooms#search'
  resources :reservations, only: %i[edit update]
  
  delete "/reservations/:id/destroy" => "reservations#destroy"
  post '/edit_confirm/:id', to: 'reservations#edit_confirm', as: 'edit_confirm'
  resource :reservations do
    member do
      post 'confirm'
    end
  end
  post "/reservations/:id", to: 'reservations#update'
  get 'top/index'
  resource :users do
    member do
      get 'profile'
    end
  end
  resources :rooms do
    member do
      get 'photo_upload'
      get 'room_list'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
