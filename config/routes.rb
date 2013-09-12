Hygwit::Application.routes.draw do

  get "contract_cats/index"

  get "contract_cats/new"

  get "contract_cats/edit"

  get "grievance_cats/index"

  get "grievance_cats/new"

  get "grievance_cats/edit"

  resources :users
  resources :password_resets
  resources :nationalities
  resources :currencies
  resources :countries do
    resources :country_absences, shallow: true
    resources :holidays, shallow: true
    resources :gratuity_formulas, shallow: true
    resources :insurance_settings, shallow: true
    resources :insurance_history_settings, only: :index
    resources :insurance_future_settings, only: :index
    resources :insurance_history_rates, only: :index
    resources :insurance_future_rates, only: :index  
    resources :insurance_rates, shallow: true
    resources :insurance_employer_rates, only: :index
    resources :insurance_employer_history_rates, only: :index
    resources :insurance_employer_future_rates, only: :index
    resources :insurance_codes, shallow: true
    resources :insurance_sets, shallow: true
    resources :insurance_thresholds, shallow: true
    resources :insurance_employer_sets, only: :index
    resources :ethnic_groups, shallow: true
    resources :reserved_occupations, shallow: true
    member do
      get 'insurance_menu'
    end
  end
  resources :sectors
  resources :jobfamilies
  resources :qualities
  resources :descriptors, only: [:edit, :update]
  resources :leaving_reasons  
  resources :disciplinary_categories
  resources :grievance_types
  resources :sessions, only: [:new, :create, :destroy]
  resources :absence_types
  resources :contracts
  resources :ranks do
    collection { post :sort }
  end
  resources :pay_categories do
    collection { post :sort }
  end
  resources :pay_items do
    collection { post :sort }
  end
  resources :joiner_actions do
    collection { post :sort }
  end
  resources :leaver_actions do
    collection { post :sort }
  end
  resources :loan_types
  resources :advance_types
  resources :country_admins
  resources :businesses do
    resources :divisions, shallow: true
    resources :old_divisions, only: :index
    resources :departments, shallow: true       
    resources :old_departments, only: :index
    resources :job_ranks, shallow: true do
      collection { post :sort }
    end
    resources :jobs, shallow: true
    resources :old_jobs, only: :index
    resources :absence_cats, shallow: true
    resources :old_absence_cats, only: :index
    resources :leaving_cats, shallow: true
    resources :disciplinary_cats, shallow: true
    resources :grievance_cats, shallow: true
    resources :contract_cats, shallow: true
  end

  root to: 'static_pages#home'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
 

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
