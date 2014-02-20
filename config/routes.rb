Venupickr::Application.routes.draw do

  get "pages/info"
  get "pages/upcoming"
  get "pages/archived"

  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations", sessions: "users/sessions" }
  devise_scope :user do
    match '/users/sign_up/:invitation_token', controller: 'users/registrations', :action => 'new', as: "new_user_registration_with_token"
    match '/users/sign_in/:invitation_token', controller: 'users/sessions', :action => 'new', as: "new_user_session_with_token"
  end

  resources :users, :only => [:edit, :update, :destroy]

  resources :events do
    #guest routes
      match '/guests', controller: 'guests', action: 'new', as: 'guests'
      match '/guests/update_guestlist', controller: 'guests', action: 'update_guestlist'
      match '/guests/leave_event/', controller: 'guests', action: 'leave_event'
      delete '/guests/remove/', controller: 'guests', action: 'remove_guest', as: "remove_guest"

    #venue routes
      resources :venues, except: [:index, :show]
      match '/venue/increment_vote', controller: 'venues', action: 'increment_vote'

    #event interactions
    match '/send_reminder', controller: 'events', action: 'send_reminder'
    match '/post_comment', controller: 'events', action: 'post_comment'

  end
  
  match '/rsvp_yes', controller: 'events', action: 'rsvp_yes', as: "rsvp_yes"
  match '/rsvp_no', controller: 'events', action: 'rsvp_no', as: "rsvp_no"




  match "/contacts/gmail/callback", controller: "guests", action: "omnicontacts"
  match "/contacts/failure", controller: "guests", action: "omnicontacts_failure"

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
