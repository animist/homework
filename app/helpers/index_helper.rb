module IndexHelper
  def linking_tags(tweet)
    Hashtag.detect_hashtag(tweet).each do |t|
      tag = Hashtag.find_by_tag(t.sub(/^#/, ''))
      tweet.gsub!(t, link_to(t, {:controller => 'index', :action => 'index', :tag => tag.tag}))
    end
    return tweet
  end
end
