require'sidekiq/web' 

# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }

  namespace :users do
    resources :profile, only: [] do
      collection do
        get :me
        put :update
      end
    end
    resources :address, param: :address_id, only: [:create, :update]
    resources :provider_sessions, path: 'loginProvider', only: [:create]
    resources :wishlist, only: [:index, :destroy] do
      collection do
        post :create, path: 'addItem'
      end
    end
    resources :password, only: [] do
      collection do
        post :recover
        post :change
      end
    end
  end

  namespace(:v1, defaults: { format: :json }) {
    resources :frequent_questions, path: 'faq', only: [:index]

    namespace :categories, path: '' do
      resources :category, only: [] do
        resources :products, only: [:index]
        resources :children, only: [:index]
      end
    end

    namespace :categories do
      resources :parents, only: [:index]
    end

    namespace :products, path: '' do
      scope :product do
        resources :detail, param: :product_id, only: [:show]
        resources :reviews, param: :product_id, only: [:show]
        resources :reviewers, param: :product_id, only: [:show]
      end
    end

    namespace :products do
      resources :price_range, path: 'priceRange', only: [:index]
      resources :brand, path: 'brands', only: [:index]
      resources :list, path: '', only: [] do
        collection do
          get 'discount/list', to: 'list#discount'
          get 'rating/list', to: 'list#rating'
          get 'recents/list', to: 'list#recents'
        end
      end
    end

    namespace :orders do
      resources :shopping_cart, path: 'shoppingCart', param: :order_item_id,
                                only: %i[update destroy index] do
        collection do
          get :create, path: 'addItem'
        end
      end

      resources :check_order, path: 'checkOrder', param: :order_token, only: [:show]
      resources :completed, path: 'completed', param: :order_token, only: [:show]
      resources :shipment_cost, path: 'shipmentCost', param: :order_token, only: [:show]

      resources :payment, only: [:create]
      post 'shipment_update', to: 'shipment_update#update'

      resources :order, path: '', param: :token, only: [] do
        resources :user, only: [:create]
        resources :shipment, only: [:create]
        resources :promotion, only: [] do
          collection do
            get 'apply/:promo_code', to: 'promotion#apply'
          end
        end
        resources :products, only: [:index] do
          collection do
            post :review
          end
        end
      end

      resources :user, path: 'userOrder', param: :order_token, only: [:show]
      resources :user, path: 'listUser', only: [:index]
    end

    namespace :stores do
      resources :list, only: [:index]
      resources :detail, param: :store_id, only: [:show]
      resources :categories, param: :store_id, only: [:show] do
        collection do
          get '/:store_id/children/:category_id', to: 'categories#children'
        end
      end
    end

    namespace :group_titles, path: 'groupTitles' do
      resources :categories, param: :title_id, only: %i[index show]
      resources :title, path: '', only: [] do
        resources :products, only: [:index]
      end

      resources :list, path: '', only: [] do
        collection do
          get '/:section', to: 'list#index'
        end
      end
    end

    namespace :landing do
      resources :ads, only: [:index]
      resources :slides, only: [:index]
      resources :products, only: [:index]
    end

    namespace :channels_rooms, path: 'channelRooms' do
      resources :store_order, path: '', only: [] do
        resources :room, path: '',  only: [] do
          collection do
            get ':created_by/create', to: 'room#create'
          end
        end
      end
    end
  }
end
