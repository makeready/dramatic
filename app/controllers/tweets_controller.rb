class TweetsController < ApplicationController
  def show
    @tweet = Tweet.find(params[:id])
  end
end
