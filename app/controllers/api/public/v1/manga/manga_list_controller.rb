class Api::Public::V1::Manga::MangaListController < Api::Public::V1::BaseController

    def all 
        url = "https://mangalivre.net/lista-de-mangas/ordenar-por-nome/todos?page=#{params[:page]}"
        mangas = get_info_manga(url)
        unless mangas.empty?
            render json: {mangas: mangas}, status: :ok
        else
            render json: { error: 'Not Found' }, status: :not_found
        end
    end
    

    def get_info_manga url
        response = get_html(url)
        list = []
        if response.code == 200
            mangas = manga_location(response.body)
            for i in 0..mangas.length-1
        
                id_serie = get_id_serie(mangas[i])
                name = get_name_manga(mangas[i])
                chapters = get_number_chapters(mangas[i])
                score = get_score(mangas[i])
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

    def get_cover manga
        cover_trash = manga.split('style="background-image: url(\'')
        cover = cover_trash[1].split('\');')
        if cover[0] == '/assets/images/no-cover.png'
            cover[0] = "#{::Rails.root}/public#{cover[0]}"
        end
        cover[0]
    end

    def get_name_manga manga
        name_trash = manga.split('<span class="series-title"><h1>') #separa os titulos dos mangas
        name = name_trash[1].split('</h1>') #pega o nome
        name[0] #posicao 0 nome
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
    
    def get_description manga
        description_trash =  manga.split('<span class="series-desc">')
        description = description_trash[1].split('</span>')
        description = description[0].gsub("  ","")
        while description.include? "<br>"
            description = description.sub("<br>", "\n")
        end
        description = description.sub("\n","")
        description.gsub("\r\n","")
    end
    
    def get_artist manga
        artist_trash = manga.split('<span class="series-author">')
        if artist_trash[1].include? '<i class="complete-series">'
            artist_trash = manga.split('</i>')
        end
        artist = artist_trash[1].split('</span>')
        artist = artist[0].gsub(" ","")
        artist.sub("\n","")
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

    def get_lang manga
        manga = "pt-BR"
    end
    
end
