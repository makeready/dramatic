class Tweet < ActiveRecord::Base
  require 'rubygems'
  require 'oauth'
  require 'json'
  require 'debugger'
  require 'apikey'

  def api_call(query,verb)
   
    consumer_key = OAuth::Consumer.new(ENV['TWITTER_REST_API1'],ENV['TWITTER_REST_API2'])

    ##REPLACE THIS WITH PROPER OAUTH IMPLEMENTATION
    access_token = OAuth::Token.new(
      "24588764-QYPEAaY98bD9udDa1xmirhiEjrUFN3xY5SXEgxQWn",
      "R1aY0sI5GGdapKnKLi68wsu0XujArJX0s2RzSOuctIYtR")

    baseurl = "https://api.twitter.com"
    path    = "/1.1/statuses/show.json"
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

  class Dictionary
    def initialize
      @pronouns = ['all','another','any','anybody','anyone','anything','both','each','other','either','everybody','everyone','everything','few','he','her','hers','herself','him','himself','his','i','it','its','itself','many','me','mine','more','most','much','my','myself','neither','noone','nobody','none','nothing','one','other','others','our','ours','ourselves','several','she','some','somebody','someone','something','that','their','theirs','them','themselves','these','they','this','those','us','we','what','whatever','which','whichever','who','whoever','whom','whomever','whose','you','your','yours','yourself','yourselves']

      @articles = ['the','a','an']

      @prepositions = ['about','above','across','after','against','along','alongside','amid','amidst','among','amongst','apropos','around','as','aside','at','atop','barring','before','behind','below','beneath','beside','besides','between','beyond','but','by','circa','concerning','despite','down','during','except','for','from','given','in','including','inside','into','like','near','next','of','off','on','onto','opposite','out','over','past','per','plus','regarding','since','than','through','throughout','till','to','toward','unlike','until','up','upon','versus','vs','via','with','within','without']

      @conjunctions = ['and','or','but','nor','so','for','yet','because','even','though','tho','if','once','since','so','that','unless','what','when','whenever','wherever','where','while']

      @contractions = ['arent','cant','couldnt','didnt','doesnt','dont','hadnt','hasnt','havent','hed','hell','hes','id','ill','im','ive','isnt','its','lets','shed','shell','shes','shouldnt','thats','theres','theyd','theyll','theyre','theyve','wed','were','weve','werent','whatll','whatre','whats','whatve','wheres','whod','wholl','whore','whos','whove','wont','wouldnt','youd','youll','youre','youve']

      @common_verbs = ['really','is','am','are','was','were','try','trying','tried','tries','put','puts','feel','feels','felt','feeling','will','would','show','know','known','need','needed','showed','say','says','said','saying','see','sees','seen','be','can','use','used','could','using','should','see','saw','seeing','sort']

      @common_adverbs = ['maybe', 'kinda', 'sorta', 'somewhat','anyway', 'back','then','only','not']

      @common_adjectives = ['just','same','new','old','still']

      @common_nouns = ['kind','lot']

      @slang = ['wtf','smh','smdh','lol','lmao','yall','bro','idk']

      @wordlist = @pronouns + @articles + @prepositions + @conjunctions + @contractions + @common_verbs + @common_adverbs + @common_adjectives + @common_nouns + @slang
    end

    def found?(word)
      if @wordlist.include?(word) || word == ''
        return true
      else
        return false
      end
    end
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
  response = api_call(URI.encode_www_form("id" => tweet_id),"GET")
  tweet = nil
  if response.code == '200' then
    tweet = JSON.parse(response.body)
    print_tweet(tweet)
    puts "Keywords in tweet: #{find_keywords(tweet["text"],excluded_words)}"
  end
end
