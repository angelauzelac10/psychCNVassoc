#' Validate the input CNV call data frame
#'
#' A function that terminates execution and produces an error message when the
#' user enters a CNV call that does not meet format requirements.
#'
#'
#' @param CNV_call A data frame of CNVs containing 4 columns: the chromosome number
#'                on which it is found, the start position, the end position, and
#'                the type (either DUP or DEL).
#'
#' @return Returns an error message if the input parameter does not meet requirements.
#'
#' @examples
#' # Example 1
#' # Using example_CNV_call dataset available with package
#' # Without modifying the CNV call will produce an error
#' cnv_data <- example_CNV_call
#'
#' # Get list of genes
#' gene_list <- getCNVgenes(CNV_call = cnv_data)
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
#'
#' @export


validateCNVcall <- function(CNV_call){

  if(!is.data.frame(CNV_call)){
    stop("First argument passed must be a dataframe.")
  }
  if(nrow(CNV_call) < 1){
    stop("There are no rows in the input CNV call dataframe.")
  }
  if(ncol(CNV_call) != 4){
    stop("The CNV call dataframe must have 4 columns.")
  }
  if(!all(colnames(CNV_call) %in% c("chromosome_name", "start_position", "end_position", "type"))){
    stop("The CNV call dataframe must have columns named chromosome_name, start_position, end_position, and type in that order.")
  }
  if(!all(CNV_call$chromosome_name %in% c(1:22, "X", "Y"))){
    stop("Chromosome number must be 1-22, X, or Y.")
  }
  if(!all(is.numeric(CNV_call$start_position)) | !all(is.numeric(CNV_call$end_position))){
    stop("Start and end position must be integer values.")
  }
  if(!all(CNV_call$start_position < CNV_call$end_position)){
    stop("The start position must be before the end position for each CNV.")
  }
  if(!all(CNV_call$type %in% c("DEL", "DUP"))){
    stop("The value of the CNV type must be either 'DUP' or 'DEL'.")
  }

}
