Rails.application.routes.draw do
  root 'charts#hello'

  resources :charts, only: :show do
    get 'not-found' => 'charts#not_found', as: 'not_found', on: :collection
    get 'data' => 'charts#data', on: :member
  end

  get '*unmatched_route', to: 'charts#not_found'
end
