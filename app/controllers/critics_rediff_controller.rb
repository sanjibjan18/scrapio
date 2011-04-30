class CriticsReviewsController < ApplicationController
 require 'nokogiri'
require 'open-uri'
require 'summarize'
require 'date'
def index
hyperlink = "http://www.rediff.com/movies/reviews10.html"
doc = Nokogiri::HTML(open(URI.encode(hyperlink)))
 movie_alphalist = doc.xpath("//body/div/div/div/div/a")
 mainlink = "http://www.filmfare.com/"
 date_formatter1 = /(January|February|March|April|May|June|July|August|September|Octobe
r|November|December) (\d+{1,2}), (\d{4})/
 date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|Septemb
er|October|November|December) (\d{4})/
 movie_alphalist.each do |movie_alpha|
    begin
    link = movie_alpha['href']
    doc2 = Nokogiri::HTML(open(movie_alpha['href']))
    movie_name = doc2.xpath("//body/div/div/div/span/span/i").text
    movie_content = doc2.xpath("//head/meta[2]")
    puts movie_name
    movie_content.each do |mov_review|
     @review =  mov_review['content']
    end
    reviewer_name = doc2.xpath("//body/div/div/span[@class='grey1']").text.slice(0..29)
    puts reviewer_name
    review_date = doc2.xpath("//body/div/div/div[@class ='sm1 grey1']").text.slice(0..29)
    puts review_date
    mov_rating = doc2.xpath("//img[@class = 'imgwidth']").to_s()
    puts mov_rating
     if mov_rating.include?"rating1" and !mov_rating.include?"rating1half.gif"
         movie_rating = 1
     elsif mov_rating.include?"rating1half.gif"
         movie_rating = 1.5
     elsif mov_rating.include?"rating2" and  !mov_rating.include?"rating2half.gif"
         movie_rating = 2
     elsif mov_rating.include?"rating2half.gif"
         movie_rating = 2.5
     elsif mov_rating.include?"rating3" and !mov_rating.include?"rating3half.gif"
         movie_rating = 3
     elsif mov_rating.include?"rating3half.gif" 
         movie_rating = 3.5
     elsif mov_rating.include?"rating4" and !mov_rating.include?"rating4half.gif"
         movie_rating = 4
     elsif mov_rating.include?"rating4half.gif"
         movie_rating = 4.5
     elsif mov_rating.include?"rating5"
         movie_rating = 5
     else
         movie_rating = 0
     end
     puts movie_rating
     puts @review
     CriticsReviews.create(:rating => movie_rating, :summary => @review, :review_date => review_date, :author => reviewer_name, :movie_name => movie_name, :film_critic_name => reviewer_name, :link => link) unless CriticsReviews.where(:author => reviewer_name, :movie_name => movie_name).exists?       
   rescue OpenURI::HTTPError
     next   
   end
 end
end
end
