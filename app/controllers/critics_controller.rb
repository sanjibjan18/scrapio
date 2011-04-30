class CriticsController < ApplicationController
  def index
   critname = "Anupama Chopra"
   orgname = "NDTV.com"
   thumbname = "anupama_chopra"
   Critics.create(:name => critname,:organization => orgname, :thumbnail_image => thumbname )  unless Critics.where(:name => critname).exists?
   image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+thumbname+".png","wb")
   image_link = "http://t0.gstatic.com/images?q=tbn:ANd9GcTJn1tlWrSwM1o4DStAzxqtxl086o88qQUyOCVEX-LoRK9g7uSucw"
   image << open(image_link).read
  end
end
