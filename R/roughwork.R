# # Hello, world!
# #
# # This is an example function named 'hello'
# # which prints 'Hello, world!'.
# #
# # You can learn more about package authoring with RStudio at:
# #
# #   http://r-pkgs.had.co.nz/
# #
# # Some useful keyboard shortcuts for package authoring:
# #
# #   Install Package:           'Ctrl + Shift + B'
# #   Check Package:             'Ctrl + Shift + E'
# #   Test Package:              'Ctrl + Shift + T'
#
# hello <- function() {
#  print("Hello, world!")
# }
#
# install.packages("usethis")
# library("usethis")
# ?use_mit_license
# usethis::use_mit_license("Angela Uzelac")
# devtools::document()
#
# #to add imports
# usethis::use_package("mclust", type = "Imports",
#                     min_version = "5.3.0")
# #to see in description
# devtools::document()
#
# #to use roxygen with markdown
# usethis::use_roxygen_md()
#
# #after license, manually add to description
# # devtools::document()
# # gives me an issue
#
#
# # create readme
# usethis::use_readme_rmd()
# devtools::build_readme()
#
# # deleted existing NAMESPACE, then went to build to use Roxygen2 to auto generate it
# devtools::load_all()
# devtools::document()
#
# #make new R script, automatically in R folder
# usethis::use_r("function1")
# # devtools::load_all()
# # gives me an issue
#
# # ?devtools
#

#none of the files can have a load_all function or else it goes into infinite loop
#
# library(usethis)
# example_CNV_call <- readr::read_tsv("ACMG_examples.hg19.bed", col_names = FALSE)

# sample_CNV_call <- example_CNV_call
# colnames(sample_CNV_call) <- c("chromosome_name", "start_position", "end_position", "type")
# sample_CNV_call$chromosome_name <- gsub("^chr", "", sample_CNV_call$chromosome_name)
#
# usethis::use_data(sample_CNV_call)
#
# large_CNV_call <- readr::read_tsv("1000Genomes.hg19.bed", col_names = FALSE)
# colnames(large_CNV_call) <- c("chromosome_name", "start_position", "end_position", "type")
# large_CNV_call$chromosome_name <- gsub("^chr", "", large_CNV_call$chromosome_name)
# # Generate random indices
# random_ind <- sample(nrow(large_CNV_call), size = 10000, replace = FALSE)
# # Take the random subset
# large_CNV_call <- large_CNV_call[random_ind, ]
# usethis::use_data(large_CNV_call)



#put this in import of plotDiseaseCloud
# install.packages("tm")
# install.packages("tm.plugin.wordcloud")
# install.packages("wordcloud2")


# to render readme
# usethis::use_readme_rmd()
# devtools::build_readme()
# images in the README must be in inst/extdata/
# ![](./inst/extdata/ExampleImage.png)

# usethis::use_testthat()
# created tests/testthat, added testthat to Suggests in DESCRIPTION
# created a file tests/testthat.R that runs all tests on devtools::check()
# a test file lives in tests/testthat/ and name of the file must start with "test"
# to open and/or create a test file
# usethis::use_test("test-Name")
# once test is written, can be run with
# devtools::test()


# to add imports to description
# usethis::use_package("mclust", type = "Imports", min_version = "5.3.0")
# devtools::document()
# If want to use roxygen with markdown
# usethis::use_roxygen_md()
# Setting RoxygenNote field in DESCRIPTION to ’6.1.1’
# After License, manually add to DESCRIPTION
# Depends: R (>= 3.1.0)
# devtools::document()
# To add Suggests, example:
# usethis::use_package("RTCGA.rnaseq", type = "Suggests")

# use don't run for examples that would take long to run
# preview documentation with ?functionName



# different way of getting genes within CNVs

# i <- 1
# genes_in_cnv <- character()
# while(i <= nrow(CNV_call)){
#   chrom <- CNV_call$chromosome_name[i]
#   start <- CNV_call$start_position[i]
#   end <- CNV_call$end_position[i]
#   genes <- all_genes[all_genes$chromosome_name == chrom, ]
#   genes <- genes[genes$start_position >= start & genes$end_position <= end, ]
#   genes_in_cnv <- c(genes_in_cnv, genes$hgnc_symbol)
#   i <- i + 1
# }


