class Api::Public::V1::Manga::MangaChapterController < Api::Public::V1::Manga::BaseController

    def show_img_chapter
        key = get_key(params[:link])       
        page = get_page(params[:link])     

        img = get_img(page,key)

        unless key.nil? and img.nil?
            render json: {images: img}, status: :ok
        else
            render json: { error: 'Not Found'}, status: :not_found
        end

    end


    private 

    def get_key(link)
        response = get_html("https://mangalivre.net/#{link}")
        key_trash = response.split('.identifier = "')
        key = key_trash[1].split('"')
        key[0]
    end

    def  get_page(link)
        page = link.split('/')
        page[3]
    end

    def get_img (page, key)
        get_json("https://mangalivre.net/leitor/pages/#{page}.json?key=#{key}")
    end
end
