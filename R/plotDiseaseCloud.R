
plotDiseaseCloud <- function(disease_assoc_tbl){

  disease_assoc_tbl <- gene_disease_assoc

  library(tm)
  corpus <- tm::Corpus(tm::VectorSource(disease_assoc_tbl$DiseaseName))
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  # remove words like disorder, disorders

  tdm <- TermDocumentMatrix(corpus)
  word_freq <- rowSums(as.matrix(tdm))

  wordcloud::wordcloud(names(word_freq), word_freq)


}
