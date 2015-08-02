EasternLeague::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  get '/about'       => 'about#index',       :as => :about
  get '/competitors' => 'about#competitors', :as => :competitors
  get '/organizers'  => 'about#organizers',  :as => :organizers
  get '/spectators'  => 'about#spectators',  :as => :spectators
  get '/contact'     => 'about#contact',     :as => :contact

  get '/links'       => 'about#links',       :as => :links

  get '/login'   => 'user_sessions#new',      :as => :login
  delete '/logout'  => 'user_sessions#destroy',  :as => :logout, :method => :delete

  get '/api/ipn' => 'api#ipn', :as => :ipn

  # Event-specific named routes; these need to be updated annually.
  get '/OBSKC', :controller => "events", :action => "show", :id => "1021"
  get '/obskc', :controller => "events", :action => "show", :id => "1021"

  get '/fallfly', :controller => "events", :action => "show", :id => '1011'
  get '/LBI',    :controller => "events", :action => "show", :id => '1026'

  get '/TISKC', :controller => "events", :action => "show", :id => "1022"
  get '/tiskc', :controller => "events", :action => "show", :id => "1022"

  get '/MASKC', :controller => "events", :action => "show", :id => "1023"
  get '/maskc', :controller => "events", :action => "show", :id => "1023"

  get '/ECSKC', :controller => "events", :action => "show", :id => "1024"
  get '/ecskc', :controller => "events", :action => "show", :id => "1024"

  get '/ODSKC', :controller => "events", :action => "show", :id => "1025"
  get '/odskc', :controller => "events", :action => "show", :id => "1025"


  resource :calendar
  resource :user_session

  resources :announcements
  resources :elections do
    member do
      post :vote
      get :results
    end
  end

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

  resources :standings do
    collection do
      post :calculate
      post :calculate_final
    end
  end

  resources :events do
    resources :scores
    resources :registrations
    resources :comments
    member do
      get :donate
      post :raffle_ticket
    end
  end

  resources :password_resets
  resources :wildwood_registrations do
    member do
      get :receipt
    end
  end

  resources :annual_events
  get '/annual' => 'annual_events#index'

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
