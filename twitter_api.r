#http://davetang.org/muse/2013/04/06/using-the-r_twitter-package/

#install the necessary packages
install.packages("twitteR")
install.packages("wordcloud")
install.packages("tm")
 
library("twitteR")
library("wordcloud")
library("tm")
 
#necessary file for Windows
download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")
 
#to get your consumerKey and consumerSecret see the twitteR documentation for instructions
consumer_key <- 'your key'
consumer_secret <- 'your secret'
access_token <- 'your access token'
access_secret <- 'your access secret'
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)
 
#the cainfo parameter is necessary only on Windows
r_stats <- searchTwitter("#Rstats", n=1500, cainfo="cacert.pem")
#should get 1500
length(r_stats)
#[1] 1500
 
#save text
r_stats_text <- sapply(r_stats, function(x) x$getText())
 
#create corpus
r_stats_text_corpus <- Corpus(VectorSource(r_stats_text))
 
#clean up
r_stats_text_corpus <- tm_map(r_stats_text_corpus, content_transformer(tolower)) 
r_stats_text_corpus <- tm_map(r_stats_text_corpus, removePunctuation)
r_stats_text_corpus <- tm_map(r_stats_text_corpus, function(x)removeWords(x,stopwords()))
wordcloud(r_stats_text_corpus)
 
#alternative steps if you're running into problems 
r_stats<- searchTwitter("#Rstats", n=1500, cainfo="cacert.pem")
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
