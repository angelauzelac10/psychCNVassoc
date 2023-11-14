library(psychCNVassoc)

test_that("get genes contained in CNVs from sample CNV call", {

  CNV_call = sample_CNV_call

  gene_list <- getCNVgenes(
    CNV_call = CNV_call)

  expect_type(gene_list, "character")
  show_failure(expect_s3_class(gene_list, "character"))
  expect_length(gene_list, 325)
})


test_that("get genes contained in CNVs on chromosome 22 from sample CNV call using GRCh37 reference genome", {

  CNV_call = sample_CNV_call
  chromosome_number = "22"
  reference_genome = "GRCh37"

  gene_list <- getCNVgenes(
    CNV_call = CNV_call,
    chromosome_number = chromosome_number,
    reference_genome = reference_genome)


  expect_type(gene_list, "character")
  show_failure(expect_s3_class(gene_list, "character"))
  expect_length(gene_list, 108)
})

context("Checking for invalid user input for getCNVgenes")
test_that("getCNVgenes error upon invalid user input", {

  CNV_call = sample_CNV_call
  chromosome_number = "17"
  reference_genome = "GRCh38"
  show_piechart = FALSE

  # CNV_call not a dataframe
  expect_error(gene_list <- getCNVgenes(
    CNV_call = c("abc", "def"),
    chromosome_number = chromosome_number,
    reference_genome = reference_genome,
    show_piechart = show_piechart))

  # CNV_call missing columns
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call[ , 1:3],
    chromosome_number = chromosome_number,
    reference_genome = reference_genome,
    show_piechart = show_piechart))

  # chromosome number not valid
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call,
    chromosome_number = "25",
    reference_genome = reference_genome,
    show_piechart = show_piechart))

  # reference genome not either GRCh37 or GRCh38
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call,
    chromosome_number = chromosome_number,
    reference_genome = "AAA",
    show_piechart = show_piechart))

  # show piechart is not a logical type
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call,
    chromosome_number = chromosome_number,
    reference_genome = reference_genome,
    show_piechart = "show"))


})

context("Checking for invalid CNV call for getCNVgenes")
test_that("getCNVgenes error upon invalid CNV call", {

  chromosome_number = "17"
  reference_genome = "GRCh38"
  show_piechart = FALSE

  CNV_call1 = sample_CNV_call
  names(CNV_call1)[names(CNV_call1) == "start_position"] <- "start"

  CNV_call2 = sample_CNV_call
  CNV_call2$end_position[1] <- "A"

  CNV_call3 = sample_CNV_call
  CNV_call3$type[1] <- "A"

  # invalid column name
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call1,
    chromosome_number = chromosome_number,
    reference_genome = reference_genome,
    show_piechart = show_piechart))

  # invalid value in end_position column
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call2,
    chromosome_number = chromosome_number,
    reference_genome = reference_genome,
    show_piechart = show_piechart))

  # invalid value in type column
  expect_error(gene_list <- getCNVgenes(
    CNV_call = CNV_call3,
    chromosome_number = chromosome_number,
    reference_genome = reference_genome,
    show_piechart = show_piechart))


})

context("Checking for invalid input for plotting piechart")
test_that("plotCNVgeneImpact error upon invalid user input", {

  # cannot have more genic CNVs than total CNVs
  expect_error(plotCNVgeneImpact(genic_CNV_count = 10, total_CNV_count = 8))


})


# [END]
