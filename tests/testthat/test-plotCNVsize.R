library(psychCNVassoc)


context("Checking for invalid CNV call to plot distribution of CNV sizes")
test_that("plotCNVsize error upon invalid user input", {

  CNV_call = sample_CNV_call

  CNV_call1 = sample_CNV_call
  names(CNV_call1)[names(CNV_call1) == "start_position"] <- "start"

  CNV_call2 = sample_CNV_call
  CNV_call2$end_position[1] <- "A"

  CNV_call3 = sample_CNV_call
  CNV_call3$type[1] <- "A"

  # invalid column name
  expect_error(plotCNVsize(
    CNV_call = CNV_call1))

  # invalid value in end_position column
  expect_error(plotCNVsize(
    CNV_call = CNV_call2))

  # invalid value in type column
  expect_error(plotCNVsize(
    CNV_call = CNV_call3))

  expect_error(plotCNVsize(
    CNV_call = CNV_call,
    chromosome_number = "25"
  ))


})


# [END]
