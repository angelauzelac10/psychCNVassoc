#' Plot distribution of CNV sizes
#'
#' Given a CNV call data frame, plot the distribution of CNV sizes (# base pairs),
#' demonstrating the number of deletions (DEL) vs. number of duplications (DUP).
#' Optionally, plots the size distribution for a specified chromosome.
#'
#' @param CNV_call A dataframe of CNVs containing 4 columns: the chromosome number
#'                on which it is found, the start position, the end position, and
#'                the type (either DUP or DEL).
#' @param chromosome_number A positive integer indicating the chromosome number
#'                          for which to plot CNV size distribution.
#'
#' @return Returns a histogram of the CNV size distribution, separated by DEL and DUP.
#'
#' @examples
#' # Example 1
#' # Using example_CNV_call dataset available with package
#' cnv_data <- example_CNV_call
#' colnames(cnv_data) <- c("chromosome_name", "start_position", "end_position", "type")
#' cnv_data$chromosome_name <- gsub("^chr", "", cnv_data$chromosome_name)
#'
#' # Plot distribution of CNV sizes
#' plotCNVsize(CNV_call = cnv_data)
#'
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
#' @import ggplot2

plotCNVsize <- function(CNV_call, chromosome_number = NULL){

  # validate input CNV data
  validateCNVcall(CNV_call)

  # validate chromosome number
  if(!is.null(chromosome_number) & !(chromosome_number %in% c(1:22, "X", "Y"))){
    stop("Specified chromosome number must be 1-22, X, or Y.")
  }

  # filter by chromosome number and dynamically set histogram title
  hist_title <- "Distribution of CNV Sizes"
  if(!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
    hist_title <- paste0(hist_title, " (Chromosome ", chromosome_number, ")", sep = "")
  }

  # add attribute CNV size
  CNV_call$size <- CNV_call$end_position - CNV_call$start_position

  # plot CNV size distribution histogram
  cnv_size_hist <- ggplot2::ggplot() +
    geom_histogram(CNV_call[CNV_call$type == 'DEL', ],
                   mapping=aes(x = size, fill = "del"),
                   color = "black",
                   position = "stack") +
    scale_x_log10() +
    geom_histogram(CNV_call[CNV_call$type == 'DUP', ],
                   mapping = aes(x = size, fill = "dup"),
                   color = "black",
                   position = "stack") +
    theme_bw() +
    ggtitle(hist_title) +
    xlab("Size of CNV (log scale)") +
    ylab("Number of CNVs") +
    scale_fill_manual(name = NULL,
                      values = c('del' = "paleturquoise3",'dup' = "plum3"),
                      labels = c('Deletion','Duplication')) +
    theme(legend.position = 'right')

  cnv_size_hist
}
