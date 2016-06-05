library("twitteR")
library("wordcloud")
library("tm")
library("textcat")
require(plyr)
require(stringr)
source("credentials.r")
source("score_sentiment.r")
source("score_language.R")

pos.words = scan('positive-words.txt', what='character', comment.char=';')
neg.words = scan('negative-words.txt', what='character', comment.char=';')

print("Setting up Twitter connection.")
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

print("Reading in search phrases.")
searchTerms = read.table("queries.txt", header = TRUE)
searchTerms=t(searchTerms)

allTweets = vector(length=0)

print("Searching Twitter")
for (i in 1:length(searchTerms)) {
  current_tweets<- searchTwitter(searchTerms[[i]], n=5)
  allTweets = c(allTweets,current_tweets)
}

print("Performing sentiment analysis.")
text = laply(allTweets, function(t) t$getText() )
sentiment_scores = score.sentiment(text, pos.words, neg.words, .progress='text')
allTweets.df$sentScore <- sentiment_scores$score

print("Performing language analysis.")
language_scores = score.language(text, .progress='text')
allTweets.df$langScore <- language_scores$score

print("Saving data to CSV.")
allTweets.df = ldply(allTweets, function(t) t$toDataFrame())
write.csv(allTweets.df, file = "twitter_data.csv")

