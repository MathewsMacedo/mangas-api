class Api::Public::V1::Manga::MangaChapterController < Api::Public::V1::Manga::BaseController

    def show_img_chapter
        id_link = params[:id_link].to_s
        id_serie = params[:id_serie].to_i       
        
        serie = Serie.where(id_serie: id_serie).first
        images_chapters = JSON.parse(serie.images_all)
        chapters = JSON.parse(serie.chapters_all)
        chapter = {}

        chapters.each do |chp| 
            if chp["id_link"] == id_link
                images_chapters.each do |img|
                    if img["id_link"] == id_link               
                        chapter = chp
                        chapter["images"] = img["images"]
                        break
                    end
                end
            end
        end
        if chapter.present?
            render json: chapter, status: :ok
        else
            render json: { error: 'Not Found'}, status: :not_found
        end

    end 
   
    def show_img_chapter_mangalivre
        page = get_page(params[:link])     
        
        key = get_key(page)       
        img = get_img(page,key)

        unless key.nil? and img.nil?
            render json: {id_link: page, images: img["images"]}, status: :ok
        else
            render json: { error: 'Not Found'}, status: :not_found
        end

    end

    private 

    def get_key(page)
        response = get_html("https://mangalivre.net/manga/anime/#{page}/capitulo-0")
        begin
        key_trash = response.split('.identifier = "')
        key = key_trash[1].split('"')
        rescue 
            return nil
        end
        key[0]
    end

    def  get_page(link)
        link = link.gsub('%2F','/')
        page = link.split('/')
        page[3]
    end

    def get_img (page, key)
        get_json("https://mangalivre.net/leitor/pages/#{page}.json?key=#{key}")
    end
end

