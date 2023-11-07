
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

<br> <br> <br> To install the latest version of the package:

``` r
install.packages("devtools")
#> Installing package into 'C:/Users/angel/AppData/Local/Temp/RtmponTI3A/temp_libpathf88290a4026'
#> (as 'lib' is unspecified)
#> package 'devtools' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\downloaded_packages
library("devtools")
#> Warning: package 'devtools' was built under R version 4.3.2
#> Loading required package: usethis
devtools::install_github("angelauzelac10/psychCNVassoc", build_vignettes = TRUE)
#> Downloading GitHub repo angelauzelac10/psychCNVassoc@HEAD
#> ggplot2   (3.4.4   -> 567006c73...) [GitHub]
#> lifecycle (1.0.3   -> 1.0.4       ) [CRAN]
#> withr     (2.5.1   -> 2.5.2       ) [CRAN]
#> rlang     (1.1.1   -> 1.1.2       ) [CRAN]
#> htmltools (0.5.6.1 -> 0.5.7       ) [CRAN]
#> httpuv    (1.6.11  -> 1.6.12      ) [CRAN]
#> xfun      (0.40    -> 0.41        ) [CRAN]
#> evaluate  (0.22    -> 0.23        ) [CRAN]
#> utf8      (1.2.3   -> 1.2.4       ) [CRAN]
#> limma     (3.58.0  -> 3.58.1      ) [CRAN]
#> Installing 9 packages: lifecycle, withr, rlang, htmltools, httpuv, xfun, evaluate, utf8, limma
#> Installing packages into 'C:/Users/angel/AppData/Local/Temp/RtmponTI3A/temp_libpathf88290a4026'
#> (as 'lib' is unspecified)
#> 
#>   There is a binary version available but the source version is later:
#>           binary source needs_compilation
#> lifecycle  1.0.3  1.0.4             FALSE
#> 
#> package 'withr' successfully unpacked and MD5 sums checked
#> package 'rlang' successfully unpacked and MD5 sums checked
#> package 'htmltools' successfully unpacked and MD5 sums checked
#> package 'httpuv' successfully unpacked and MD5 sums checked
#> package 'xfun' successfully unpacked and MD5 sums checked
#> package 'evaluate' successfully unpacked and MD5 sums checked
#> package 'utf8' successfully unpacked and MD5 sums checked
#> package 'limma' successfully unpacked and MD5 sums checked
#> 
#> The downloaded binary packages are in
#>  C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\downloaded_packages
#> installing the source package 'lifecycle'
#> Downloading GitHub repo hadley/ggplot2@HEAD
#> 
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\remotes637c328b751c\tidyverse-ggplot2-567006c/DESCRIPTION' ...     checking for file 'C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\remotes637c328b751c\tidyverse-ggplot2-567006c/DESCRIPTION' ...   ✔  checking for file 'C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\remotes637c328b751c\tidyverse-ggplot2-567006c/DESCRIPTION' (441ms)
#>       ─  preparing 'ggplot2': (16.7s)
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  installing the package to build vignettes (1.3s)
#>          creating vignettes ...     creating vignettes ...   ✔  creating vignettes (1m 26.7s)
#>       ─  checking for LF line-endings in source and make files and shell scripts (787ms)
#>       ─  checking for empty or unneeded directories
#>       ─  building 'ggplot2_3.4.4.9000.tar.gz'
#>      
#> 
#> Installing package into 'C:/Users/angel/AppData/Local/Temp/RtmponTI3A/temp_libpathf88290a4026'
#> (as 'lib' is unspecified)
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\remotes637c1a255e59\angelauzelac10-psychCNVassoc-138544d/DESCRIPTION' ...     checking for file 'C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\remotes637c1a255e59\angelauzelac10-psychCNVassoc-138544d/DESCRIPTION' ...   ✔  checking for file 'C:\Users\angel\AppData\Local\Temp\RtmpgT6rB0\remotes637c1a255e59\angelauzelac10-psychCNVassoc-138544d/DESCRIPTION' (920ms)
#>       ─  preparing 'psychCNVassoc':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>       ─  checking for empty or unneeded directories
#>       ─  building 'psychCNVassoc_0.1.0.tar.gz'
#>      
#> 
#> Installing package into 'C:/Users/angel/AppData/Local/Temp/RtmponTI3A/temp_libpathf88290a4026'
#> (as 'lib' is unspecified)
#> Warning in i.p(...): installation of package
#> 'C:/Users/angel/AppData/Local/Temp/RtmpgT6rB0/file637c42e433c1/psychCNVassoc_0.1.0.tar.gz'
#> had non-zero exit status
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
#> [1] "example_CNV_call"
data(package = "psychCNVassoc") 
browseVignettes("psychCNVassoc")
#> No vignettes found by browseVignettes("psychCNVassoc")
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

The package also contains two RNA sequencing datasets, called GeneCounts
and GeneCounts2. Refer to package vignettes for more details. An
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

The author of the package is Angela Uzelac.

## References

<br> <br>

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

<br> <br> <br> This package was developed as part of an assessment for
2019-2023 BCB410H: Applied Bioinformatics course at the University of
Toronto, Toronto, CANADA. `psychCNVassoc` welcomes issues, enhancement
requests, and other contributions. To submit an issue, use the [GitHub
issues](https://github.com/angelauzelac10/psychCNVassoc/issues).
