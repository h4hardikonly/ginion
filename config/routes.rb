Rails.application.routes.draw do
  post 'pull_requests/create'

  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }
  root 'users#homepage'
end
