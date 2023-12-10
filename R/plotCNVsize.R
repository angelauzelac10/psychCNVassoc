#' Plot distribution of CNV sizes
#'
#' Given a CNV call data frame, plot the distribution of CNV sizes (# base pairs),
#' separated by the number of deletions (DEL) vs. number of duplications (DUP).
#' Optionally, plots the size distribution for a specified chromosome.
#'
#' @param CNV_call A dataframe of CNVs containing 4 columns: the chromosome number
#'                on which it is found, the start position, the end position, and
#'                the type (either DUP or DEL).
#' @param chromosome_number A string value indicating the chromosome name
#'                          for which to plot CNV size distribution.
#'                          Can be 1-22, 'X', or 'Y'.
#'
#' @return Returns a histogram of the CNV size distribution, separated by DEL and DUP.
#'
#' @examples
#' # Example 1
#' # Using example_CNV_call dataset available with package
#' # Plot distribution of CNV sizes
#' psychCNVassoc::plotCNVsize(CNV_call = sample_CNV_call)
#'
#' # Example 2
#' # Specifying chromosome number
#' psychCNVassoc::plotCNVsize(CNV_call = sample_CNV_call, chromosome_number = "22")
#'
#' \dontrun{
#'
#' # Example 3
#' # Larger dataset, runs slower
#' psychCNVassoc::plotCNVsize(CNV_call = large_CNV_call)
#'}
#'
#' @references
#'
#' Wickham H (2016). \emph{ggplot2: Elegant Graphics for Data Analysis}.
#' Springer-Verlag New York. \href{https://ggplot2.tidyverse.org}{Link}.
#'
#' Du J (2023). \emph{CNVRS-study}. Unpublished. \href{https://github.com/jenydu/CNVRS-study}{URL}.
#'
#' Gurbich T, Ilinsky V (2020). \emph{ClassifyCNV: A tool for clinical annotation of copy-number variants}.
#' Scientific Reports, 10(1), Article 1. \href{https://doi.org/10.1038/s41598-020-76425-3}{Link}
#'
#'
#' @export
#' @import ggplot2

plotCNVsize <- function(CNV_call, chromosome_number = NULL){

  # validate input CNV data
  validateCNVcall(CNV_call)

  # validate chromosome number
  if (!is.null(chromosome_number) && !(chromosome_number %in% c(1:22, "X", "Y", "x", "y"))){
    stop("Specified chromosome number must be 1-22, X, or Y.")
  }
  if (!is.null(chromosome_number) && chromosome_number == "x"){
    chromosome_number <- "X"
  } else if (!is.null(chromosome_number) && chromosome_number == "y"){
    chromosome_number <- "Y"
  }

  # filter by chromosome number and dynamically set histogram title
  hist_title <- "Distribution of CNV Sizes"
  if(!is.null(chromosome_number) && !(chromosome_number %in% CNV_call$chromosome_name)){
    stop("Specified chromosome number does not exist in the dataset.")
  }
  if (!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
    hist_title <- paste0(hist_title, " (Chromosome ", chromosome_number, ")", sep = "")
  }

  # add attribute CNV size
  CNV_call$size <- CNV_call$end_position - CNV_call$start_position

  # plot CNV size distribution histogram
  cnv_size_hist <- ggplot2::ggplot() +
    geom_histogram(CNV_call[CNV_call$type == 'DEL', ],
                   mapping = aes(x = size, fill = "del"),
                   color = "black",
                   position = "stack") +
    scale_x_log10() +
    geom_histogram(CNV_call[CNV_call$type == 'DUP', ],
                   mapping = aes(x = size, fill = "dup"),
                   color = "black",
                   position = "stack") +
    theme_bw() +
    ggtitle(hist_title) +
    xlab("Size of CNV (log # base pairs)") +
    ylab("Count of CNVs") +
    scale_fill_manual(name = NULL,
                      values = c('del' = "paleturquoise3",'dup' = "plum3"),
                      labels = c('Deletion','Duplication')) +
    theme(legend.position = 'right')

  return(cnv_size_hist)
}

# [END]
