Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static#home'

  resource :membership_application, only: %i[create show], path: 'membership-application' do
    get 'completed'
    resources :steps, only: %i[show update], controller: 'membership_applications/steps'
  end

  resource :subscription_rate, only: :show, path: 'subscription-rate'

  authenticate :user do
    namespace :admin do
      root to: redirect('admin/membership-applications'), as: :user_root
      resources :membership_applications, only: %i[show index], path: 'membership-applications'
      resources :authentication_tokens, only: %i[index create destroy], path: 'authentication-tokens'
      get 'profile', to: redirect('admin/authentication-tokens'), as: 'profile'
    end
    get '/admin', to: redirect('admin/membership-applications')
  end
end
