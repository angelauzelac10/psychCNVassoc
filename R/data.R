#' CNV position data from a CNV call
#'
#' A data frame containing a sample CNV call. Obtained from a sample CNV call
#' dataset named ACMG_examples.hg19.bed from the ClassifyCNV package in the /Examples subdirectory.
#' This dataset contains a subset of 21 CNV calls described by 4 fields: chromosome name, start position,
#' end position, and type (deletion or duplication). The CNV calling was done on Homo sapiens genotype
#' data using genome build hg19 and contain autosomes 1-5, 6, 11-3, 15, 17-19, 22, and sex chromosome X.
#'
#' @source Gurbich, T.A., Ilinsky, V.V. (2020). ClassifyCNV: a tool for clinical
#' annotation of copy-number variants. Sci Rep 10, 20375. \href{https://doi.org/10.1038/s41598-020-76425-3}{Link}
#'
#' @format A data frame with columns:
#' \describe{
#'  \item{chromosome_name}{Chromosome name on which the CNV is found.}
#'  \item{start_position}{Start position (base) of the CNV.}
#'  \item{end_position}{End position (base) of the CNV.}
#'  \item{type}{Type of the CNV, either DUP (duplication) or DEL (deletion).}
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
#' This dataset contains a subset of 10,000 CNV calls described by 4 fields: chromosome name, start position,
#' end position, and type (deletion or duplication). The CNV calling was done on Homo sapiens genotype
#' data using genome build hg38 and contain autosomes 1-22 and sex chromosome X.
#'
#' @source Gurbich T, Ilinsky V (2020). ClassifyCNV: a tool for clinical
#' annotation of copy-number variants. Sci Rep 10, 20375. \href{https://doi.org/10.1038/s41598-020-76425-3}{Link}
#'
#' @format A data frame with columns:
#' \describe{
#'  \item{chromosome_name}{Chromosome name on which the CNV is found.}
#'  \item{start_position}{Start position (base) of the CNV.}
#'  \item{end_position}{End position (base) of the CNV.}
#'  \item{type}{Type of the CNV, either DUP (duplication) or DEL (deletion).}
#' }
#'
#' @examples
#' \dontrun{
#'  large_CNV_call
#' }
"large_CNV_call"
