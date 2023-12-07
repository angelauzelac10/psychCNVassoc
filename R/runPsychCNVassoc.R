#' Launch Shiny App for psychCNVassoc package
#'
#' A function that launches the Shiny app for psychCNVassoc.
#' The code for the Shiny app is in \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a Shiny page.
#'
#' @examples
#' \dontrun{
#'
#' psychCNVassoc::runPsychCNVassoc()
#' }
#'
#' @references
#' Silva, A. (2022) TestingPackage: An Example R Package For BCB410H.  Unpublished. URL
#' https://github.com/anjalisilva/TestingPackage.
#'
#' @export
#' @importFrom shiny runApp

runPsychCNVassoc <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "psychCNVassoc")
  actionShiny <- shiny::runApp(appDir, display.mode = "normal")
  return(actionShiny)
}
# [END]
