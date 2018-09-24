Rails.application.routes.draw do

  namespace :pushkin do
    namespace :api do
      namespace :v1 do
        resources :tokens, only: [:create]
      end
    end
  end

end
