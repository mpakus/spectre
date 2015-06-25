Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :group_events do
        post :publish, on: :member
      end
    end
  end
end
