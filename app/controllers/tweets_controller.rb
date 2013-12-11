# -*- encoding : utf-8 -*-
class TweetsController < ApplicationController
  def show
    @tweet = Tweet.find(params[:id])
  end
end
