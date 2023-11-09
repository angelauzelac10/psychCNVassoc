#' Produce a wordcloud of most common diseases
#'
#' Given a data frame of gene-disease associations, produces a wordcloud showing the
#' most frequent disease or disorder names associated with a previously provided
#' list of genes. The size of the word represents its frequency in the gene-disease
#' association results.
#'
#' @param disease_assoc_tbl A data frame containing gene-disease associations. Must
#'                          contain a column called DiseaseName.
#'
#' @return Returns a wordcloud plot where the size of the word represents its
#'          frequency in gene-disease association results.
#'
#' @examples
#' # Example 1
#' # Using example_CNV_call dataset available with package
#' cnv_data <- example_CNV_call
#' colnames(cnv_data) <- c("chromosome_name", "start_position", "end_position", "type")
#' cnv_data$chromosome_name <- gsub("^chr", "", cnv_data$chromosome_name)
#'
#' # Get list of genes
#' gene_list <- getCNVgenes(CNV_call = cnv_data)
#'
#' # Get gene-disease association
#' gene_disease_assoc <- getDiseaseAssoc(gene_list)
#'
#' # Plot wordcloud of disease/disorder names
#' plotDiseaseCloud(gene_disease_assoc)
#'
#' \dontrun{
#' # Example 2
#' # Obtain an external sample RNAseq dataset
#' # Need to download package using install.packages("MBCluster.Seq")
#' library(MBCluster.Seq)
#' data("Count")
#' dim(Count)
#'
#' # Calculate information criteria value
#' InfCriteriaResults <- InfCriteriaCalculation(loglikelihood = -5080,
#'                                              nClusters = 2,
#'                                              dimensionality = ncol(Count),
#'                                              observations = nrow(Count),
#'                                              probability = c(0.5, 0.5))
#' InfCriteriaResults$BICresults
#'}
#' @references
#'Akaike, H. (1973). Information theory and an extension of the maximum
#'likelihood principle. In \emph{Second International Symposium on Information
#'Theory}, New York, NY, USA, pp. 267–281. Springer Verlag. \href{https://link.springer.com/chapter/10.1007/978-1-4612-1694-0_15}{Link}
#'
#'Biernacki, C., G. Celeux, and G. Govaert (2000). Assessing a mixture model for
#'clustering with the integrated classification likelihood. \emph{IEEE Transactions on Pattern
#'Analysis and Machine Intelligence} 22. \href{https://hal.inria.fr/inria-00073163/document}{Link}
#'
#'Schwarz, G. (1978). Estimating the dimension of a model. \emph{The Annals of Statistics} 6, 461–464.
#'\href{https://projecteuclid.org/euclid.aos/1176344136}{Link}.
#'
#'Yaqing, S. (2012). MBCluster.Seq: Model-Based Clustering for RNA-seq
#'Data. R package version 1.0.
#'\href{https://CRAN.R-project.org/package=MBCluster.Seq}{Link}.
#'
#' @export
#' @import tm
#' @import wordcloud2


plotDiseaseCloud <- function(disease_assoc_tbl){

  # validation here

  if(nrow(disease_assoc_tbl) < 1){
    stop("There are no rows in the input gene-disease association dataframe.")
  }
  if(!("DiseaseName" %in% colnames(disease_assoc_tbl))){
    stop("The input data frame must contain a column 'DiseaseName'.")
  }

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

  wordcloud2(word_freq_df)
  # when I make it smaller schizophrenia appears
  # need to figure out how to normalize these results

}
