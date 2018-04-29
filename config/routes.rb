Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      resources :apidocs, only: [:index]

      resources :users do
        resources :posts, only: [:create] do
          resources :comments, only: [:create]
        end
        get 'comments', to: 'users#comments'
        get 'search'
      end

      resources :posts do
        get 'likes'
        post 'like'
        post 'unlike'
      end
      resources :comments do
        get 'likes'
        post 'like'
        post 'unlike'
      end
    end
  end
end
