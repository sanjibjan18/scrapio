class CriticsReviewsController < ApplicationController
 require 'nokogiri'
require 'open-uri'
require 'summarize'
require 'date'
def index
doc = Nokogiri::HTML(open("http://www.bollywoodhungama.com/movies/moviesreviewslist.html"))
 movie_years = doc.xpath("//a[@class = 'normal']")
 mainlink = "http://www.bollywoodhungama.com"
 date_formatter1 = /(January|February|March|April|May|June|July|August|September|October|November|December) (\d+{1,2}), (\d{4})/
 date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|September|October|November|December) (\d{4})/
 movie_years.each do |movie_alpha|
  doc1 = Nokogiri::HTML(open(mainlink+movie_alpha['href']))
   movies_list = doc1.xpath("//a[@class = 'new_big']")
   movies_list.each do |review_list|
     doc2 = Nokogiri::HTML(open(mainlink+review_list['href']))
     movie_name = doc2.xpath("//span[@class = 'red_header']").text
     reviewer_name = "Taran Adarsh" 
     review_date = doc2.xpath("//span[@class = 'org']").text.slice(17..33)
     review = doc2.xpath("//span[@class = 'normal']").text+" "
     review_summary = review.split('\n').last.split('.').last+"."
     
     CriticsReviews.create(:rating => 3, :summary => review_summary, :review_date => review_date, :author => reviewer_name, :movie_name => movie_name, :film_critic_name => reviewer_name) unless CriticsReviews.where(:author => reviewer_name, :movie_name => movie_name).exists?
   end       
      
 end
end
end
