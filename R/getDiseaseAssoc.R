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
#'
#' # Get list of genes
#' gene_list <- getCNVgenes(CNV_call = sample_CNV_call)
#'
#' # Get gene-disease association
#' gene_disease_assoc <- getDiseaseAssoc(gene_list)
#'
#' # Example 2
#' # Produces error
#' gene_list_2 <- c(123, 234, 345)
#' gene_disease_assoc2 <- getDiseaseAssoc(gene_list2)
#'
#' \dontrun{
#' # Example 3
#' # Larger dataset, runs slower
#' # Get list of genes
#' large_gene_list <- getCNVgenes(CNV_call = sample_CNV_call)
#'
#' # Get gene-disease association
#' gene_disease_assoc3 <- getDiseaseAssoc(large_gene_list)
#'}
#'
#' @references
#'
#' Gutierrez-Sacristan A, Hernandez-Ferrer C, Gonzalez J, Furlong L (2023).
#' \emph{psygenet2r: psygenet2r - An R package for querying PsyGeNET and to perform
#' comorbidity studies in psychiatric disorders}. doi:10.18129/B9.bioc.psygenet2r
#' \href{https://doi.org/10.18129/B9.bioc.psygenet2r}{DOI}, R package version 1.33.5,
#' \href{https://bioconductor.org/packages/psygenet2r}{Link}.
#'
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

# [END]
