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
