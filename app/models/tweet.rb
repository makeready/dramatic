# -*- encoding : utf-8 -*-
class Tweet < ActiveRecord::Base

  belongs_to :user

  def api_call(path,query,verb)
   
    consumer_key = OAuth::Consumer.new(ENV['TWITTER_REST_API1'],ENV['TWITTER_REST_API2'])

    access_token = OAuth::Token.new(self.user.token,self.user.secret)
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
    puts "Api call: #{address}"

    request.oauth! http, consumer_key, access_token
    http.start
    return http.request request

  end

  def find_keywords(text)
    output = []
    text.split.each do |word|
      clean_word = strip_punctuation(word)
      output << clean_word unless Dictionary.found?(clean_word)
    end
    output
  end

  def strip_punctuation(word)
    word = word.gsub(/'s/, "")
    word.gsub(/[^[\s]|^[:alnum:]]/, "").downcase
  end

  def tweet_id
    return self.url.split("/").last
  end

  def load_tweet_json
    response = api_call("/1.1/statuses/show.json",[["id", tweet_id]],"GET")
    tweet = nil
    if response.code == '200' then
      tweet = JSON.parse(response.body)
    end
    return tweet
  end

  def find_followings(poster_id)
    response = api_call("/1.1/friends/ids.json",[["user_id", poster_id],["stringify_ids", true]],"GET")
    return JSON.parse(response.body)["ids"]
  end

  def create_new_list(followings)
    list_id = populate_empty_list(create_empty_list, followings)
    return list_id
  end

  def create_empty_list
    timestamp = Time.now.to_i.to_s
    response = api_call("/1.1/lists/create.json",[["name", "context#{timestamp}"]],"POST")
    return JSON.parse(response.body)["id_str"]
  end

  def populate_empty_list(list_id, followings)
    followings.sort!
    threads = []
    divisor = 40
    numcalls = round_up(followings.length,divisor) / divisor
    numcalls = 13 if numcalls > 13
    numcalls.times do |call|
      threads << Thread.new do 
        users = followings[(call)*divisor..((call+1)*divisor)-1].join(',')
        api_call("/1.1/lists/members/create_all.json",[["list_id", list_id],["user_id",users]],"POST")
      end
    end
    threads.each { |t| t.join }
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

  def parse_list(list_id,listsize)
    max_id = tweet_id
    response = api_call("/1.1/lists/statuses.json",[["list_id", list_id],["max_id", max_id],['count',listsize]],"GET")
    return JSON.parse(response.body)
  end

  def delete_list(list_id)
    response = api_call("/1.1/lists/destroy.json",[["list_id", list_id]],"POST")
    return JSON.parse(response.body)
  end

  def take_top_n_matches(match_score_hash, numtweets)
    sorted_match_score = match_score_hash.sort_by{|k,v| v}.reverse

    if sorted_match_score.length > 2
      sorted_match_score = tiebreak(sorted_match_score) if sorted_match_score[1][1] == sorted_match_score[2][1]
    end

    sorted_match_score.take(numtweets)
  end

  def tiebreak(sorted_match_score)
    score_to_break = sorted_match_score[1][1]
    max_score = 0
    second_highest_score = 0

    sorted_match_score.each do |tweet|
      favs = tweet[0]["favorite_count"]
      rts = tweet[0]["retweet_count"]
      tweet << favs + rts #SECRET SAUUUUUCE
      if favs + rts > max_score
        second_highest_score = max_score
        max_score = favs + rts 
      end
    end

    if sorted_match_score[0][1] == score_to_break #if the top 2 tweets were tied, we need to take the top two tiebroken
      tiebroken_match_score = sorted_match_score.delete_if {|tweet| tweet[1] == score_to_break && tweet[2] < second_highest_score}
    else # we just need to take the top tiebroken
      tiebroken_match_score = sorted_match_score.delete_if {|tweet| tweet[1] == score_to_break && tweet[2] < max_score}
    end

    tiebroken_match_score

  end

  def highlight_keyword(tweet_text,keywords)
    tweet_text_array = tweet_text.split
    sentence = []
    tweet_text_array.each do |word|
      no_punc_word = word.gsub(/[^a-zA-Z0-9]/,'')
      if keywords.include?(no_punc_word.downcase)
        word.gsub!( no_punc_word ,"<span class='highlight'>#{no_punc_word}</span>")
      end
      sentence << word
    end
    sentence.join(" ")
  end

  def generate_context(numtweets,listsize)
    tweet_json = load_tweet_json

    return tweet_json["in_reply_to_status_id_str"] if tweet_json["in_reply_to_status_id_str"]

    match_score = Hash.new(0)

    list_id = create_new_list(find_followings(tweet_json["user"]["id_str"]))
    keywords = find_keywords(tweet_json["text"])
    parsed_list = parse_list(list_id,listsize)
    puts "Total tweets scanned: #{parsed_list.length}"
    if parsed_list != []
      parsed_list.each do |tweet|
        link_score = 0
        prev_match = false
        clean_tweet = find_keywords(tweet["text"])
        clean_tweet.each do |clean_tweet_keyword|
          if prev_match == true 
            link_score += 1
            puts 'link_score + 1'
          elsif prev_match == false && link_score > 1
            puts 'link score:: ' + link_score.to_s
            match_score[tweet] += link_score
            link_score = 0
          end
          prev_match = false
          keywords.each do |keyword|        
            if clean_tweet_keyword == keyword
              match_score[tweet] += 1
              prev_match = true

              puts "Added 1 to match score, #{clean_tweet} included #{keyword}."
              puts "New match score is #{match_score[tweet]}."
            end
          end
        end
        if link_score > 1
          puts 'link score:: ' + link_score.to_s
          match_score[tweet] += link_score
          link_score = 0
        end
      end
    end

    delete_list(list_id)

    found_tweets = take_top_n_matches(match_score,numtweets)

    found_tweets.each do |tweet|
      if tweet[0]['retweeted_status']
        clean_tweet = tweet[0]["retweeted_status"]["text"]
        tweet[0]["retweeted_status"]["text"] = highlight_keyword(clean_tweet,keywords)
      else
        clean_tweet = tweet[0]["text"]
        tweet[0]["text"] = highlight_keyword(clean_tweet,keywords)
      end
    end

    #found_tweets.each {|tweet| puts "#{tweet[0]["text"]} has a score of #{tweet[1]}." }
    
    data = []
    data[0] = tweet_json
    data[1] = found_tweets
    data[2] = keywords


    # DATA STRUCTURE: [{original_tweet},[[{found_tweet1}, match_score, tiebreak_score],[{found_tweet2}, match_score, tiebreak_score]],["kw1","kw2","kw3"]]

    data

  end

end
