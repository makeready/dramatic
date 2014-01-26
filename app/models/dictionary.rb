# -*- encoding : utf-8 -*-
class Dictionary < ActiveRecord::Base
  def self.found?(word)
    pronouns = ['all','another','any','anybody','anyone','anything','both','each','other','either','everybody','everyone','everything','few','he','her','hers','herself','him','himself','his','i','it','its','itself','many','me','mine','more','most','much','my','myself','neither','noone','nobody','none','nothing','one','other','others','our','ours','ourselves','several','she','some','somebody','someone','something','that','their','theirs','them','themselves','these','they','this','those','us','we','what','whatever','which','whichever','who','whoever','whom','whomever','whose','you','your','yours','yourself','yourselves']
    articles = ['the','a','an']
    prepositions = ['about','above','across','after','against','along','alongside','amid','amidst','among','amongst','apropos','around','as','aside','at','atop','barring','before','behind','below','beneath','beside','besides','between','beyond','but','by','circa','concerning','despite','down','during','except','for','from','given','in','including','inside','into','like','near','next','of','off','on','onto','opposite','out','over','past','per','plus','regarding','since','than','through','throughout','till','to','toward','unlike','until','up','upon','versus','vs','via','with','within','without']
    conjunctions = ['and','or','but','nor','so','for','yet','because','even','though','tho','if','once','since','so','that','unless','what','when','whenever','wherever','where','while']
    contractions = ['arent','cant','couldnt','didnt','doesnt','dont','hadnt','hasnt','havent','hed','hell','hes','id','ill','im','ive','isnt','its','lets','shed','shell','shes','shouldnt','thats','theres','theyd','theyll','theyre','theyve','wed','were','weve','werent','whatll','whatre','whats','whatve','wheres','whod','wholl','whore','whos','whove','wont','wouldnt','youd','youll','youre','youve']
    common_verbs = ['come','coming','came','think','thinking','thought','did','give','gave','do','done','doing','get','got','gotten','wait','go','waiting','going','gone','goes','really','is','am','are','was','were','be','being','try','trying','tried','tries','put','puts','feel','feels','felt','feeling','will','would','show','know','known','need','needed','showed','say','says','said','saying','see','sees','seen','be','can','use','used','could','using','should','see','saw','seeing','sort']
    common_adverbs = ['maybe', 'kinda', 'sorta', 'somewhat','anyway', 'back','then','only','not','now','also']
    common_adjectives = ['just','same','new','old','still']
    common_nouns = ['kind','lot','times','time']
    slang = ['hey','wtf','smh','smdh','lol','lmao','yall','bro','idk','rt']

    wordlist = pronouns + articles + prepositions + conjunctions + contractions + common_verbs + common_adverbs + common_adjectives + common_nouns + slang
    if wordlist.include?(word) || word == ''
      return true
    else
      return false
    end
  end
end
