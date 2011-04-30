class TweetController < ApplicationController
 require  'nokogiri'
 require 'open-uri'
 require 'date'
 require 'uri'
 require 'net/http'
 require 'json'
 require 'crack/json'
 def index
 # Tweet.find_each do |tt|
 # end
  Films.order('release_date desc nulls last').each do |film|
    baselink = "http://svc.webservius.com/v1/tweetFeel/tfapi?wsvKey=dJ7WKg1sRCNjhLkoi6-cy1CDT4_s3qg6&keyword="
    appendlink = "&type=all&maxresults=50"
    filmname = film.name.gsub(/\ +/,'%20')
    tweetfeellink = baselink+filmname+appendlink
    filmid = film.id
    puts filmname
    begin
     #doc = Nokogiri::HTML(open(tweetfeellink))
     doc = Net::HTTP.get_response(URI.parse(tweetfeellink))
     test = doc.body
     result = ActiveSupport::JSON.decode(test).symbolize_keys
     #puts result.map{|i| i.map {|j| j * "="} * "\n" } * "\n"
     schema = []
     sleep 200
     result[:tweets].each do |raw_item|
       puts filmid
       puts raw_item["tweet"]
       puts raw_item["date"]
       puts raw_item["type"]
       puts raw_item["username"]
       puts raw_item["status_id"]
        Tweet.create(:movie_id => filmid , :content => raw_item["tweet"] , :tweeted_on => raw_item["date"] , :review => raw_item["type"] , :twitter_screen_name => raw_item["username"] ,:tweet_id => raw_item["status_id"] ) unless Tweet.where( :tweet_id => raw_item["status_id"]).exists?
     end
     rescue Exception
       next
     puts "woke up"
    end
  end
 end
end
