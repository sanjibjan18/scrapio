class MovieInfoController < ApplicationController
  require 'open-uri'
  require 'date'
  require 'uri'
  def index
   baselink = "http://www.imdbapi.com/?i=&t="
   date_formatter2=/(\d+{1,2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Octr|Nov|Dec) (\d{4})/
   Films.find_by_sql("select * from films").each do |movie_name|
    filmname = movie_name.name.gsub(/\ +/,'%20')
    link = baselink+filmname
    #doc = Nokogiri::HTML(open(link))
    doc = Net::HTTP.get_response(URI.parse(link))
    test = doc.body
    result = ActiveSupport::JSON.decode(test).symbolize_keys
    schema = []
    #result[:Title].each do |raw_item|
    begin 
      puts movie_name.name
      puts result[:Title]
      if result[:Actors] ==  'N/A'
         next 
      else
         puts result[:Actors]
         movie_name.update_attributes( :starring => result[:Actors])
      end 
     rescue
       puts movie_name.name
       next
     end 
      
    #end  
   end

  end
end
