Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :public do 
      namespace :v1 do 
        namespace :manga do 
          get '/all', to: 'manga_list#all'
          get '/:letter', to: 'manga_list#letter'
        end
      end
    end
  end
end
