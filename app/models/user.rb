class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create! do |user|
      debugger
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
      user.picure = auth['extra']['raw_info']['profile_image_url']
    end
  end
end
