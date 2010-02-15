ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'pages'

  map.devise_for :users
  map.resources :users
  map.resources :leads, :member => { :convert => :get, :promote => :put, :reject => :put }
  map.resources :comments
  map.resources :tasks
  map.resources :accounts
  map.resources :contacts
end
