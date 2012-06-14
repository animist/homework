class Tweet < ActiveRecord::Base
  attr_accessible :name, :tweet
  has_many :taggings
  has_many :hashtags, through => :taggings
end
