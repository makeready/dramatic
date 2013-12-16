class PagesController < ApplicationController

  def index
    @tweet = Tweet.new
    if current_user
      feed = current_user.feed
      if feed.is_a? Hash #meaning that we have an error instead of an array of tweets
        @user_feed = []
        #raise ActionController::RoutingError.new('Twitter SUCKS')
      else
        @user_feed = Kaminari.paginate_array(feed).page(params[:page]).per(3)
      end
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


end
