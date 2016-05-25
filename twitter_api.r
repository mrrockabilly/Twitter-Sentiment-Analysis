#http://davetang.org/muse/2013/04/06/using-the-r_twitter-package/

library("twitteR")
library("wordcloud")
library("tm")
library("textcat")
require(plyr)
require(stringr)
source("credentials.r")
source("score_sentiment.r")

pos.words = scan('positive-words.txt', what='character', comment.char=';')
neg.words = scan('negative-words.txt', what='character', comment.char=';')

#to get your consumerKey and consumerSecret see the twitteR documentation for instructions
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

sunArtist = read.table("rockabilly.txt", header = TRUE)
sunArtist=t(sunArtist)

allTweets = vector(length=0)

for (i in 1:length(sunArtist)) {
  current_tweets<- searchTwitter(mydata[[i]], n=15)
  allTweets = c(allTweets,current_tweets)
}

text = laply(allTweets, function(t) t$getText() )
scores = score.sentiment(text, pos.words, neg.words, .progress='text')

allTweets.df = ldply(allTweets, function(t) t$toDataFrame())
write.csv(allTweets.df, file = "twitter_data.csv")

#save text
r_stats_text <- sapply(r_stats, function(x) x$getText())
#create corpus
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))

#if you get the below error
#In mclapply(content(x), FUN, ...) :
#  all scheduled cores encountered errors in user code
#add mc.cores=1 into each function

#run this step if you get the error:
#(please break it!)' in 'utf8towcs'
r_stats_text_corpus <- tm_map(r_stats_text_corpus,
                              content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                              mc.cores=1
                              )
r_stats_text_corpus <- tm_map(r_stats_text_corpus, content_transformer(tolower), mc.cores=1)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation, mc.cores=1)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()), mc.cores=1)
wordcloud(r_stats_text_corpus)
