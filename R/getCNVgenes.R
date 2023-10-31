#' testing

getCNVgenes(CNVfile){
  # validation here

  cnv_data <- cleanCNV(CNVfile)
  #the following data is from ClassifyCNV package
  # put the following into the function above
  cnv_data<- readr::read_tsv("1000Genomes.hg19.bed", col_names = FALSE)
  colnames(cnv_data) <- c("chromosome_name", "start_position", "end_position", "type")
  cnv_data$chromosome_name <- gsub("^chr", "", cnv_data$chromosome_name)
  cnv_data_chr1 <- cnv_data[cnv_data$chromosome_name == 1, ]

  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  BiocManager::install("biomaRt")


  ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")

  all_genes <- biomaRt::getBM(attributes=c('hgnc_symbol',
                                   'chromosome_name',
                                   'start_position',
                                   'end_position'), mart = ensembl)

  #filter this so that if out of the multiple entries for the same gene has one entry
  #that has an actual chromosome number, use that number

  # Inner join the data frames
  joined_data <- dplyr::inner_join(genes_chr1, cnv_data_chr1, by = "chromosome_name", relationship = "many-to-many")

  # Filter genes contained within CNVs
  filtered_genes <- dplyr::filter(joined_data, start_position.x >= start_position.y, end_position.x <= end_position.y)
  filtered_genes <- filtered_genes[filtered_genes$hgnc_symbol != '', ]

  gene_list <- unique(filtered_genes$hgnc_symbol)



}
