class Hashtag < ActiveRecord::Base
  attr_accessible :tag
  has_many :taggings
  has_many :tweets, through => :taggings
end
