library(psychCNVassoc)

test_that("get diseases associated with provided genes", {

  CNV_call = sample_CNV_call

  gene_list <- getCNVgenes(CNV_call = CNV_call)

  gene_disease_assoc <- getDiseaseAssoc(gene_list)

  verify_colnames <- c("Gene_Symbol", "Gene_Id", "Gene_Description", "Disease_Id",
                       "Disease_code", "DiseaseName", "PsychiatricDisorder", "Score",
                       "Number_of_Abstracts", "Number_of_AbstractsValidated")

  expect_type(gene_disease_assoc, "list")
  expect_s3_class(gene_disease_assoc, "data.frame")
  expect_equal(nrow(gene_disease_assoc), 79)
  expect_equal(colnames(gene_disease_assoc), verify_colnames)
})



context("Checking for invalid user input for getDiseaseAssoc")
test_that("getDiseaseAssoc error upon invalid user input", {


  # must pass a character vector
  expect_error(gene_disease_assoc <- getDiseaseAssoc(
    gene_list = c(1, 2, 3, 4)
    ))

  # must pass a character vector
  expect_error(gene_disease_assoc <- getDiseaseAssoc(
    gene_list = TRUE
  ))


})


# [END]
