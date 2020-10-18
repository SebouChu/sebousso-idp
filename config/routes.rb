Rails.application.routes.draw do
  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]
  devise_for :users

  get '/saml/auth' => 'saml_idp#create'
  post '/saml/auth' => 'saml_idp#create'
  get '/saml/metadata' => 'saml_idp#show'
  # match '/saml/logout' => 'saml_idp#logout', via: [:get, :post, :delete]

  namespace :admin do
    resources :users, param: :uid
    root 'dashboard#index'
  end

  root 'home#index'
end
