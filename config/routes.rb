Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      resources :users do
        resources :posts
        resources :comments
      end
      resources :posts do
        get 'like'
      end
    end
  end
end
