#' Plot Number genic vs. non-genic CNVs
#'
#' Given the number of CNVs that contain 1 or more genes and the total number of CNVs
#' from the input table, plot a piechart demonstrating the distribution of CNVs that
#' contain 1 or more genes vs. CNVs that contain no genes. This function is called
#' from within getCNVgenes().
#'
#'
#' @param genic_CNV_count A positive integer indicating the number of CNVs
#'                        that contain 1 or more genes.
#' @param total_CNV_count A positive integer indicating the total number of
#'                        unique CNVs from the input table.
#'
#' @return Returns a piechart showing the number of CNVs that
#'          contain 1 or more genes vs. CNVs that contain no genes.
#'
#' @examples
#' # Example 1
#' # Using example_CNV_call dataset available with package
#' cnv_data <- example_CNV_call
#' colnames(cnv_data) <- c("chromosome_name", "start_position", "end_position", "type")
#' cnv_data$chromosome_name <- gsub("^chr", "", cnv_data$chromosome_name)
#'
#' # Get list of genes
#' gene_list <- getCNVgenes(CNV_call = cnv_data, show_piechart = TRUE)
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


plotCNVgeneImpact <- function(genic_CNV_count, total_CNV_count){

  if(genic_CNV_count < 1){
    stop("Could not produce piechart. There are no CNVs that contain genes.")
  }
  if(genic_CNV_count > total_CNV_count){
    stop("Could not produce piechart. There cannot be more CNVs that contain genes than there are CNVs in total.")
  }

  nongenic_CNV_count <- total_CNV_count - genic_CNV_count
  counts <- c(genic_CNV_count, nongenic_CNV_count)
  labels <- c(paste0(round(100 * genic_CNV_count/total_CNV_count, 1), "%"), paste0(round(100 * nongenic_CNV_count/total_CNV_count, 1), "%"))

  current_par <- par()
  par(mai = c(0.3, 0.3, 0.3, 0.3))
  pie(counts,
      labels = labels,
      col = c("lightblue", "orangered"),
      main = "Distribution of Genic vs Non-Genic CNVs",
      radius = 0.8)
  legend("topright",
         legend = c("CNVs containing 1 or more genes", "CNVs containing no genes"),
         fill = c("lightblue", "orangered"),
         cex = 0.6,
         bty = "n")
  par(current_par)

}
