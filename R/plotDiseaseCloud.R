#' Produce a wordcloud of the most common diseases
#'
#' Given a data frame of gene-disease associations, produces a wordcloud showing the
#' most frequent disease names associated with a list of genes found in Copy Number Variants (CNVs).
#' The size of the word represents its frequency in the gene-disease
#' association results.
#'
#' @param disease_assoc_tbl A data frame containing gene-disease associations. Must
#'                          contain a column called DiseaseName.
#'
#' @return Returns a wordcloud plot where the size of the word represents its
#'          frequency in a gene-disease association table.
#'
#' @examples
#' # Example 1
#' # Using example_CNV_call dataset available with package
#' # Get list of genes
#' gene_list <- getCNVgenes(CNV_call = sample_CNV_call)
#'
#' # Get gene-disease association
#' gene_disease_assoc <- getDiseaseAssoc(gene_list)
#'
#' # Plot wordcloud of disease/disorder names
#' plotDiseaseCloud(gene_disease_assoc)
#'
#' # Example 2
#' # Produces error
#' plotDiseaseCloud(c("ABC", "DEF", "GHI"))
#'
#' \dontrun{
#' # Example 3
#' # Larger dataset, runs slower
#' # Get list of genes
#' large_gene_list <- getCNVgenes(CNV_call = sample_CNV_call)
#'
#' # Get gene-disease association
#' gene_disease_assoc2 <- getDiseaseAssoc(large_gene_list)
#'
#' # Plot wordcloud of disease/disorder names
#' plotDiseaseCloud(gene_disease_assoc2)
#'}
#'
#' @references
#'
#' Feinerer I, Hornik K (2023). \emph{tm: Text Mining Package}.
#' R package version 0.7-11, \href{https://CRAN.R-project.org/package=tm}{Link}.
#'
#' Lang D, Chien G (2018). \emph{wordcloud2: Create Word Cloud by 'htmlwidget'}.
#' R package version 0.2.1, \href{https://CRAN.R-project.org/package=wordcloud2}{Link}.
#'
#' Rul CVd (2019). \emph{How to Generate Word Clouds in R}. Medium.
#' \href{https://towardsdatascience.com/create-a-word-cloud-with-r-bde3e7422e8a}{Link}.
#'
#' Girdher H (2023). \emph{TDM (Term Document Matrix) and DTM (Document Term Matrix)}. Analytics Vidhya.
#' \href{https://medium.com/analytics-vidhya/tdm-term-document-matrix-and-dtm-document-term-matrix-8b07c58957e2}{Link}.
#'
#' @export
#' @import tm
#' @import wordcloud2


plotDiseaseCloud <- function(disease_assoc_tbl){

  # validate input table
  if(!is.data.frame(disease_assoc_tbl)){
    stop("The input to plotDiseaseCloud() must be a dataframe.")
  }
  if(nrow(disease_assoc_tbl) < 1){
    stop("There are no rows in the input gene-disease association dataframe.")
  }
  if(!("DiseaseName" %in% colnames(disease_assoc_tbl))){
    stop("The input data frame must contain a column 'DiseaseName'.")
  }

  # create a collection of text documents from the disease name column
  corpus <- tm::Corpus(VectorSource(disease_assoc_tbl$DiseaseName))
  # transform the text
  suppressWarnings({
    corpus <- tm::tm_map(corpus, content_transformer(tolower))
    corpus <- tm::tm_map(corpus, removePunctuation)
    corpus <- tm::tm_map(corpus, removeNumbers)
    corpus <- tm::tm_map(corpus, removeWords, stopwords("english"))
    corpus <- tm::tm_map(corpus, stripWhitespace)
    corpus <- tm::tm_map(corpus, removeWords, c("disorder", "disorders", "related", "state", "use", "related", "major", "symptom", "symptoms"))
    corpus <- tm::tm_map(corpus,
                     replace_word <- function(x) {
                                        x <- gsub("abuse", "substance-abuse" , x)
                                        return(x)
                                      }
                     )
  })

  # create Term-Document matrix: each row represents a term and each column represents
  # a document (disease name), cell values indicate the frequency of the term in the document
  tdm <- tm::TermDocumentMatrix(corpus)

  # convert to word frequency dataframe: first column represents words,
  # second column represents their frequency
  word_freq <- rowSums(as.matrix(tdm))
  word_freq_df <- data.frame(word = names(word_freq), freq = word_freq)

  # plot wordcloud
  wordcloud2::wordcloud2(word_freq_df)

}
