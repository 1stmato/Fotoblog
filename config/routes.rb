Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  devise_for :users
  #get 'welcome/index'
  root 'posts#index'

  resources :users do
    get "show"
    patch 'change_admin'
  end

  resources :posts do
    get 'best_posts', on: :collection
    get 'newest_posts', on: :collection
    resources :comments do
      patch "like"
      patch "dislike"
      patch "toggle_visible"
      patch "toggle_valid"
    end
  end
  
  resources :albums do
    match :posts, via: [:get, :patch], on: :member#get 'posts_list', :as => 'posts_list'
    #patch 'add_post'
  end


  get 'posts/filter/:tag_name' => 'posts#filter', as: 'filter'

   get 'posts/filter_best/:tag_name' => 'posts#filter_best', as: 'filter_best'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
