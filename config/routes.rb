


Rails.application.routes.draw do

   # The priority is based upon order of creation: first created -> highest priority.
   # See how all your routes lay out with "rake routes".

   # You can have the root of your site routed with "root"



   root "session#new"

   get  "/login",  to: "session#new"
   post "/login",  to: "session#create"
   get  "/logout", to: "session#destroy"

   resources :user do
      member do
         post :update_settings, to: "user#update_settings"
      end
   end
   resources :group
   resources :list do
      resources :item do
         member do
            get   :quick_edit,   to: "item#quick_edit"
            patch :quick_update, to: "item#quick_update"
         end
      end
      member do
         post :share, to: "list#share"
      end
   end
   resources :product
   resources :vendor do
      resources :inventory
   end
   resources :note do
      member do
         post :share,    to: "note#share"
         get  :download, to: "note#download"
      end
   end
   resources :comment

   get "/about",        to: "main#about"
   get "/kittenkitten", to: "main#kittenkitten"



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




