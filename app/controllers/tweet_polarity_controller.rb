class TweetPolarityController < ApplicationController
 require 'rubygems'
 require 'stemmer'
 require 'classifier'
 def index
   positive = YAML::load_file("/home/ubuntu/scrap/app/controllers/rt-polarity-pos.yml")
   negative = YAML::load_file("/home/ubuntu/scrap/app/controllers/rt-polarity-neg.yml")
   classifier = Classifier::Bayes.new(:categories => ['Positive','Negative'])
   positive.each { |boo| classifier.train_positive boo }
   negative.each { |good_one| classifier.train_negative good_one }
   puts classifier
   Tweet.find_each do |tt|
    senti =  classifier.classify tt.content
    puts senti
    tt.update_attributes(:review => senti)
   end 
   classifier.remove_stemmer
 end
end
