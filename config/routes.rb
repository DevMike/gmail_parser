Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions, only: [:index]
    end
  end

  get '/auth/google_oauth2/callback' => 'api/v1/transactions#populate'
end
