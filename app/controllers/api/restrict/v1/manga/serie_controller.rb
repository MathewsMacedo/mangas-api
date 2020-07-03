class Api::Restrict::V1::Manga::SerieController < ApplicationController
    protect_from_forgery prepend: true
   
    def create 
        header = request.headers['token']
        header = header.split(' ').last if header
   
        if header == Rails.application.credentials.manga_api_insert 
   
            @serie = Serie.new(serie_params)
            if @serie.save
                render json: { serie: @serie}, status: :ok
            else
                render json: { errors: @serie.errors.full_messages }, status: :unprocessable_entity
            end
   
   
        else
             render json: { error: 'Access Unauthorized'}, status: :unauthorized
        end
   
    end
    
    def update 
        header = request.headers['token']
        header = header.split(' ').last if header

        if header == Rails.application.credentials.manga_api_insert 
            id = params[:id].to_i

            @serie = Serie.find(id)
            @serie.updated_at = DateTime.now
            if @serie.update(serie_params)
                render json: { serie: @serie}, status: :ok
            else
                render json: { errors: @serie.errors.full_messages }, status: :unprocessable_entity
            end

        else
             render json: { error: 'Access Unauthorized'}, status: :unauthorized
        end

    end

    private
    def serie_params
        if params[:is_complete] == "true" || params[:is_complete] == true
            params[:is_complete] = true 
        else
            params[:is_complete] = false
        end
        params.permit(
            :id_serie,
            :cover,
            :name,
            :categories, 
            :chapters, 
            :description, 
            :artist, 
            :score, 
            :is_complete, 
            :lang, 
            :chapters_all,
            :images_all
        )
    end
end
