# Retrieve all genes in the Ensembl database
#
# A function that retrieves the HGNC symbol, chromosome name, start position,
# and end position of every documented gene in the human genome. The genome build
# can be specified as 'GRCh37' or 'GRCh38'.
#
# Function is called from getCNVgenes().


getEnsemblGenes <- function(reference_genome = "GRCh38"){

  tryCatch(
    {
      # connect to dataset GRCh37 or GRCh38
      if (reference_genome == "GRCh37"){
        ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", GRCh = 37)
      } else {
        ensembl <- biomaRt::useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl")
      }

    },
    error=function(e) {
      message('Error: Ensembl site unresponsive. Try again later.')
      stop(e)
    },
    warning=function(w) {
      message('A Warning Occurred.')
      print(w)
      return(NA)
    }
  )


  if(exists("ensembl")){
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
  }

  return(all_genes)

}
