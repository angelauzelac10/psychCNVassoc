#' testing


plotCNVgeneImpact <- function(genic_CNV_count, total_CNV_count){

  if(genic_CNV_count < 1){
    stop("There are no CNVs that contain genes.")
  }
  if(genic_CNV_count > total_CNV_count){
    stop("There cannot be more CNVs that contain genes than there are CNVs in total.")
  }

  nongenic_CNV_count <- total_CNV_count - genic_CNV_count
  counts <- c(genic_CNV_count, nongenic_CNV_count)
  labels <- c(paste0(round(100 * genic_CNV_count/total_CNV_count, 1), "%"), paste0(round(100 * nongenic_CNV_count/total_CNV_count, 1), "%"))

  current_par <- par()
  par(mai = c(0.3, 0.3, 0.3, 0.3))
  pie(counts,
      labels = labels,
      col = c("lightblue", "orangered"),
      main = "Distribution of Genic vs Non-Genic CNVs",
      radius = 0.8)
  legend("topright",
         legend = c("CNVs containing 1 or more genes", "CNVs containing no genes"),
         fill = c("lightblue", "orangered"),
         cex = 0.6,
         bty = "n")
  par(current_par)

}
