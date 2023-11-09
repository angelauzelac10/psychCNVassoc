#' Get genes contained within CNVs
#'
#' A function that produces a list of genes that are contained within Copy Number
#' Variants(CNVs) from the provided table of CNVs containing the chromosome number,
#' start position, end position, and type (duplication or deletion). User can also
#' specify the chromosome number for which they want results, and the reference
#' genome they want to use to find genes within the CNVs. Optionally, the function
#' outputs a graph showing the distribution of genic vs. non-genic CNVs.
#'
#' @param CNV_call A dataframe of CNVs containing 4 columns: the chromosome number
#'                on which it is found, the start position, the end position, and
#'                the type (either DUP or DEL).
#' @param chromosome_number A positive integer indicating the chromosome number
#'                          on which to identify genes contained within the CNVs.
#' @param reference_genome A string value, either 'GRCh37' or 'GRCh38', indicating
#'                          the genome to compare. Default is 'GRCh38'.
#' @param show_piechart A boolean value indicating whether to show the distribution
#'                      of genic vs. non-genic CNVs.
#'
#' @return Returns a character vector of genes that are contained within
#'          the input list of CNVs.
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
#' @importFrom biomaRt useEnsembl
#' @importFrom biomaRt getBM
#' @import dplyr

getCNVgenes <- function(CNV_call, chromosome_number = NULL, reference_genome = "GRCh38", show_piechart = FALSE){

  validateCNVcall(CNV_call)

  if(!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
  }
  if(!missing(reference_genome) && !(reference_genome %in% c("GRCh37", "GRCh38"))){
    stop("Invalid reference genome. Please choose 'GRCh37' or 'GRCh38'.")
  }
  if(missing(reference_genome)){
    warning("Reference genome was not specified. GRCh38 was used.")
  }

  CNV_call$ID <- 1:nrow(CNV_call)
  count_CNV <- nrow(CNV_call)


  if(reference_genome == "GRCh37"){
    ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", GRCh = 37)
  } else{
    ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
  }


  all_genes <- biomaRt::getBM(attributes=c('hgnc_symbol',
                                   'chromosome_name',
                                   'start_position',
                                   'end_position'), mart = ensembl)
  all_genes <- all_genes[all_genes$hgnc_symbol != "", ]
  all_genes <- all_genes[all_genes$chromosome_name %in% c(1:22, "X", "Y"), ]
  #there are still duplicates of genes, think about why this may or may not be a problem

  #filter this so that if out of the multiple entries for the same gene has one entry
  #that has an actual chromosome number, use that number

  if(!is.null(chromosome_number)){
    all_genes <- all_genes[all_genes$chromosome_name == chromosome_number, ]
  }

  # Inner join the data frames
  joined_data <- dplyr::inner_join(all_genes, CNV_call, by = "chromosome_name", relationship = "many-to-many")

  # Filter genes contained within CNVs
  genes_in_cnv <- dplyr::filter(joined_data, start_position.x >= start_position.y, end_position.x <= end_position.y)

  count_genic_CNV <- length(unique(genes_in_cnv$ID))
  gene_list <- unique(genes_in_cnv$hgnc_symbol)

  if(show_piechart == TRUE){
    plotCNVgeneImpact(count_genic_CNV, count_CNV)
  }

  return(gene_list)

}
