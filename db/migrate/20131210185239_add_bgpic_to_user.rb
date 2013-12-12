# -*- encoding : utf-8 -*-
class AddBgpicToUser < ActiveRecord::Migration
  def change
    add_column :users, :bgpic, :string
  end
end
