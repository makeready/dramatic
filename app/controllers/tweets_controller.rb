# -*- encoding : utf-8 -*-
class TweetsController < ApplicationController
  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    @tweet.find_poster_id
    if @tweet.save
      found_tweets =  @tweet.generate_context(1000,2)
      original_tweet = @tweet.load_tweet_json
      combined_tweets = found_tweets.insert(0,original_tweet)
      respond_to do |format|
        format.html {head :ok}
        format.json {render json: combined_tweets}
      end
    else
      render :new
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:url, :user_id, :poster_id)
  end
end
