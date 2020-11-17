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
  }
end
