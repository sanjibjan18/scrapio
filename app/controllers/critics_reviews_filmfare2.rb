class CriticsReviewsController < ApplicationController
 require 'nokogiri'
require 'open-uri'
require 'summarize'
require 'date'
def index
for i in 1..14
hyperlink = "http://www.filmfare.com/achieve.php?sid=2&ssid=21&pg="+i.to_s()
doc = Nokogiri::HTML(open(URI.encode(hyperlink)))
 doc.encoding = 'ISO-8859-1'
 movie_alphalist = doc.xpath("//h1/a")
 mainlink = "http://www.filmfare.com/"
 date_formatter1 = /(January|February|March|April|May|June|July|August|September|Octobe
r|November|December) (\d+{1,2}), (\d{4})/
 date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|Septemb
er|October|November|December) (\d{4})/
  movie_alphalist.each do |movie_alpha|
   link =  mainlink+movie_alpha['href']
   doc1 = Nokogiri::HTML(open(URI.encode(mainlink+movie_alpha['href'])))
   doc1.encoding ='ISO-8859-1'
   movie_name = doc1.xpath("//div[@class='ttl']/h1").text
   reviewer_name = doc1.xpath("//a[contains(@href,'search.php?keywords=')]").text
   review_date = doc1.xpath("//div[@class='ttl']/span").text
   review = doc1.xpath("//div[@class='cont']/p").text
   puts movie_name
   puts review_date
   puts  reviewer_name
   puts review 

     CriticsReviews.create(:rating => 3, :summary => review, :review_date => review_date, :author => reviewer_name, :movie_name => movie_name, :film_critic_name => reviewer_name, :link => link) unless CriticsReviews.where(:author => reviewer_name, :movie_name => movie_name).exists?       
      
  end
 end
end
end
