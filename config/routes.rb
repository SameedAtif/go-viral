Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_scope :user do
    put :switch_session, to: 'users/sessions#switch_session'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "dotcom#index"

  get '/dashboard', :to => 'dotcom#dashboard'
  resource :organization do
    resources :organization_system_packages, only: :create
    resources :organization_package_downgrade_requests, only: :create
  end
  resources :organization_package_downgrade_requests, only: :update

  resources :influencers

  resources :gig_packages, only: [] do
    resources :system_gig_transactions, only: :create
  end
  resources :gig_clients, only: :update
  resources :gigs
  # Already made all the associations so changing the name would be very time taking (sorry)
  resources :projects, path: :campaigns do
    resources :project_disputes, only: :create
    resources :project_applications, only: %i[new index create]
  end
  resources :project_disputes, only: :update
  resources :project_applications, only: %i[update]
  # When you submit a deliverable for a milestone, you can view the milestone
  resources :project_milestones, only: :show do
    resources :project_deliverables, except: :update
  end
  resources :project_deliverables, only: :show do
    resources :project_deliverable_reviews, except: :update
  end
  resources :project_deliverables, only: :update
  resources :project_deliverable_reviews, only: :update

  resources :users, only: [] do
    resources :notifications, only: :index
  end

  resources :notifications, only: [:update, :destroy]

  resources :system_packages, only: :create
  resources :system_project_transactions, only: :create
end
