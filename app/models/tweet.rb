class Tweet < ActiveRecord::Base

  def api_call(path,query,verb)
   
    consumer_key = OAuth::Consumer.new(ENV['TWITTER_REST_API1'],ENV['TWITTER_REST_API2'])

    ##REPLACE THIS WITH PROPER OAUTH IMPLEMENTATION

    @request_token = @consumer.get_request_token
    session[:request_token] = @request_token
    redirect_to @request_token.authorize_url
    access_token = OAuth::Token.new(
      "24588764-QYPEAaY98bD9udDa1xmirhiEjrUFN3xY5SXEgxQWn",
      "R1aY0sI5GGdapKnKLi68wsu0XujArJX0s2RzSOuctIYtR")

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

  def print_tweet(tweet)
    puts "Text of tweet: #{tweet["text"]}"
  end

  def find_keywords(tweet_text,excluded_words)
    output = []
    tweet_text.split.each do |word|
      clean_word = strip_punctuation(word)
      output << clean_word unless excluded_words.found?(clean_word)
    end
    output
  end

  def strip_punctuation(word)
    word.gsub(/[^[:alnum:]]/, "").downcase
  end

  excluded_words = Dictionary.new
  puts "Enter a tweet ID:"
  tweet_id = gets.chomp 
  response = api_call("/1.1/statuses/show.json",URI.encode_www_form("id" => tweet_id),"GET")
  tweet = nil
  if response.code == '200' then
    tweet = JSON.parse(response.body)
    print_tweet(tweet)
    puts "Keywords in tweet: #{find_keywords(tweet["text"],excluded_words)}"
  end
end
