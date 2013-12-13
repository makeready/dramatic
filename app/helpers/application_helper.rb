# -*- encoding : utf-8 -*-
module ApplicationHelper

  def ave_color(darkness=0)
    current_user ? current_user.ave_color(darkness) : '#16d061'
  end
  
end
