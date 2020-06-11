class Api::Public::V1::Manga::BaseController < ApplicationController

    def get_json url
        response = HTTParty.get(url)
        response.parsed_response
    end
    
    def get_body url
        response = HTTParty.get(url)
        response.body
    end
    
    def image_to_base64 url
        img = URI.open(url)
        Base64.encode64(img.read)
    end


end
