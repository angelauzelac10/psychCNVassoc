#' testing


getCNVgenes <- function(CNV_call, chromosome_number = NULL, reference_genome){
  # validation here

  # cnv_data <- readr::read_tsv(CNVfileName, col_names = FALSE)
  # colnames(cnv_data) <- c("chromosome_name", "start_position", "end_position", "type")
  # cnv_data$chromosome_name <- gsub("^chr", "", cnv_data$chromosome_name)
  # ^put this in tests, function should actually take dataframe
  if(!is.data.frame(CNV_call)){
    stop("First argument passed into function getCNVgenes() must be a dataframe.")
  }
  if(nrow(CNV_call) < 1){
    stop("There are no rows in the input CNV call dataframe.")
  }
  if(ncol(CNV_call) != 4){
    stop("The CNV call dataframe must have 4 columns.")
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

  if(!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
  }
  if(!missing(reference_genome) && !(reference_genome %in% c("GRCh37", "GRCh37"))){
    stop("Invalid reference genome. Please choose 'GRCh37' or 'GRCh38'.")
  }
  if(missing(reference_genome)){
    reference_genome <- "GRCh38"
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

  valid_input <- FALSE
  while(!valid_input){
    user_input <- readline("Would you like to see the distribution of genic and non-genic CNVs [Y/N]: ")
    if(user_input == "Y" || user_input == "y" || user_input == "N" || user_input == "n"){
      valid_input <- TRUE
    }else{
      cat("Invalid input. Please enter 'Y' or 'N'.\n")
    }
  }

  if(user_input == "Y" || user_input == "y"){
    plotCNVgeneImpact(count_genic_CNV, count_CNV)
  }

  return(gene_list)

}
