library(psychCNVassoc)


context("Checking for invalid user input for plotGeneCloud")
test_that("plotGeneCloud error upon invalid user input", {

  CNV_call = sample_CNV_call

  result <- getCNVgenes(CNV_call = CNV_call)
  gene_list <- result$gene_list

  gene_disease_assoc <- getDiseaseAssoc(gene_list)

  error_tbl <- gene_disease_assoc
  names(error_tbl)[names(error_tbl) == "Gene_Symbol"] <- "gene_names"

  empty_df <- data.frame()

  # gene-disease association is not a dataframe
  expect_error(plotGeneCloud(
    disease_assoc_tbl = "A"))

  # gene-disease association is not a dataframe
  expect_error(plotGeneCloud(
    disease_assoc_tbl = gene_disease_assoc$Score))

  # gene-disease association table does not contain Gene_Symbol column
  expect_error(plotGeneCloud(
    disease_assoc_tbl = error_tbl))

  # gene-disease association table must contain some rows
  expect_error(plotGeneCloud(
    disease_assoc_tbl = empty_df))

})


# [END]
