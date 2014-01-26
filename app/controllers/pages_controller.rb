class PagesController < ApplicationController

  def index
    @tweet = Tweet.new
    if current_user
      feed = current_user.feed
      puts "HELLO"
      if feed.is_a? Hash #meaning that we have an error instead of an array of tweets
        @user_feed = []
      else
        @user_feed = feed
      end
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


end
