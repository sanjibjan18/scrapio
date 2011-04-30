class UpcomingReleasesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  def index
    doc = Nokogiri::HTML(open("http://www.bollywoodhungama.com/trade/releasedates/index_in.html"))
    movie_releases = doc.xpath("//input[@type='hidden' and @name='moviehdn']/@value").to_s()
    info = movie_releases.gsub(/\~/,"\n").split("\n")
    info.each { |info1|
      mov_name = info1.split('\|')
      mov_name.each { |info2|
        info3 = info2.gsub(/\|/,"    ").split("    ")
        puts info3[0]+" "+info3[1]+" "+info3[2]
        UpcomingReleases.create(:name => info3[1],:release_date => info3[2],:thumbnails => info3[0])
        hyperlink = "http://i.indiafm.com/img/firstlook/posters/"+info3[0]+".jpg"
        image = File.new("/home/ubuntu/muvi.in/public/thumbnails/"+info3[0]+".jpg","wb")
        begin
        image << open(hyperlink).read
        rescue OpenURI::HTTPError
         next
        end
      }
    }
  end
end
