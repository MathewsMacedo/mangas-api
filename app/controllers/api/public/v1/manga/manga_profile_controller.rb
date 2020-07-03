class Api::Public::V1::Manga::MangaProfileController < Api::Public::V1::Manga::BaseController

    def profile
        id_serie = params[:id_serie].to_i
        if id_serie.present?
          manga = Serie.select(:id_serie, :cover, :name, :categories, :chapters, :description, :artist, :score, :is_complete, :lang, :chapters_all)
          .where(id_serie: id_serie).first
          .as_json(:except => :id)
            unless manga.nil?
                chapters_all = JSON.parse(manga["chapters_all"]).map{|chapter| chapter}
                manga["chapters_all"] = chapters_all
                render json: {serie: manga}, status: :ok
            else
                render json: { error: 'Not Found'}, status: :not_found
            end
        end
    end
end
