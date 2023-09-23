Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_scope :user do
    put :switch_session, to: 'users/sessions#switch_session'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "dotcom#index"

  get '/dashboard', :to => 'dotcom#dashboard'
  resource :organization
  resources :influencers

  resources :gigs
  # Already made all the associations so changing the name would be very time taking (sorry)
  resources :projects, path: :campaigns do
    resources :project_applications
  end
  # When you submit a deliverable for a milestone, you can view the milestone
  resources :project_milestones, only: :show do
    resources :project_deliverables
  end
end
