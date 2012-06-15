class IndexController < ApplicationController
  def index
    @tweet = Tweet.new
    @tweet.name = cookies[:name] || ""
    cond = {
      :tag => params[:tag],
      :name => params[:name],
      :from => params[:from],
      :to => params[:to],
    }
    @tweets = Tweet.search(cond).index
  end

  def post
    @tweet = Tweet.new(params[:tweet])
    cookies[:name] = @tweet.name

    #TODO: hashtag の処理
    @tweet.detect_hashtag

    if @tweet.save
      redirect_to root_path
    else
      render 'index'
    end
  end
end
