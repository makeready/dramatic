class AddFeedstringToUser < ActiveRecord::Migration
  def change
    add_column :users, :feedstring, :text
  end
end
