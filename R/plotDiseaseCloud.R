
plotDiseaseCloud <- function(disease_assoc_tbl){

  library(tm)
  corpus <- Corpus(VectorSource(disease_assoc_tbl$DiseaseName))
  suppressWarnings({
    corpus <- tm_map(corpus, content_transformer(tolower))
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    corpus <- tm_map(corpus, stripWhitespace)
    corpus <- tm_map(corpus, removeWords, c("disorder", "disorders", "related", "state", "use", "related", "major", "symptom", "symptoms"))
    corpus <- tm_map(corpus,
                     replace_word <- function(x) {
                                        x <- gsub("abuse", "substance-abuse" , x)
                                        return(x)
                                      }
                     )
  })

  tdm <- TermDocumentMatrix(corpus)
  word_freq <- rowSums(as.matrix(tdm))
  word_freq_df <- data.frame(word = names(word_freq), freq = word_freq)

  wordcloud2::wordcloud2(word_freq_df)
  # when I make it smaller schizophrenia appears
  # need to figure out how to normalize these results

}
