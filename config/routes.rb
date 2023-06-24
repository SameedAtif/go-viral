Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_scope :user do
    put :switch_session, to: 'users/sessions#switch_session'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "gigs#index"

  resource :organization
  resources :influencers
  # Already made all the associations so changing the name would be very time taking (sorry)
  resources :projects, path: :campaigns do
    resources :project_applications
  end
end
