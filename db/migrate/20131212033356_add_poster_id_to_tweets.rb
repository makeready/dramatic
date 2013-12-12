class AddPosterIdToTweets < ActiveRecord::Migration
  def change
  	add_column :tweets, :poster_id, :string
  end
end
