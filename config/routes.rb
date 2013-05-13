DatabaseApp::Application.routes.draw do

  resources :users do
    resources :workdays
    
  end
  resources :records, only: [:new, :create]
  resources :workdays, only: [:index, :show]
  resources :logs, only: [:index]
  resources :users, :user_sessions, :groups
  resources :cards, only: [:index, :destroy, :show]
  resources :workdays do
    put 'approve_all', on: :collection
  end
  resources :workhours, only: [:index, :show]
  resources :pin_codes, only: [:index, :create]

  
  match "/export", to: 'records#new'
  match "/import", to: 'users#create_import', via: :post

#  match "/workdays", to: 'workdays#approve_all', via: :post
  match "/manual", to: 'register#manual_register'
  match "/add", to: 'register#add_card'
  

  match 'signup' => 'users#new', as: :signup

  
  match 'signup' => 'users#new', :as => :signup

  
  
  root to: 'register#register'
  
  
  match 'login' => 'user_sessions#new', as: :login
  match 'logout' => 'user_sessions#destroy', as: :logout


  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
