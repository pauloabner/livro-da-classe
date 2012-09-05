LivroDaClasse::Application.routes.draw do

	root :to => "pages#home"
	get 'solicitar_contato', :to => "pages#request_contact", :as => :request_contact
	post 'solicitar_contato/enviar', :to => "pages#send_lead", :as => :send_lead

	resources :schools

	resources :people

	resources :books do
		member do 
			get 'finish'
			get 'pdf'
		end
		resources :texts do
			member do 
				get 'finish'
			end
			resources :comments
		end
	end

	match 'welcome/:book_id' => "texts#new", :as => :welcome
	match 'admin'   => "books#index", :as => :admin
	match 'logout'  => "application#logout", :as => :logout
	match 'get_cities_by_state/:name' => "schools#get_cities_by_state", :as => :get_cities
	
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
