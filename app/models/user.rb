class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider         = auth["provider"]
      user.uid              = auth["uid"]
      user.name             = auth["info"]["name"]
      user.token            = auth['credentials']['token']
      user.secret           = auth['credentials']['secret']
      user.picture          = auth['extra']['raw_info']['profile_image_url']
      user.twitter_id       = auth['extra']['raw_info']['id_str']
      user.bgpic            = auth['extra']['raw_info']['profile_background_image_url']
    end
  end

  def feed
    consumer_key = OAuth::Consumer.new(ENV['TWITTER_REST_API1'],ENV['TWITTER_REST_API2'])
    access_token = OAuth::Token.new(token,secret)
    path = "/1.1/statuses/home_timeline.json"
    encoded_query = URI.encode_www_form([["count",1]])
    baseurl = "https://api.twitter.com"
    verb = "GET"
    address = URI("#{baseurl}#{path}?#{encoded_query}")

    http             = Net::HTTP.new address.host, address.port
    http.use_ssl     = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    if verb == "GET"
      request = Net::HTTP::Get.new address.request_uri
    elsif verb == "POST"
      request = Net::HTTP::Post.new address.request_uri
    end

    request.oauth! http, consumer_key, access_token
    http.start
    response = http.request request
    return JSON.parse(response.body)
  end
end
