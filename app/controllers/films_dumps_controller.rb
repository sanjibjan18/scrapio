class FilmsDumpsController < ApplicationController
 require 'net/http'
 require 'open-uri'
 def index
  @filmsdump = FilmsDump.find(:all)
  @filmsdump.each do |film_dump|
       @image_url = "http://img.freebase.com/api/trans/image_thumb"+film_dump.movies_id+"?maxheight=200&maxwidth=130"
       @@image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+film_dump.movies_id[3..-1]+".png","wb")
       @@image << open(@image_url).read
  end
 end
end
