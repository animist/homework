class Tweet < ActiveRecord::Base
  attr_accessible :name, :tweet
  has_many :taggings
  has_many :hashtags, :through => :taggings

  def self.search(cond)
    search = Tweet.where(1)
    unless (cond[:tag].blank?)
      tag_id = []
      cond[:tag].split.each do |t|
        tag_id << Hashtag.select(:id).find_by_tag(t).id rescue next
      end
      tagging_tweet = []
      tag_id.each do |ti|
        Tagging.select(:tweet_id).find_all_by_hashtag_id(ti).each do |tg|
          tagging_tweet << tg.tweet_id
        end
      end
      search = search.where(:id => tagging_tweet)
    end

    search = search.where(:name => cond[:name].split(/\s/)) unless cond[:name].blank?
    from = Date.parse(cond[:from]) rescue Date.parse("1970/1/1")
    to = Date.parse(cond[:to]) rescue Date.tomorrow
    search = search.where(:created_at => from...to)
    return search
  end

  def self.index
    self.limit(20).order('created_at DESC')
  end

  def detect_hashtag
    logger.debug "searching Hashtags.... #{tweet}"

    Hashtag.detect_hashtag(self.tweet).each do |t|
      t.sub!(/^#/, '')
      logger.debug t
      tag = Hashtag.find_by_tag(t) || Hashtag.new(:tag => t)
      self.hashtags << tag
    end
  end
end
