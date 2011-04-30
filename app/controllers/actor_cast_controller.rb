class ActorCastController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'uri'
  def index
    baselink = "http://en.wikipedia.org"
    Films.find_each do |movie|
     puts movie.wiki_link
     cast_link = movie.wiki_link + "#Cast"
     doc = Nokogiri::HTML(open(cast_link))
     movie_page = doc.xpath("//body/div/div/table[@class='wikitable']")
     movie_name = doc.xpath("//body/div/h1/i").text
     movie_cast = doc.xpath("//body/div[@id = 'content']/div[@id = 'bodyContent']/ul[1]/li/a")
     movie_role = doc.xpath("//body/div/div/table[@class='wikitable']/tr/td[2]")
     test = movie_cast.to_s()
     puts movie_cast
     movie_cast.each do |cast|
      actor_name = cast.text.slice(0..90)
      actor_hyperlink =  baselink+cast['href'].slice(0..90)
      ActorCast.create(:name => actor_name, :movie_name => movie_name , :hyperlink => actor_hyperlink ) unless ActorCast.where(:name => actor_name, :movie_name => movie_name).exists? 
      #puts actor_name
      #puts movie_name
      #puts actor_hyperlink
      #puts "*"
     end
    end 
  end
end
