library(psychCNVassoc)


context("Checking for invalid user input for plotDiseaseCloud")
test_that("plotDiseaseCloud error upon invalid user input", {

  CNV_call = sample_CNV_call

  gene_list <- getCNVgenes(CNV_call = CNV_call)

  gene_disease_assoc <- getDiseaseAssoc(gene_list)

  error_tbl <- gene_disease_assoc
  names(error_tbl)[names(error_tbl) == "DiseaseName"] <- "diseases"

  # gene-disease associtaion is not a dataframe
  expect_error(plotDiseaseCloud(
    disease_assoc_tbl = "A"))

  # gene-disease associtaion is not a dataframe
  expect_error(plotDiseaseCloud(
    disease_assoc_tbl = gene_disease_assoc$Gene_Symbol))

  # gene-disease associtaion table does not contain DiseaseName column
  expect_error(plotDiseaseCloud(
    disease_assoc_tbl = error_tbl))

  # remove_most_freq is a character
  expect_error(plotDiseaseCloud(
    disease_assoc_tbl = gene_disease_assoc,
    remove_most_freq = "2"))

  # cannot remove more words than there are in the frequency table
  expect_error(plotDiseaseCloud(
    disease_assoc_tbl = gene_disease_assoc,
    remove_most_freq = 25))


})


# [END]
