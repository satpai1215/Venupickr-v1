MoMondays::Application.routes.draw do

  get "pages/info"
  get "pages/upcoming"
  get "pages/archived"
  get "venues/autocomplete_venue_name"


  devise_for :users

  resources :users, :only => [:edit, :update, :destroy]

  resources :events
  resources :venues, :except =>[:index, :show], :path =>"/event/:id/venues/"
  resources :guests


  #match "/users/:id/edit" => 'devise/registrations#edit'
  
  match '/venue/increment_vote', :controller => 'venues', :action => 'increment_vote'
  match '/event/send_reminder', :controller => 'events', :action => 'send_reminder'
  match '/event/post_comment', :controller => 'events', :action => 'post_comment'
  match 'rsvp_yes', :controller => 'events', :action => 'rsvp_yes'
  match 'rsvp_no', :controller => 'events', :action => 'rsvp_no'
 # match '/events/new', :controller => 'events', :action => 'new'

  match '/event/invite_guests', :controller => 'guests', :action => 'new'

  root :to => 'events#index'


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
  # match ':controller(/:action(/:id))(.:format)'
end
