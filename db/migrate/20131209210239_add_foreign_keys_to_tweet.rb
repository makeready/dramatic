class AddForeignKeysToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :inspired_id, :integer
  end
end
