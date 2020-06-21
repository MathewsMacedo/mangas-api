Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :public do 
      namespace :v1 do 
        namespace :manga do 
          get '/all', to: 'manga_list#all'
          get '/:letter', to: 'manga_list#letter'
          get '/:name/:id_serie', to: 'manga_profile#profile'
          get '/:name/:id_serie/:id_chapter', to: 'manga_chapter#show_img_chapter'
        end
      end
    end
    namespace :restrict do
      namespace :v1 do 
        namespace :manga do 
          post '/create', to: 'serie#create'
        end
      end
    end
  end
end
