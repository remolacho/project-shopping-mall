Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

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
      end
    end
  end

  namespace(:v1, defaults: { format: :json }) {
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
      end
    end

    namespace :orders do
      resources :shopping_cart, path: 'shoppingCart', param: :order_item_id,
                only: [:update, :destroy, :index] do

        collection do
          get :create, path: 'addItem'
        end
      end

      resources :check_order, path: 'checkOrder', param: :order_token, only: [:show]

      resources :payment, only: [:create]

      resources :order, path: '', param: :token, only: [] do
        resources :user, only: [:create]
        resources :shipment, only: [:create]
      end
    end

    namespace :stores do
      resources :list, only: [:index]
      resources :detail, param: :store_id, only: [:show]
    end

    namespace :group_titles, path: 'groupTitles' do
      resources :categories, param: :title_id, only: [:index, :show]
    end
  }
end
