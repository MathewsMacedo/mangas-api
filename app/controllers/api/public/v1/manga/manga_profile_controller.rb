class Api::Public::V1::Manga::MangaProfileController < Api::Public::V1::Manga::BaseController

    def profile
        params[:name] = params[:name].to_s.downcase
        params[:name] =  params[:name].to_s.gsub(/[^0-9A-Za-z]/, '')
        url = "https://mangalivre.net/manga/#{params[:name].to_s}/#{params[:id_serie].to_s}"
        manga = get_info_manga(url)
        unless manga.nil?
            render json: {serie: manga}, status: :ok
        else
            render json: { error: 'Not Found'}, status: :not_found
        end
    end

    def all_chapters
        params[:name] = params[:name].to_s.downcase
        params[:name] =  params[:name].to_s.gsub(/[^0-9A-Za-z]/, '')

        url = "https://mangalivre.net/manga/#{params[:name].to_s}/#{params[:id_serie].to_s}"
        manga = get_info_manga(url)

        chapters = get_all_chapters(params[:id_serie])

        manga["chapters_all"] = chapters
        unless chapters.empty? ||  chapters.nil?
            render json: {serie: manga}, status: :ok
        else
            render json: { error: 'Not Found', name: params[:name]}, status: :not_found
        end
    end

    # def page_chapters
    #     params[:name] = params[:name].to_s.downcase
    #     params[:name] =  params[:name].to_s.gsub(/[^0-9A-Za-z]/, '')
    #     chapters = get_page_chapters(params[:id_serie],params[:page])
    #     unless chapters.empty? ||  chapters.nil?
    #         render json: {chapters: chapters}, status: :ok
    #     else
    #         render json: { error: 'Not Found', name: params[:name]}, status: :not_found
    #     end
        
    # end

    private

    def get_info_manga url
        response = get_html(url)
        profile = nil
        if response.code == 200
            manga = response.body
            id_serie = params[:id_serie].to_i
            cover = get_cover(manga) #
            name = get_name(manga) #
            chapters = get_number_chapters(manga).to_i
            score = get_score(manga).to_f
            description = get_description(manga) #
            categories = get_categories(manga)
            artist = get_artist(manga)
            is_complete = get_is_complete(manga)
            lang = get_lang(manga) #
            chapters_all = "/api/public/v1/manga/#{params[:name]}/#{params[:id_serie]}/all"

            profile = {
                id_serie: id_serie, 
                cover: cover, 
                name: name, 
                categories: categories,
                chapters: chapters,
                description: description, 
                artist: artist,
                score: score,
                is_complete: is_complete,
                lang: lang,
                chapters_all: chapters_all
            }
        end
        profile
    end


    def get_all_chapters id_serie
        chapters = []
        id_serie = id_serie.to_i
        i = 1
        while true
            response = get_json("https://mangalivre.net/series/chapters_list.json?page="+i.to_s+"&id_serie="+id_serie.to_s+"")
            unless response["chapters"] == false || response["chapters"].nil? || response["chapters"].empty?
                for c in 0..response["chapters"].length - 1 
                    att = response["chapters"][c]["releases"].to_s.split('"')
                    chapters << {
                    id_serie: response["chapters"][c]["id_serie"],
                    id_chapter: response["chapters"][c]["id_chapter"],
                    name: response["chapters"][c]["id_chapter"],
                    chapter_name: response["chapters"][c]["chapter_name"],
                    number: response["chapters"][c]["number"],
                    date: response["chapters"][c]["date"],
                    date_created: response["chapters"][c]["date_created"],
                    views: response["chapters"][c]["releases"][att[1].to_s]["views"].to_s,
                    link: response["chapters"][c]["releases"][att[1].to_s]["link"].to_s
                    }
                end
            else 
                break
            end 
            i+=1  
        end
        chapters
    end


    # def get_page_chapters id_serie,page
    #     chapters = []
    #     response = get_json("https://mangalivre.net/series/chapters_list.json?page="+page.to_s+"&id_serie="+id_serie.to_s+"")
    #        unless response["chapters"] == false || response["chapters"].nil? || response["chapters"].empty?
    #         for c in 0..response["chapters"].length - 1 
    #                 chapters << {
    #                 id_serie: response["chapters"][c]["id_serie"],
    #                 id_chapter: response["chapters"][c]["id_chapter"],
    #                 name: response["chapters"][c]["id_chapter"],
    #                 chapter_name: response["chapters"][c]["chapter_name"],
    #                 number: response["chapters"][c]["number"],
    #                 date: response["chapters"][c]["date"],
    #                 date_created: response["chapters"][c]["date_created"]
    #                 }
    #         end
    #     end 
    #     chapters
    # end

    def get_number_chapters manga
        chapters_trash = manga.split('<span class="chapters">')
        chapters = chapters_trash[1].split('<img')
        chapters = chapters[0]
        chapters = chapters.gsub("  ","")
        chapters.sub("\n","")
    end

    def get_score manga
        score_trash = manga.split('<div class="score-number">')
        score = score_trash[1].split('</div>')
        score = score[0].gsub(" ","")
        score.sub("\n", "")
    end

    def get_categories manga
        categories_trash = manga.split('Categoria de mangás: ')
        categories = ""
        for i in 1..categories_trash.length-1
            category = categories_trash[i].split("\">")
            categories += category[0]+" | "
        end
        categories[0, categories.length - 3]
    end

    def get_name manga
        name_trash = manga.split('"name": "')
        name = name_trash[3].split('",') #pega o nome
        name[0] #posicao 0 nome
    end 

    def get_artist manga
        name_trash = manga.split('"name": "')
        name = name_trash[4].split('"') #pega o nome
        name[0] #posicao 0 nome
    end


    def get_is_complete manga
        is_complete_trash = manga.split('<img src="/assets/images/layout/number-chapters.png" alt="" />')
        is_complete_trash =  is_complete_trash[1].split('<span>')
        chapters = is_complete_trash[1].split('</span>')
        total =  is_complete_trash[2].split('</span>')

        chapters[0].to_i == total[0].to_i
    end

end
