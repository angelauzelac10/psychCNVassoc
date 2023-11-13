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

  corpus <- tm::Corpus(VectorSource(disease_assoc_tbl$DiseaseName))
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

  tdm <- tm::TermDocumentMatrix(corpus)
  word_freq <- rowSums(as.matrix(tdm))
  word_freq_df <- data.frame(word = names(word_freq), freq = word_freq)

  wordcloud2::wordcloud2(word_freq_df)
  # when I make it smaller schizophrenia appears
  # need to figure out how to normalize these results

}
