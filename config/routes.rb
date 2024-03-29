ChoiceWriter::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'home#index'
  resources :facts

  resources :responses do
    collection do
      get 'search/:query', to: 'responses#search'
      get 'by_tag/:tag_name', to: 'responses#by_tag'
      get 'by_folder/:folder_id', to: 'responses#by_folder'
    end
  end

  resources :event_responses do
    collection do
      get 'v0/unity', to: 'event_responses#for_unity'
      get 'v0/web'  , to: 'event_responses#index'
      get 'v0/web/:id'  , to: 'event_responses#show'
      get 'v0/web/by_folder/:id', to: 'event_responses#by_folder'
      get 'v0/web/responds_to_event/:event_name', to: 'event_responses#responds_to_event'
      get 'v0/web/search', to: 'event_responses#search'
    end
  end

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
