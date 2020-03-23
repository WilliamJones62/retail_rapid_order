Rails.application.routes.draw do
  get 'retail_orders/find' => 'retail_orders#find'
  get 'retail_orders/empty' => 'retail_orders#empty'
  get 'retail_orders/quit' => 'retail_orders#quit'
  get 'retail_orders/reject' => 'retail_orders#reject'
  resources :retail_orders do
    resources :retail_order_parts, except: [:index, :show]
  end
  devise_for :users
  devise_scope :user do
    get '/signout', to: 'devise/sessions#destroy', as: :signout
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'retail_orders#find'
end
