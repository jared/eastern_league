EasternLeague::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'about'       => 'about#index',       :as => :about
  match 'competitors' => 'about#competitors', :as => :competitors
  match 'organizers'  => 'about#organizers',  :as => :organizers
  match 'spectators'  => 'about#spectators',  :as => :spectators
  match 'contact'     => 'about#contact',     :as => :contact

  match 'links'       => 'about#links',       :as => :links

  match 'login'   => 'user_sessions#new',      :as => :login
  match 'logout'  => 'user_sessions#destroy',  :as => :logout, :method => :delete

  match 'api/ipn' => 'api#ipn', :as => :ipn

  resource :calendar
  resource :user_session
  
  resources :users do
    resources :messages
    resources :orders do
      member do
        get :purchase
        get :thank_you
      end
    end
    resources :memberships do
      new do
        post :confirm
      end
    end
    collection do
      get :search
    end
  end

  resources :standings

  resources :events do
    resources :scores
  end

  resources :password_resets


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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
