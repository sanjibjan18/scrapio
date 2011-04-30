class CriticsReviewsController < ApplicationController
 require 'nokogiri'
require 'open-uri'
require 'summarize'
require 'date'
def index
hyperlink = "http://www.glamsham.com/movies/reviews/"
doc = Nokogiri::HTML(open(URI.encode(hyperlink)))
 movie_alphalist = doc.xpath("//select[@class = 'dropmenu']/option")
 mainlink = "http://www.glamsham.com/movies/reviews/"
 date_formatter1 = /(January|February|March|April|May|June|July|August|September|Octobe
r|November|December) (\d+{1,2}), (\d{4})/
 date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|Septemb
er|October|November|December) (\d{4})/
 movie_alphalist.each do |movie_alpha|
    begin
    link = mainlink+movie_alpha['value']
    puts link
    doc2 = Nokogiri::HTML(open(link))
    movie_name = doc2.xpath("//head/title").text.sub(" movie review : glamsham.com","")
    puts movie_name
    reviewer_name = doc2.xpath("//body/table/tr/td/table/tr/td/table/tr/td/div/center/table/tr/td/font/table/tr/td/font[@class='general']/font").text.sub("By ","").sub(", Glamsham Editorial","").sub(", Bollywood Trade News Network","").sub(", Bollywood Trade Editorial","").sub(", IANS","")
    puts reviewer_name
    review_date = doc2.xpath("//body/table/tr/td/table/tr/td/table/tr/td/div/center/table/tr/td/font/table/tr/td/font[@class='newsdate']").text
    #puts review_date
    mov_rating = doc2.xpath("//body/table/tr/td/table/tr/td/table/tr/td/div/center/table/tr/td/font/strong").text.sub("Rating: ","").sub("Rate: ","").sub("Rating - ","").sub("/5","")
    #puts mov_rating
    @review = doc2.xpath("//body/table/tr/td/table/tr/td/table/tr/td/div/center/table/tr/td/font[@class = 'general']/test").text
    #puts @review
     CriticsReviews.create(:rating => mov_rating, :summary => @review, :review_date => review_date, :author => reviewer_name, :movie_name => movie_name, :film_critic_name => reviewer_name, :link => link) unless CriticsReviews.where(:author => reviewer_name, :movie_name => movie_name).exists?       
   rescue OpenURI::HTTPError
     next   
   end
 end
end
end
