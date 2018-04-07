Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      post 'authenticate', to: 'authentication#authenticate'
      
      resources :users do
        resources :posts, only: [:create] do
          resources :comments, only: [:create]
        end
        get 'comments', to: 'users#comments'
      end
      
      resources :posts, only: [:index, :update, :delete, :show] do
        get 'likes'
        post 'like'
        post 'unlike'
      end        
      resources :comments, only: [:index, :update, :delete, :show] do
        get 'likes'
        post 'like'
        post 'unlike'
      end
    end
  end
end
