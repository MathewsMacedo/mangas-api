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

            serie = Serie.where(id: id).update_all(id_serie: params[:id_serie], cover: params[:cover],name: params[:name],categories: params[:categories],chapters: params[:chapters],description: params[:description],artist: params[:artist],score: params[:score],is_complete: params[:is_complete],lang: params[:lang],chapters_all: params[:chapters_all],images_all: params[:images_all], updated_at: DateTime.now)
           
            if serie.present?
                serie  = Serie.find(id)
                render json: { serie: serie}, status: :ok
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
