class FilmsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'date'
  def index
   doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_Bollywood_films"))
   movie_years = doc.xpath("//body/div/div/ul[2]/li[3]/a")
   wikilink = "http://en.wikipedia.org"
   date_formatter1 = /(January|February|March|April|May|June|July|August|September|October|November|December) (\d+{1,2}), (\d{4})/
   date_formatter2=/(\d+{1,2}) (January|February|March|April|May|June|July|August|September|October|November|December) (\d{4})/
   movie_years.each do |year_release|
   year_link = wikilink + year_release['href']
    begin
     doc1 = Nokogiri::HTML(open(year_link))
    rescue  OpenURI::HTTPError
     puts "404"
     next
    end
    movie_release = doc1.xpath("//body/div/div/table[@class='wikitable']/tr/td/i/a")
    movie_release.each do |name_release|
      name_link = wikilink + name_release['href']
      begin
       doc3 = Nokogiri::HTML(open(name_link)) 
      rescue OpenURI::HTTPError
       puts "404"
       next
      end
      movie_name = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr/th[@class='summary']").text.gsub(/[^0-9A-Za-z ]+/,'').slice(0..50)
      movie_revenue = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Gross revenue')]/td[1]").text
      movie_director = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Directed by')]/td[1]").text
      movie_release =doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Release ')]/td[1]").text
      movie_producer = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Produced by')]/td").text
      movie_music = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Music by')]/td").text
      movie_cinematography = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Cinematography')]/td").text
      movie_editor = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Editing by')]/td").text
     movie_distributed = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Distributed by')]/td").text
      puts movie_name
      puts movie_revenue 
      puts movie_director
      puts movie_producer
      puts movie_music
      puts movie_cinematography
      puts movie_editor
      puts movie_distributed
      
      puts "\n" 
      if movie_release[date_formatter1]
        release_date = Date.parse(movie_release[date_formatter1])
      elsif movie_release[date_formatter2]
        release_date = Date.parse(movie_release[date_formatter2])
      end
      #begin
     # Films.create(:name => movie_name,:release_date => movie_release,:thumbnail_image => movie_name.gsub(' ','_'),:release_date => release_date,:wiki_link => name_link) unless Films.where(:name => movie_name).exists
      #image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+movie_name.gsub(' ','_')+".png","wb")
      #image << open(@image_link).read
      #@image_link = "http://oza.ucoz.com/NO_POSTER105.jpg"
      #rescue PGError
       #puts movie_name
       #next
      #rescue OpenURI::HTTPError
      # puts @image_link
      # next
      #end
  end

end
end
end
