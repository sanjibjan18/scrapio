class FilmCriticsController < ApplicationController
  require 'open-uri' 
  def index
   critname = "Unknown"
   orgname = "FilmFare.com"
   thumbname = "unknown"
   FilmCritics.create(:name => critname,:organization => orgname, :thumbnail_image => thumbname )  unless FilmCritics.where(:name => critname).exists?
   image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+thumbname+".png","wb")
   image_link = "http://t1.gstatic.com/images?q=tbn:ANd9GcQ_ZMhbDwrD-laObt0fVQUIhh83T2PnBrPmBi4719U_4XstWv9e"
   image << open(image_link).read
  end
end
