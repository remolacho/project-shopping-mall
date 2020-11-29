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
      end
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
    end
  }
end
