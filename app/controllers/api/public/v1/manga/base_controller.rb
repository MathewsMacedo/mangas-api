class Api::Public::V1::Manga::BaseController < ApplicationController

    def get_json url
        response = HTTParty.get(url)
        response.parsed_response
    end
    
    def get_html url
        response = HTTParty.get(url)
    end
    
    def image_to_base64 url
        require 'open-uri'
        img = open(url)
        Base64.encode64(img.read)
    end

    private #Default def

    def get_cover manga
        cover_trash = manga.split('style="background-image: url(\'')
        cover = cover_trash[1].split('\');')
        if cover[0] == '/assets/images/no-cover.png'
            cover[0] = "#{::Rails.root}/public#{cover[0]}"
        end
        cover[0]
    end

    def get_name manga
        name_trash = manga.split('<span class="series-title"><h1>') #separa os titulos dos mangas
        name = name_trash[1].split('</h1>') #pega o nome
        name[0] #posicao 0 nome
    end 

    def description_include  description, tag
        while description.include? tag
            description = description.sub(tag, "\n")
        end
        description
    end

    def get_description manga
        description_trash =  manga.split('<span class="series-desc">')
        description = description_trash[1].split('</span>')
        description = description[0].gsub("  ","")
        description = description_include(description,"<br>")
        description = description_include(description,"</div>")
        description = description_include(description,"<div>")
        description = description_include(description,"</div><div>")
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
    
    def get_lang manga
        manga = "pt-BR"
    end

end
