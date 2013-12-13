class PagesController < ApplicationController

  def index
    @tweet = Tweet.new
    if current_user
      array = current_user.feed
      @user_feed = Kaminari.paginate_array(array).page(params[:page]).per(3)
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


end
