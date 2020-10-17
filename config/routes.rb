Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard/index'
  end
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  devise_for :users

  namespace :admin do
    resources :users, param: :uid
    root 'dashboard#index'
  end

  root 'home#index'
end
