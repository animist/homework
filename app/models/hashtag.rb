class Hashtag < ActiveRecord::Base
  attr_accessible :tag
  has_many :taggings
  has_many :tweets, :through => :taggings

  def self.detect_hashtag(tweet)
    tweet.split(/\s(#\S+)/).select {|t| t.match(/^#/)}
  end
end
