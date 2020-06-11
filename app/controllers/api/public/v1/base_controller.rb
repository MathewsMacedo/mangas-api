class Api::Public::V1::BaseController < ApplicationController

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


end
