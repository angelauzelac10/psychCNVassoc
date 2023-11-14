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
#' gene_list <- getCNVgenes(CNV_call = sample_CNV_call)
#'
#' # Example 2
#' # Causes an error
#' cnv_data_modified <- sample_CNV_call[, 1:3]
#'
#' gene_list2 <- getCNVgenes(CNV_call = cnv_data_modified)
#'
#'
#' # Example 3
#' # Produces piechart plot
#' gene_list3 <- getCNVgenes(CNV_call = sample_CNV_call, show_piechart = TRUE)
#'
#' # Example 4
#' # Specifying chromosome number and reference genome
#' # Get list of genes for chromosome 22 using the GRCh37 reference genome
#' gene_list4 <- getCNVgenes(CNV_call = sample_CNV_call, chromosome_number = "22", reference_genome = "GRCh37")
#'
#'
#' \dontrun{
#' # Example 5
#' # Larger dataset, runs slower
#' large_gene_list <- getCNVgenes(CNV_call = large_CNV_call)
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

getCNVgenes <- function(CNV_call, chromosome_number = NULL, reference_genome = "GRCh38", show_piechart = FALSE){

  # validate input CNV data
  validateCNVcall(CNV_call)

  # validate chromosome number and reference genome
  if (!missing(chromosome_number) && !(chromosome_number %in% c(1:22, "X", "Y"))){
    stop("Specified chromosome number must be 1-22, X, or Y.")
  }
  if (!missing(reference_genome) && !(reference_genome %in% c("GRCh37", "GRCh38"))){
    stop("Invalid reference genome. Please choose 'GRCh37' or 'GRCh38'.")
  }
  if (missing(reference_genome)){
    warning("Reference genome was not specified. GRCh38 was used.")
  }

  # filter by specified chromosome
  if (!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
  }

  # assign unique ID to each CNV record
  CNV_call$ID <- 1:nrow(CNV_call)
  # get count of CNVs, for piechart graphic
  count_CNV <- nrow(CNV_call)

  # connect to dataset GRCh37 or GRCh38
  if (reference_genome == "GRCh37"){
    ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", GRCh = 37)
  } else {
    ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
  }

  # get all genes from biomaRt, including the chromosome they are on, and the
  # start and end positions
  all_genes <- biomaRt::getBM(attributes=c('hgnc_symbol',
                                   'chromosome_name',
                                   'start_position',
                                   'end_position'), mart = ensembl)
  # clean the data and remove alternate chromosome names
  all_genes <- all_genes[all_genes$hgnc_symbol != "", ]
  all_genes <- all_genes[all_genes$chromosome_name %in% c(1:22, "X", "Y"), ]
  # free up space
  rm(ensembl)

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

  # count number of CNVs that contain genes, for piechart graphic
  count_genic_CNV <- length(unique(genes_in_cnv$ID))
  # if specified, display the piechart
  if (show_piechart == TRUE){
    plotCNVgeneImpact(count_genic_CNV, count_CNV)
  }

  return(gene_list)

}

# [END]
