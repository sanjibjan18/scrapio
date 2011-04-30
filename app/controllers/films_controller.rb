class FilmsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'date'
  require 'uri'
  def index
   linkhome1 = "http://www.imdb.com/search/title?languages=hi&sort=alpha,asc&start="
   linkhome2 = "&title_type=feature"
   for i in (1..150)
   j= i*50
   mainlink = linkhome1+j.to_s()+linkhome2
   puts mainlink
   doc = Nokogiri::HTML(open(URI.parse(mainlink)))
   muvi_link = doc.xpath("//body[@id='styleguide-v2']/div/div/div/div/div[@id='main']/table[@class='results']/tr[@class='even detailed']/td[@class='title']/a")
   #movie_name = doc.xpath("//body[@id='styleguide-v2']/div/div/div/div/div[@id='main']/table[@class='results']/tr[@class='even detailed']/td[@class='title']/a").text
   muvi_link.each do |muvi|
     @movie_link = muvi['href']
     @movie_name = muvi.text 
   
   puts @movie_link
   puts @movie_name
   date_formatter1 = /(&nbsp;)/
   date_formatter2 = /\b\d{1,2}\b\s\b(January|February|March|April|May|June|July|August|September|October|November|December)\b/
   date_formatter3 = /^((31(?!\ (Feb(ruary)?|Apr(il)?|June?|(Sep(?=\b|t)t?|Nov)(ember)?)))|((30|29)(?!\ Feb(ruary)?))|(29(?=\ Feb(ruary)?\ (((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))))|(0?[1-9])|1\d|2[0-8])\ (Jan(uary)?|Feb(ruary)?|Ma(r(ch)?|y)|Apr(il)?|Ju((ly?)|(ne?))|Aug(ust)?|Oct(ober)?|(Sep(?=\b|t)t?|Nov|Dec)(ember)?)\ ((1[6-9]|[2-9]\d)\d{2})/
   date_formatter4 =/(\d{4})/
    muvilink = "http://www.imdb.com"+@movie_link  
    name_link = muvi_link
    doc1 = Nokogiri::HTML(open(muvilink))
   # movie_name = doc1.xpath("//head/title").text
      
      #movie_revenue = doc3.xpath("//body/div/div/table[@class='infobox vevent'][1]/tr[contains(th,'Gross revenue')]/td[1]").text
      movie_director = doc1.xpath("//body[@id='styleguide-v2']/div/div/div/div/div/div/div/table[@id='title-overview-widget-layout']/tr/td[@id='overview-top']/div[@class='txt-block'][1]/a[1]").text
      release_date =doc1.xpath("//body[@id='styleguide-v2']/div/div/div/div/div/div/div/table[@id='title-overview-widget-layout']/tr/td[@id='overview-top']/div[@class='infobar']/span[@class='nobr']/a").text
     if release_date==''
         release_date = doc1.xpath("//body[@id='styleguide-v2']/div/div/div/div/div/div/div/table[@id='title-overview-widget-layout']/tr/td[@id='overview-top']/h1[@class='header']/span/a").text
         puts "nil"
     end
     movie_release_date = release_date
     puts movie_director
     puts movie_release_date
    # puts movie_name
    # puts muvilink
   #  movie_thumbnail.each do |link|
   #  @image_link =  link['src']
   #  end
   #  puts movie_music
   #   if release_date[date_formatter1]
   #     movie_release_date = Date.parse(release_date[date_formatter1])
   #   elsif release_date[date_formatter2]
   #     movie_release_date = Date.parse(release_date[date_formatter2])
   #   end
   #   begin
      Films.create(:name => @movie_name,:initial_release_date => movie_release_date,:wiki_link => muvilink,:directed_by => movie_director) unless Films.where(:name => @movie_name).exists?
      #puts "over"
      #image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+movie_name.gsub(' ','_')+".png","wb")
      #image << open(@image_link).read
      #@image_link = "http://cf2.themoviedb.org/assets/12d3716130af9/images/no-poster.jpg"
    #  rescue PGError
    #   puts movie_name
    #   next
    #  rescue TypeError
    #   puts movie_name
    #   next
    #  rescue OpenURI::HTTPError
    #   puts @image_link
    #   next
    #  end
    end
  end
end
end
