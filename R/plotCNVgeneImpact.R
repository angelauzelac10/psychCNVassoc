# Plot Number genic vs. non-genic CNVs
#
# Given the number of CNVs that contain 1 or more genes and the total number of CNVs
# from the input table, plot a piechart demonstrating the distribution of CNVs that
# contain 1 or more genes vs. CNVs that contain no genes. This function is called
# from within getCNVgenes().
#


plotCNVgeneImpact <- function(genic_CNV_count, total_CNV_count){

  # validate CNV counts
  if (genic_CNV_count < 1){
    stop("Could not produce piechart. There are no CNVs that contain genes.")
  }
  if (genic_CNV_count > total_CNV_count){
    stop("Could not produce piechart. There cannot be more CNVs that contain genes than there are CNVs in total.")
  }

  # calculate number of non-genic CNVs
  nongenic_CNV_count <- total_CNV_count - genic_CNV_count
  counts <- c(genic_CNV_count, nongenic_CNV_count)

  # set labels (percent genic vs. non-genic out of total)
  labels <- c(paste0(round(100 * genic_CNV_count/total_CNV_count, 1), "%"),
              paste0(round(100 * nongenic_CNV_count/total_CNV_count, 1), "%"))

  # capture default par
  current_mai <- par("mai")
  # change margins
  par(mai = c(0.3, 0.3, 0.3, 0.3))
  # plot piechart
  pie(counts,
      labels = labels,
      col = c("lightblue", "orangered"),
      main = "Distribution of Genic vs Non-Genic CNVs",
      radius = 0.8)
  # add legend
  legend("topright",
         legend = c("CNVs containing 1 or more genes", "CNVs containing no genes"),
         fill = c("lightblue", "orangered"),
         cex = 0.6,
         bty = "n")

  # return par to default state
  par(mai = current_mai)

}
