score.language = function(sentences, .progress='none')
{
  # we got a vector of sentences. plyr will handle a list

  scores = laply(sentences, function(sentence) {
    sentence = iconv(sentence, "UTF8", "ASCII", sub="")
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # and convert to lower case:
    sentence = tolower(sentence)
 
    score = textcat(sentence)

    return(score)
  }, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}
