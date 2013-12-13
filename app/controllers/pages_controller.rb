class PagesController < ApplicationController

  def index
    @tweet = Tweet.new
    if current_user
      array = current_user.feed
      if array['errors'].length > 0
        raise ActionController::RoutingError.new('Twitter SUCKS')
      else
        @user_feed = Kaminari.paginate_array(array).page(params[:page]).per(3)
      end
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


end
