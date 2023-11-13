#' Get Psychiatric diseases associated with CNVs
#'
#' A function that retrieves gene-disease associations from the PsyGeNet database,
#' based on a provided list of genes (HGNC symbols) encompassed by Copy Number Variants (CNVs).
#'
#' @param gene_list A character vector containing genes as HGNC symbols (e.g. ‘COMT’, ‘DRD3’, ‘HTR1A’).
#'
#' @return Returns a data frame containing genes and their known association
#'          with psychiatric diseases.
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
#' # Example 2
#' # Produces error
#' gene_list_2 <- c(123, 234, 345)
#' gene_disease_assoc <- getDiseaseAssoc(gene_list2)
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
#' @import psygenet2r

getDiseaseAssoc <- function(gene_list){

  # validate input list of genes
  if(!is.vector(gene_list) | !(typeof(gene_list) == "character")){
    stop("The argument passed into function getDiseaseAssoc() must be a character vector.")
  }

  # get gene-disease associations
  psy_gene_disease <- psygenet2r::psygenetGene(gene = gene_list,
                                               database = "ALL",
                                               evidenceIndex = c(">", 0),
                                               verbose = FALSE,
                                               warnings = FALSE)
  psy_gene_disease_tbl <- psy_gene_disease@qresult
  # edit column names
  current_colnames <- colnames(psy_gene_disease_tbl)
  new_colnames <- substr(current_colnames, 4, nchar(current_colnames))
  colnames(psy_gene_disease_tbl) <- new_colnames

  # verify number of genes not found in the PsyGeNet database and display warning message
  gene_diff <- gene_list[!(unique(gene_list) %in% unique(psy_gene_disease_tbl$Gene_Symbol))]
  if(length(gene_diff) > 0){
    warning_message <- paste(length(gene_diff), "out of", length(gene_list), "of the given genes are not in PsyGeNET. Both psycur15 and psycur16 databases were queried.")
    warning(warning_message)
  }
  if(ncol(psy_gene_disease_tbl) < 1){
    warning("No gene-disease associations were found for the provided list of genes.")
  }

  return(psy_gene_disease_tbl)

}
