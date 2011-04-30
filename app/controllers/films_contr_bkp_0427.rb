class FilmsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'date'
  require 'uri'
  def index
   doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_Bollywood_films"))
   movie_years = doc.xpath("//body/div/div/ul[5]/li/a")
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
    movie_release = doc1.xpath("//body/div/div/table/tr/td/i/b/a")
    puts movie_release
    movie_release.each do |name_release|
      name_link = wikilink + name_release['href']
      puts name_link
      begin
       doc3 = Nokogiri::HTML(open(name_link)) 
      rescue OpenURI::HTTPError
       puts "404"
       next
      end
      movie_name = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr/th[@class='summary']").text.gsub(/[^0-9A-Za-z ]+/,'').slice(0..50)
      movie_revenue = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Gross revenue')]/td[1]").text
      movie_director = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Directed by')]/td/br").text
      release_date =doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Release ')]/td[1]").text
      movie_producer = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Produced by')]/td").text.slice(0..80)
      movie_story = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Story by')]/td").text
      movie_music = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Music by')]/td").text.slice(0..90)
      movie_cinematography = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Cinematography')]/td").text.slice(0..90)
      movie_editor = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Editing by')]/td").text
     movie_distributed = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Distributed by')]/td").text.slice(0..90)
      movie_thumbnail = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr/td/a[@class = 'image']/img") 
     movie_thumbnail.each do |link|
     @image_link =  link['src']
     end
     puts movie_music
      if release_date[date_formatter1]
        movie_release_date = Date.parse(release_date[date_formatter1])
      elsif release_date[date_formatter2]
        movie_release_date = Date.parse(release_date[date_formatter2])
      end
      begin
      Films.create(:name => movie_name,:thumbnail_image => movie_name.gsub(' ','_'),:release_date => movie_release_date,:wiki_link => name_link,:directed_by => movie_director,:produced_by=>movie_producer,:written_by => movie_story,:cinematography => movie_cinematography,:edited_by => movie_editor, :music=> movie_music, :distributors => movie_distributed) unless Films.where(:name => movie_name).exists?
      puts "over"
      image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+movie_name.gsub(' ','_')+".png","wb")
      image << open(@image_link).read
      @image_link = "http://cf2.themoviedb.org/assets/12d3716130af9/images/no-poster.jpg"
      rescue PGError
       puts movie_name
       next
      rescue TypeError
       puts movie_name
       next
      rescue OpenURI::HTTPError
       puts @image_link
       next
      end
  end

end
end
end
