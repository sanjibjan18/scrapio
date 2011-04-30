class CriticsReviewsController < ApplicationController
 require 'nokogiri'
require 'open-uri'
require 'summarize'
require 'date'
def index
  doc  = Nokogiri::HTML(open("http://movies.ndtv.com/review.aspx"))
 movie_alphalist = doc.xpath("//span[@id = 'lb_ReviewHindi']//a[@class = 'text3bold_link']")
 mainlink = "http://movies.ndtv.com/"
 date_formatter1 = /(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), (January|February|March|April|May|June|July|August|September|October|November|December) (\d+{1,2}), (\d{4})/
 date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|September|October|November|December) (\d{4})/
 movie_alphalist.each do |movie_alpha|
   link = mainlink+movie_alpha['href']
   doc1 = Nokogiri::HTML(open(URI.encode(mainlink+movie_alpha['href'])))
   movie_name = doc1.xpath("//span[@id = 'lb_Head']").text.slice(8..108)
   reviewer_name = "Anupama Chopra"
   review_date = Date.parse(doc1.xpath("//span[@id='lb_PostedDate']").text[date_formatter1])
   review = doc1.xpath("//span[@id='lb_StoryFull']").text
   review_summary = review.split('\n').last 

     CriticsReviews.create(:rating => 3, :summary => review_summary, :review_date => review_date, :author => reviewer_name, :movie_name => movie_name, :film_critic_name => reviewer_name, :link => link) unless CriticsReviews.where(:author => reviewer_name, :movie_name => movie_name).exists?       
      
 end
end
end
