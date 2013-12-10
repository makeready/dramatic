class AddBgpicToUser < ActiveRecord::Migration
  def change
    add_column :users, :bgpic, :string
  end
end
