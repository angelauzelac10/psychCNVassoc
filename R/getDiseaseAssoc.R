#' testing getDiseaseAssoc


getDiseaseAssoc <- function(gene_list){

  gene_list <- test_gene_list

  psy_gene_disease <- psygenet2r::psygenetGene(gene = gene_list,
                                               database = "ALL",
                                               evidenceIndex = c(">", 0),
                                               verbose = FALSE,
                                               warnings = FALSE)

  psy_gene_disease_tbl <- psy_gene_disease@qresult

  gene_diff <- gene_list[!(unique(gene_list) %in% unique(psy_gene_disease_tbl$"c1.Gene_Symbol"))]

  if(length(gene_diff) > 0){
    warning_message <- paste(length(gene_diff), "out of", length(gene_list), "of the given genes are not in PsyGeNET. Both psycur15 and psycur16 databases were queried.")
    warning(warning_message)
  }

  return(psy_gene_disease_tbl)

}
