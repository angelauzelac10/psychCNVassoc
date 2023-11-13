
<!-- README.md is generated from README.Rmd. Please edit that file -->

# psychCNVassoc

## Description

<br> `psychCNVassoc` is an R package developed to streamline preliminary
exploratory analysis in psychiatric genetics. It takes Copy Number
Variant (CNV) data as input, identifies genes encompassed by these CNVs,
and associates them with psychiatric disorders from the PsyGeNet
database. While existing packages annotate CNVs with clinical
pathogenicity, evaluate gene dosage sensitivity, and associate
pathogenic CNVs with a broad range of quantitative phenotypes,
psychCNVassoc stands out by focusing exclusively on the association of
CNVs with psychiatric disorders. The package complements existing
workflows by determining whether CNVs warrant further investigation into
the molecular mechanisms underlying their association with psychiatric
disease comorbidities. This package accepts inputs in the format of CNV
calls, which includes the chromosome number, start and end position,
type of variation (deletion or duplication), which can be obtained using
existing CNV detection tools like PennCNV. Additionally, it can accept a
pre-defined list of genes as HGNC symbols (e.g. ‘COMT’, ‘DRD3’, ‘HTR1A’)
for associating genes to diseases. The `psychCNVassoc` package was
developed using `R version 4.3.1 (2023-06-16 ucrt)`,
`Platform: x86_64-w64-mingw32/x64 (64-bit)` and
`Running under: Windows 10 x64 (build 19045)`.

## Installation

<br> <br> To install the latest version of the package:

``` r
install.packages("devtools")
library("devtools")
devtools::install_github("angelauzelac10/psychCNVassoc", build_vignettes = TRUE)
library("psychCNVassoc")
```

To run the Shiny app: Under construction

## Overview

Provide the following commands, customized to your R package. Then
provide a list of user accessible functions within the package and a
brief description of each. Include one image illustrating the overview
of the package that shows the inputs and outputs. Ensure the image is
deposited in the correct location, as discussed in class. Point the user
to vignettes for a tutorial of your package. E.g., <br> <br> <br>

``` r
ls("package:psychCNVassoc")
data(package = "psychCNVassoc") 
browseVignettes("psychCNVassoc")
```

`psychCNVassoc` contains 4 functions.

1.  ***getCNVgenes*** for retrieving a list of genes that are
    encompassed in the provided CNVs.

2.  ***getDiseaseAssoc*** for retrieving a table of gene-disease
    associations.

3.  ***plotCNVsize*** for plotting the distribution of CNV sizes,
    separated by deletion and duplication type CNVs, as a bar plot.

4.  ***plotDiseaseCloud*** for producing a wordcloud of diseases that
    are associated with the list of genes.

The package also contains an example CNV call dataset named
example_CNV_call. Refer to package vignettes for more details. An
overview of the package is illustrated below.

![](./inst/extdata/example.png)

## Contributions

Provide a paragraph clearly indicating the name of the author of the
package and contributions from the author. Outline contributions from
other packages/sources for each function. Outline contributions from
generative AI tool(s) for each function. Include how the tools were used
and how the results from AI tools were incorporated. Remember your
individual contributions to the package are important. E.g., <br> <br>
<br>

The author of the package is Angela Uzelac. The author wrote the
*getCNVgenes* function which produces a list of genes encompassed within
the CNVs from a provided table. The reference genomes used to annotate
functional genomic regions within the CNVs are retrieved from Ensembl.
Two functions were used from the `biomaRt` package, *useEnsembl* to
connect to the specified genome dataset, and *getBM* to obtain all genes
annotated with their chromosomal location. The `dplyr` package was also
used in this function. The function *inner_join* was used to join the
table of genes with the table of CNVs, and *filter* was used to select
rows in the joined table where the gene coordinates are within the CNV
coordinates. The author also wrote the function *getDiseaseAssoc* which
makes use of the *psygenetGene* function from the `psygenet2r` package
to obtain gene-disease associations from the provided list of genes. The
function *plotDiseaseCloud* makes use of the `wordcloud2` and `tm`
packages to clean text data, create a term-document matrix, and plot a
wordcloud of the diseases associated with the pathogenic CNVs. The
function *plotCNVsize* plots the distribution of CNV sizes, with the
code inspired by the `CNVRS-study` package. The function
*plotCNVgeneImpact* (not available to users) was developed using the
generative AI tool ChatGPT (OpenAI, 2023) to aid with graphics.

## References

- H. Wickham (2016). *ggplot2: Elegant Graphics for Data Analysis*.
  Springer-Verlag New York. <https://ggplot2.tidyverse.org>

- Wickham H, François R, Henry L, Müller K, Vaughan D (2023). *dplyr: A
  Grammar of Data Manipulation*. R package version 1.1.3,
  <https://CRAN.R-project.org/package=dplyr>.

- Lang D, Chien G (2018). *wordcloud2: Create Word Cloud by
  ‘htmlwidget’*. R package version 0.2.1,
  <https://CRAN.R-project.org/package=wordcloud2>.

- Feinerer I, Hornik K (2023). *tm: Text Mining Package*. R package
  version 0.7-11, <https://CRAN.R-project.org/package=tm>.

- Steffen Durinck, Paul T. Spellman, Ewan Birney and Wolfgang Huber
  (2009). Mapping identifiers for the integration of genomic datasets
  with the R/Bioconductor package biomaRt. Nature Protocols 4, 1184-1191
  .

- Gutierrez-Sacristan A, Hernandez-Ferrer C, Gonzalez J, Furlong L
  (2023). *psygenet2r: psygenet2r - An R package for querying PsyGeNET
  and to perform comorbidity studies in psychiatric disorders*.
  <doi:10.18129/B9.bioc.psygenet2r>
  <https://doi.org/10.18129/B9.bioc.psygenet2r>, R package version
  1.33.5, <https://bioconductor.org/packages/psygenet2r>.

<br> <br> <br> <br>

- Akaike, H. (1973). Information theory and an extension of the maximum
  likelihood principle. In *Second International Symposium on
  Information Theory*, New York, USA, 267–281. Springer Verlag.
  <https://link.springer.com/chapter/10.1007/978-1-4612-1694-0_15>.

- Biernacki, C., G. Celeux, and G. Govaert (2000). Assessing a mixture
  model for clustering with the integrated classification likelihood.
  *IEEE Transactions on Pattern Analysis and Machine Intelligence* 22.
  <https://hal.inria.fr/inria-00073163/document>

- BioRender. (2020). Image created by Silva, A. Retrieved October 30,
  2020, from <https://app.biorender.com/>

- McCarthy, D. J., Chen Y. and Smyth, G. K. (2012). Differential
  expression analysis of multifactor RNA-Seq experiments with respect to
  biological variation. *Nucleic Acids Research* 40. 4288-4297.
  <https://pubmed.ncbi.nlm.nih.gov/22287627/>

- R Core Team (2023). R: A language and environment for statistical
  computing. R Foundation for Statistical Computing, Vienna, Austria.
  <https://www.R-project.org/>

- Schwarz, G. (1978). Estimating the dimension of a model. *The Annals
  of Statistics* 6, 461–464.
  <https://projecteuclid.org/euclid.aos/1176344136>.

- Scrucca, L., Fop, M., Murphy, T. B. and Raftery, A. E. (2016) mclust
  5: clustering, classification and density estimation using Gaussian
  finite mixture models. *The R Journal* 8(1), 289-317.
  <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5096736/>

- Wickham, H. and Bryan, J. (2019). *R Packages* (2nd edition). Newton,
  Massachusetts: O’Reilly Media. <https://r-pkgs.org/>

## Acknowledgements

This package was developed as part of an assessment for 2019-2023
BCB410H: Applied Bioinformatics course at the University of Toronto,
Toronto, CANADA. `psychCNVassoc` welcomes issues, enhancement requests,
and other contributions. To submit an issue, use the [GitHub
issues](https://github.com/angelauzelac10/psychCNVassoc/issues).
