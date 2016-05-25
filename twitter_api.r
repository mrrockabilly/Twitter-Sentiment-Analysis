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
