Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :users do
        resources :posts do
          resources :comments
        end
        resources :comments
      end
      resources :posts do
        post 'like'
        post 'unlike'
      end
      resources :comments do
        post 'like'
        post 'unlike'
      end
    end
  end
end
