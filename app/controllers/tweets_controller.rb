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
      original_tweet = @tweet.load_tweet_json
      found_tweets =  @tweet.generate_context(2,1000)
      keywords = @tweet.find_keywords(original_tweet["text"])
      data = []
      data[0] = original_tweet
      data[1] = found_tweets
      data[2] = keywords
      respond_to do |format|
        format.html {head :ok}
        format.json { render json: data }
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


#[original tweet,[[foundtweet1, score 1],[foundtweet2,score2]],[keywords]]