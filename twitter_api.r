#http://davetang.org/muse/2013/04/06/using-the-r_twitter-package/

library("twitteR")
library("wordcloud")
library("tm")
source("credentials.r")

#to get your consumerKey and consumerSecret see the twitteR documentation for instructions
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)
 
sunArtist = read.table("rockabilly.txt", header = TRUE)
sunArtist=t(sunArtist)

for (i in 1:length(sunArtist)) {
  tweets<- searchTwitter(mydata[[1]], n=1500)
}

r_stats<- searchTwitter(mydata[[1]], n=1500)
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

