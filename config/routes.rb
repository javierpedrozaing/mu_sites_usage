SitesUsage::Application.routes.draw do

  resources :sessions, :only => [:new, :create, :destroy]

  resources :users, :except => [:show]
  
  resources :sites, :except => [:show]
  
  resources :clients, :only => [:index, :update, :destroy]
  
  resources :departments do 
    resources :sites, :only => [:show]
    member do
      match 'sites', :to => redirect("/sites")
    end
  end
  
  match '/departments/:department_id/sites/*sites', :to => 'sites#show'
  match '/sites/refresh/*sites', :to => 'sites#refresh'
  match '/sites/popup/:id', :to => 'sites#popup'
  
  match '/api', :to => 'api#index'
  match '/api/counts/:id', :to => 'api#counts'
  match '/api/*sites', :to => 'api#sites', :as => 'api_site'
  
  match '/login', :to => 'sessions#new'
  match '/logout', :to => 'sessions#destroy'
  match '/stats', :to => 'stats#index'
  match '/logs', :to => 'logs#index'
  match '/clients', :to => 'clients#index'
  
  post '/stats/show', :to => 'stats#show'
  get '/stats/show', :to => 'stats#show'
  
  root :to => 'departments#index'
  post 'clients/upload'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
