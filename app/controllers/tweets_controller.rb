# -*- encoding : utf-8 -*-
class TweetsController < ApplicationController
  def show
    @tweet = Tweet.find(params[:id])
  end

  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
      @data = @tweet.generate_context(2,1000)
      # debugger
      # DATA STRUCTURE: [{original_tweet},[[{found_tweet1}, match_score],[{found_tweet2}, match_score]],["kw1","kw2","kw3"]]
      respond_to do |format|
        format.html {head :ok}
        format.js { render partial: "render#{@data[1].length}" }
      end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:url, :user_id, :poster_id)
  end
end
