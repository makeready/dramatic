# -*- encoding : utf-8 -*-
class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|

      t.timestamps
    end
  end
end
