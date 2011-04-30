class CriticsReviewsController < ApplicationController
 require 'nokogiri'
require 'open-uri'
require 'summarize'
require 'date'
def index
 ndtv
 filmfare2
 rediff
# glamsham
 indiatoday
end

def bollyhung
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

def ndtv
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

def filmfare2
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

def rediff
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

def glamsham
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

def indiatoday
hyperlink = "http://indiatoday.intoday.in/site/category/reviews/1/137.html"
doc = Nokogiri::HTML(open(URI.encode(hyperlink)))
 movie_alphalist = doc.xpath("//body/div[@id = 'wholecontent']/div[@id = 'leftmiddlerightblock']/div[@id = 'balrightleft']/div[@id=middleblockdiv]/div[@class = 'sectopmarg']/div[@class='sectionpartdiv1']/div[@class='boldbluetext']/a")
 mainlink = "http://indiatoday.intoday.in/site/"
 date_formatter1 = /(January|February|March|April|May|June|July|August|September|Octobe
r|November|December) (\d+{1,2}), (\d{4})/
 date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|Septemb
er|October|November|December) (\d{4})/
puts movie_alphalist
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
    # CriticsReviews.create(:rating => mov_rating, :summary => @review, :review_date => review_date, :author => reviewer_name, :movie_name => movie_name, :film_critic_name => reviewer_name, :link => link) unless CriticsReviews.where(:author => reviewer_name, :movie_name => movie_name).exists?       
   rescue OpenURI::HTTPError
     next   
   end
 end
end

end
