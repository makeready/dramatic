# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  
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

  def create
    @tweet = Tweet.new(tweet_params)
    if @tweet.save
      redirect_to tweet_path(@tweet)
    else
      render :new
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  private

  def tweet_params
    params.require(:tweet).permit(:url)
  end
end
