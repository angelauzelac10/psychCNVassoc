
<!-- README.md is generated from README.Rmd. Please edit that file -->

# psychCNVassoc

## Description

A paragraph that describes the purpose of your R package and biological
data being analyzed. Explain how your package add to or improve a
current work flow in bioinformatics or computational biology (i.e., how
is it unique?, what issue does it address?). <br> <br> <br>
`psychCNVassoc` is an R package designed to … The `psychCNVassoc`
package was developed using `R version 4.3.1 (2023-06-16 ucrt)`,
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

`psychCNVassoc` contains 3 functions.

1.  ***getCNVgenes*** for calculating information criteria given dataset
    dimensions, log-likelihood and probability.

2.  ***getDiseaseAssoc*** for calculating normalization factors via via
    trimmed mean of M-values (TMM).

3.  ***plotSummary*** for plotting information criteria values as a
    scatter plot.

4.  ***plotCNVgeneImpact*** for plotting information criteria values as
    a scatter plot.

5.  ***plotDiseaseCloud*** for plotting information criteria values as a
    scatter plot.

The package also contains dataset… Refer to package vignettes for more
details. An overview of the package is illustrated below.

![](./inst/extdata/example.png)

## Contributions

Provide a paragraph clearly indicating the name of the author of the
package and contributions from the author. Outline contributions from
other packages/sources for each function. Outline contributions from
generative AI tool(s) for each function. Include how the tools were used
and how the results from AI tools were incorporated. Remember your
individual contributions to the package are important. E.g., <br> <br>
<br>

The author of the package is Angela Uzelac.

## References

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
