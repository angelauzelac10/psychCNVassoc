#' CNV position data from a CNV call
#'
#' A data frame containing a sample CNV call. Obtained from a sample CNV call
#' dataset named ACMG_examples.hg19.bed from the ClassifyCNV package in the /Examples subdirectory.
#'
#' @source Gurbich, T.A., Ilinsky, V.V. (2020). ClassifyCNV: a tool for clinical
#' annotation of copy-number variants. Sci Rep 10, 20375. \href{https://doi.org/10.1038/s41598-020-76425-3}{Link}
#'
#' @format A data frame with columns:
#' \describe{
#'  \item{X1}{Chromosome name on which the CNV is found.}
#'  \item{X2}{Start position (base) of the CNV.}
#'  \item{X3}{End position (base) of the CNV.}
#'  \item{X4}{Type of the CNV, either DUP (duplication) or DEL (deletion).}
#' }
#'
#' @examples
#' \dontrun{
#'  sample_CNV_call
#' }
"sample_CNV_call"

#' A large CNV call
#'
#' A data frame containing a random subset of a sample CNV call. Obtained from a sample CNV call
#' dataset named 1000Genomes.hg38.bed from the ClassifyCNV package in the /Examples subdirectory.
#'
#' @source Gurbich T, Ilinsky V (2020). ClassifyCNV: a tool for clinical
#' annotation of copy-number variants. Sci Rep 10, 20375. \href{https://doi.org/10.1038/s41598-020-76425-3}{Link}
#'
#' @format A data frame with columns:
#' \describe{
#'  \item{X1}{Chromosome name on which the CNV is found.}
#'  \item{X2}{Start position (base) of the CNV.}
#'  \item{X3}{End position (base) of the CNV.}
#'  \item{X4}{Type of the CNV, either DUP (duplication) or DEL (deletion).}
#' }
#'
#' @examples
#' \dontrun{
#'  large_CNV_call
#' }
"large_CNV_call"
