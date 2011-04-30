class FilmCriticsReviewsController < ApplicationController
 require 'open-uri' 
 require 'summarize'
 require 'net/http' 
def index
  for i in 11000..11299 do
   begin
   hyperlink = "http://www.bollywoodhungama.com/movies/review/"+i.to_s()+"/index.html"  
   doc = Nokogiri::HTML(open(hyperlink,'User-Agent' => 'ruby'))
   rescue OpenURI::HTTPError
    next

   end 
   FilmCriticsReview.create(:rating=>3,:summary=>doc.xpath("//*[contains(@class,'normal')]").text.summarize(:ratio => 2),:date=>doc.xpath("//*[contains(@class,'graybold')]").text,:author=>doc.xpath("//title").text,:review=>doc.xpath("//*[contains(@class,'normal')]").text.summarize(:ratio => 10),:link=>hyperlink,:movie_name=>doc.xpath("//*[contains(@class,'red_header')]").text)
  
   #puts doc.xpath("//*[contains(@class,'graybold')]").text
  end
 end
end
