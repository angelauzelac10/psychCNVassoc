#' Get genes contained within CNVs
#'
#' A function that produces a list of genes that are contained within Copy Number
#' Variants(CNVs) from the provided table of human CNVs containing the chromosome number,
#' start position, end position, and type (duplication or deletion). User can also
#' specify the chromosome number for which they want results, and the reference
#' genome they want to use to find genes within the CNVs. Optionally, the function
#' outputs a graph showing the distribution of genic vs. non-genic CNVs.
#'
#' @param CNV_call A dataframe of CNVs containing 4 columns: the chromosome number
#'                on which it is found, the start position, the end position, and
#'                the type (either DUP or DEL).
#' @param chromosome_number A string value indicating the chromosome name
#'                          on which to identify genes contained within the CNVs.
#'                          Can be 1-22, 'X', or 'Y'.
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
#' # Using sample_CNV_call dataset available with package
#' # Get list of genes
#' result1 <- psychCNVassoc::getCNVgenes(CNV_call = sample_CNV_call)
#' gene_list1 <- result1$gene_list
#'
#' # Example 2
#' # Produces piechart plot
#' result2 <- psychCNVassoc::getCNVgenes(CNV_call = sample_CNV_call, show_piechart = TRUE)
#' gene_list2 <- result2$gene_list
#'
#' # Example 3
#' # Specifying chromosome number and reference genome
#' # Get list of genes for chromosome 22 using the GRCh37 reference genome
#' result3 <- psychCNVassoc::getCNVgenes(CNV_call = sample_CNV_call,
#'                           chromosome_number = "22",
#'                           reference_genome = "GRCh37")
#' gene_list3 <- result3$gene_list
#'
#' \dontrun{
#'
#' # Example 4
#' # Larger dataset, runs slower
#' result4 <- psychCNVassoc::getCNVgenes(CNV_call = large_CNV_call)
#' large_gene_list <- result4$gene_list
#'
#'}
#'
#' @references
#' Wickham H, François R, Henry L, Müller K, Vaughan D (2023). \emph{dplyr: A Grammar of Data Manipulation}. R package version 1.1.3, \href{https://CRAN.R-project.org/package=dplyr}{Link}.
#'
#' Durinck S, Spellman PT, Birney E, Huber W (2009). \emph{Mapping identifiers for the integration of genomic datasets with the R/Bioconductor package biomaRt}. Nature Protocols 4, 1184-1191 .
#'
#' BiomaRt Bioconductor R package documentation. (2023). Retrieved November 13, 2023, from \href{http://useast.ensembl.org/info/data/biomart/biomart_r_package.html}{Link}
#'
#' Gurbich T, Ilinsky V (2020). \emph{ClassifyCNV: A tool for clinical annotation of copy-number variants}. Scientific Reports, 10(1), Article 1. \href{https://doi.org/10.1038/s41598-020-76425-3}{Link}
#'
#' Du J (2022). \emph{CNVds: Analyzing Human CNVs Based on Dosage Sensitivity Scores}.
#' Unpublished. \href{https://github.com/jenydu/CNVds}{URL}.
#'
#' @export
#' @importFrom biomaRt useEnsembl
#' @importFrom biomaRt getBM
#' @import dplyr
#' @importFrom graphics legend
#' @importFrom graphics par
#' @importFrom graphics pie

getCNVgenes <- function(CNV_call, chromosome_number = NULL, reference_genome = "GRCh38", show_piechart = FALSE){

  # validate input CNV data
  validateCNVcall(CNV_call)

  # validate chromosome number and reference genome
  if (!missing(chromosome_number) && !is.null(chromosome_number) && !(chromosome_number %in% c(1:22, "X", "Y", "x", "y"))){
    stop("Specified chromosome number must be 1-22, X, or Y.")
  }
  if (!missing(reference_genome) && !is.null(reference_genome) && !(reference_genome %in% c("GRCh37", "GRCh38"))){
    stop("Invalid reference genome. Please choose 'GRCh37' or 'GRCh38'.")
  }
  if (!is.logical(show_piechart)){
    stop("Parameter show_piechart must be logical type (i.e. TRUE or FALSE).")
  }
  if (missing(reference_genome)){
    warning("Reference genome was not specified. GRCh38 was used.")
  }

  # filter by specified chromosome
  if(!is.null(chromosome_number) && !(chromosome_number %in% CNV_call$chromosome_name)){
    stop("Specified chromosome number does not exist in the dataset.")
  }
  if (!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
  }

  # assign unique ID to each CNV record
  CNV_call$ID <- 1:nrow(CNV_call)


  all_genes <- getEnsemblGenes(reference_genome = reference_genome)

  # filter by chromosome number if specified
  if (!is.null(chromosome_number)){
    all_genes <- all_genes[all_genes$chromosome_name == chromosome_number, ]
  }

  # Inner join the CNV data with the gene data by chromosome
  joined_data <- dplyr::inner_join(all_genes, CNV_call, by = "chromosome_name", relationship = "many-to-many")

  # Filter genes contained within CNVs
  genes_in_cnv <- dplyr::filter(joined_data, start_position.x >= start_position.y, end_position.x <= end_position.y)

  # retrieve distinct genes contained within CNVs
  gene_list <- unique(genes_in_cnv$hgnc_symbol)

  # get count of CNVs, for piechart graphic
  count_CNV <- nrow(CNV_call)
  # count number of CNVs that contain genes, for piechart graphic
  count_genic_CNV <- length(unique(genes_in_cnv$ID))

  # if specified, display the piechart
  if (show_piechart == TRUE){
    # plot
    plotCNVgeneImpact(count_genic_CNV, count_CNV)
  }

  result <- list(gene_list, count_genic_CNV, count_CNV)
  names(result) <- c("gene_list", "count_genic_CNV", "count_CNV")
  return(result)

}

# [END]
