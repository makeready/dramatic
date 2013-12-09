class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def index
    @tweet = Tweet.new
  end

  def create
  @tweet = Tweet.new(tweet_params)
  if @tweet.save
    redirect_to tweet_path(@tweet)
  else
    render :new
  end
  end

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def tweet_params
    params.require(:tweet).permit(:url)
  end
end
