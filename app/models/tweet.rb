class Tweet < ActiveRecord::Base

  has_many :context_tweets, class_name: "Tweet", foreign_key: 'inspired_id'
  belongs_to :inspired_tweet, class_name: "Tweet"
  #enables tweet.context_tweets and tweet.inspired_tweet
  #
  #  CONTEXT_TWEET CONTEXT_TWEET
  #  \_________________________/
  #              |
  #        INSPIRED_TWEET

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def api_call(path,query,verb)
   
    consumer_key = OAuth::Consumer.new(ENV['TWITTER_REST_API1'],ENV['TWITTER_REST_API2'])

    access_token = OAuth::Token.new(
      current_user.token,
      current_user.secret)
    encoded_query = URI.encode_www_form(query)
    baseurl = "https://api.twitter.com"
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
    return http.request request

  end

  def find_keywords
    output = []
    load_tweet_json["text"].split.each do |word|
      clean_word = strip_punctuation(word)
      output << clean_word unless Dictionary.found?(clean_word)
    end
    output
  end

  def strip_punctuation(word)
    word.gsub(/[^[:alnum:]]/, "").downcase
  end

  def tweet_id
    return self.url.split("/").last
  end

  def load_tweet_json
    response = api_call("/1.1/statuses/show.json",[["id", tweet_id]],"GET")
    tweet = nil
    if response.code == '200' then
      tweet = JSON.parse(response.body)
      #print_tweet(tweet)
      #puts "Keywords in tweet: #{find_keywords(tweet["text"],excluded_words)}"
    end
    return tweet
  end

  def reply_to
    load_tweet_json["in_reply_to_status_id_str"]
  end

  def followings
    response = api_call("/1.1/friends/ids.json",[["user_id", current_user.twitter_id],["stringify_ids", true]],"GET")
    return JSON.parse(response.body.ids)
  end

  def create_new_list(followings)
    populate_empty_list(create_empty_list, followings)
    return list_id
  end

  def create_empty_list
    timestamp = Time.now.to_i.to_s
    response = api_call("/1.1/lists/create.json",[["name", "context#{timestamp}"]],"POST")
    return JSON.parse(response.body.id)
  end

  def populate_empty_list(list_id, followings)
    numcalls = round_up(followings.length,100) / 100
    numcalls.times do |call|
      users = followings[(call-1)*100..(call*100)-1].join(",")
      api_call("/1.1/lists/members/create_all.json",[["list_id", list_id],["user_id",users]],"POST")
    end
    return list_id
  end

  def round_up(number, divisor)
    i = number / divisor
    remainder = number % divisor
    if remainder == 0
      i * divisor
    else
      (i + 1) * divisor
    end
  end

  def parse_list(list_id)
    timeline = api_call("1.1/lists/statuses.json",[["list_id", list_id],["include_rts",true],["max_id",tweet_id]])
  end

  def generate_context

    return [reply_to] if reply_to

    match_score = Hash.new(0)

    list_id = create_new_list(followings)
    tweets_to_scan = parse_list(list_id)
    tweets_to_scan.each do |tweet|
      clean_tweet = strip_punctuation(tweet.text)
      find_keywords.each do |keyword|
        match_score[tweet] += 1 if clean_tweet.include?(keyword)
      end
    end
    delete_list(list_id)
    return match_score.sort_by{|k,v| v}.take(2)#.map{|x| x[0]}
    # RETURNS [[tweet,score],[tweet,score]] UNCOMMENT TO JUST GET [tweet,tweet]
  end
end
