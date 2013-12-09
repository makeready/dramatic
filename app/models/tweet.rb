class Tweet < ActiveRecord::Base

  has_many :context_tweets, class_name: "Tweet", foreign_key: 'inspired_id'
  belongs_to :inspired_tweet, class_name: "Tweet"
  #enables tweet.context_tweets and tweet.inspired_tweet
  #
  #  CONTEXT_TWEET CONTEXT_TWEET
  #  \_________________________/
  #              |
  #        INSPIRED_TWEET

  def api_call(path,query,verb,u)
   
    consumer_key = OAuth::Consumer.new(ENV['TWITTER_REST_API1'],ENV['TWITTER_REST_API2'])

    access_token = OAuth::Token.new(
      u.token,
      u.secret)

    baseurl = "https://api.twitter.com"
    address = URI("#{baseurl}#{path}?#{query}")

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

  def find_keywords(u)
    output = []
    load_tweet_json(u)["text"].split.each do |word|
      clean_word = strip_punctuation(word)
      output << clean_word unless Dictionary.found?(clean_word)
    end
    output
  end

  def strip_punctuation(word)
    word.gsub(/[^[:alnum:]]/, "").downcase
  end

  def get_id_from_tweet_url
    return self.url.split("/").last
  end

  def load_tweet_json(u)
    tweet_id = get_id_from_tweet_url
    response = api_call("/1.1/statuses/show.json",URI.encode_www_form("id" => tweet_id),"GET",u)
    tweet = nil
    if response.code == '200' then
      tweet = JSON.parse(response.body)
      #print_tweet(tweet)
      #puts "Keywords in tweet: #{find_keywords(tweet["text"],excluded_words)}"
    end
    return tweet
  end

  def reply?(u)
    load_tweet_json(u)["in_reply_to_status_id_str"]
  end

  def followings(u)
    user_id = load_tweet_json(u)["user"]["id"]
    response = api_call()
  end

  def generate_context(u)

    return [reply_to(u)] if reply_to(u)

    match_score = Hash.new(0)

    templist = create_new_list(u,followings(u))
    tweets_to_scan = parse(templist)
    tweets_to_scan.each do |tweet|
      clean_tweet = strip_punctuation(tweet.text)
      find_keywords(u).each do |keyword|
        match_score[tweet] += 1 if clean_tweet.include?(keyword)
      end
    end
    return match_score.sort_by{|k,v| v}.take(2)#.map{|x| x[0]}
    # RETURNS [[tweet,score],[tweet,score]] UNCOMMENT TO JUST GET [tweet,tweet]
  end
end
