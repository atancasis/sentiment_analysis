#!/usr/bin/Rscript

#import libraries to work with
library(stringr)

#load up word polarity list and format it
afinn_list <- read.delim(file='R/AFINN/AFINN-111.txt', header=FALSE, stringsAsFactors=FALSE)
names(afinn_list) <- c('word', 'score')
afinn_list$word <- tolower(afinn_list$word)

#categorize words as very negative to very positive and add some movie-specific words
vNegTerms <- afinn_list$word[afinn_list$score==-5 | afinn_list$score==-4]
negTerms <- c(afinn_list$word[afinn_list$score==-3 | afinn_list$score==-2 | afinn_list$score==-1], "second-rate", "moronic", "third-rate", "flawed", "juvenile", "boring", "distasteful", "ordinary", "disgusting", "senseless", "static", "brutal", "confused", "disappointing", "bloody", "silly", "tired", "predictable", "stupid", "uninteresting", "trite", "uneven", "outdated", "dreadful", "bland")
posTerms <- c(afinn_list$word[afinn_list$score==3 | afinn_list$score==2 | afinn_list$score==1], "first-rate", "insightful", "clever", "charming", "comical", "charismatic", "enjoyable", "absorbing", "sensitive", "intriguing", "powerful", "pleasant", "surprising", "thought-provoking", "imaginative", "unpretentious")
vPosTerms <- c(afinn_list$word[afinn_list$score==5 | afinn_list$score==4], "uproarious", "riveting", "fascinating", "dazzling", "legendary")

#function to calculate number of words in each category within a sentence
sentimentScore <- function(sentence){
  #remove unnecessary characters and split up by word
  sentence <- gsub('[[:punct:]]', '', sentence)
  sentence <- gsub('[[:cntrl:]]', '', sentence)
  sentence <- gsub('\\d+', '', sentence)
  sentence <- tolower(sentence)
  wordList <- str_split(sentence, '\\s+')
  words <- unlist(wordList)
  #build vector with matches between sentence and each category
  vPosMatches <- match(words, vPosTerms)
  posMatches <- match(words, posTerms)
  vNegMatches <- match(words, vNegTerms)
  negMatches <- match(words, negTerms)
  #sum up number of words in each category
  vPosMatches <- sum(!is.na(vPosMatches))
  posMatches <- sum(!is.na(posMatches))
  vNegMatches <- sum(!is.na(vNegMatches))
  negMatches <- sum(!is.na(negMatches))
  score <- c(vNegMatches, negMatches, posMatches, vPosMatches)
  return(score)
}

f <- file("stdin")
open(f)
while(length(line <- readLines(f, n=1)) > 0){
  print(sentimentScore(line))
}
