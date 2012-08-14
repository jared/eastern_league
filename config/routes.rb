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

  # Event-specific named routes; these need to be updated annually.
  match 'OBSKC', :controller => "events", :action => "show", :id => "1000"
  match 'obskc', :controller => "events", :action => "show", :id => "1000"

  match 'TISKC', :controller => "events", :action => "show", :id => "1001"
  match 'tiskc', :controller => "events", :action => "show", :id => "1001"

  match 'MASKC', :controller => "events", :action => "show", :id => "1002"
  match 'maskc', :controller => "events", :action => "show", :id => "1002"

  match 'ECSKC', :controller => "events", :action => "show", :id => "1003"
  match 'ecskc', :controller => "events", :action => "show", :id => "1003"

  match 'ODSKC', :controller => "events", :action => "show", :id => "1004"
  match 'odskc', :controller => "events", :action => "show", :id => "1004"


  resource :calendar
  resource :user_session

  resources :announcements

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
  resources :jackets

  resources :standings

  resources :events do
    resources :scores
    resources :registrations
    resources :comments
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
