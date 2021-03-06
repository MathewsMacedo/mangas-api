class Api::Public::V1::Manga::MangaListController < Api::Public::V1::Manga::BaseController

    def all 
        mangas = Serie.select(:id_serie, :cover, :name, :categories, :chapters, :description, :artist, :score, :is_complete, :lang)
        .order("LOWER(name) asc").limit(10).offset(params[:page].to_i * 10)
        .as_json(:except => :id)
        unless mangas.empty? || mangas.nil?
            render json: {series: mangas}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    def letter
        params[:page] = 1 if params[:page].nil? 
        mangas = Serie.select(:id_serie, :cover, :name, :categories, :chapters, :description, :artist, :score, :is_complete, :lang)
        .where("LOWER(name) like ? ", "#{params[:name].to_s[0..0].downcase}%")
        .order("LOWER(name) asc").limit(10).offset(params[:page].to_i * 10)
        .as_json(:except => :id)
        unless mangas.empty?
            render json: {series: mangas}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    def search
        mangas = Serie.select(:id_serie, :cover, :name, :categories, :chapters, :description, :artist, :score, :is_complete, :lang)
        .where("LOWER(name) like ? ", "#{params[:name].to_s.downcase}%")
        .order("LOWER(name) asc").limit(10)
        .as_json(:except => :id)
        unless mangas.empty?
            render json: {series: mangas}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    def categories
        series = Serie.select(:categories).all() 
        categories = []
        series.each do |serie| 
            if serie.categories.present?
                cat = serie.categories.split(' | ')
                    unless cat.nil? || cat.empty?
                        cat.each do |c| 
                             i = categories.index {|cat| cat["name"] == c}
                             if i.nil?
                                categories << {"name" => c, "titles" => 1}
                             else
                                categories[i]["titles"] += 1
                             end
                        end
                    end
            end
        end
        unless categories.empty?
            categories.sort_by!{|c| c["name"]}
            categories.sort_by!{|c| c["name"]}.reverse! if params.include? "desc" and params.include? "name"
            categories.sort_by!{|c| c["titles"]} if params.include? "titles"
            categories.sort_by!{|c| c["titles"]}.reverse! if params.include? "desc" and params.include? "titles"
          
            render json: {categories: categories}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    def show_category
        category = params[:category]
        serie = Serie.select(:id_serie, :cover, :name, :categories, :chapters, :description, :artist, :score, :is_complete, :lang)
                .where("LOWER(categories) like ? ","%#{category.to_s.downcase}%")
                .order("LOWER(name) asc").limit(10).offset(params[:page].to_i * 10)
                .as_json(:except => :id)
        if serie.present?
            render json: {series: serie}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    def all_manga_livre
        url = "https://mangalivre.net/lista-de-mangas/ordenar-por-nome/todos?page=#{params[:page]}"
        mangas = get_info_manga(url)
        unless mangas.empty?
            render json: {series: mangas}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    def letter_manga_livre
        url = "https://mangalivre.net/lista-de-mangas/ordenar-por-nome/#{params[:letter]}?page=#{params[:page]}"
        mangas = get_info_manga(url)
        unless mangas.empty?
            render json: {series: mangas}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end

    private

    def get_info_manga url
        response = get_html(url)
        list = []
        if response.code == 200
            mangas = manga_location(response.body)
            for i in 0..mangas.length-1
        
                id_serie = get_id_serie(mangas[i]).to_i
                name = get_name(mangas[i])
                chapters = get_number_chapters(mangas[i]).to_i
                score = get_score(mangas[i]).to_f
                description = get_description(mangas[i])
                cover = get_cover(mangas[i])
                categories = get_categories(mangas[i])
                artist = get_artist(mangas[i])
                is_complete = get_is_complete(mangas[i])
                lang = get_lang(mangas[i])

                list << {
                    id_serie: id_serie, 
                    cover: cover, 
                    name: name, 
                    categories: categories,
                    chapters: chapters,
                    description: description, 
                    artist: artist,
                    score: score,
                    is_complete: is_complete,
                    lang: lang
                }

            end
        end
        list
    end

    def get_id_serie manga  
        id_serie_trash = manga.split('/') #pegar o id do manga no link
        id_serie = id_serie_trash[1].split('"') #pega o id
        id_serie[0] #posicao 0 id_serie
    end

    def get_categories manga
        categories_trash = manga.split('<span class="nota">')
        categories = ""
        for i in 2..categories_trash.length-1
            category = categories_trash[i].split('</span>')
            categories += category[0]+" | "
        end
        categories[0, categories.length - 3]
    end
    
    def get_number_chapters manga
        chapters_trash = manga.split('alt="number of chapters">')
        chapters = chapters_trash[1].split('</span>')
        chapter = chapters[0].gsub(" ","")
        chapter.gsub("\n","")
    end  
    
    def get_score manga
        score_trash = manga.split('<span class="nota">')
        score = score_trash[1].split('</span>')
        score[0]
    end
    
    def get_is_complete manga
        if manga.include? '<i class="complete-series">'
            return true
        end
        return false
    end
    
    def manga_location response
        manga_location_trash = response.split('href="/manga/') #separa os mangas da pagina por bloco
        manga_location = []
        for i in 1..manga_location_trash.length-1
            manga_location << manga_location_trash[i]
        end
        manga_location
    end
    
end
