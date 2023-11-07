
# import ggplot2

plotCNVsize <- function(CNV_call, chromosome_number = NULL){
  # cnv_data <- CNV_call
  # cnv_data$size <- cnv_data$end_position - cnv_data$start_position
  #
  # p <- ggplot(data = summary_data, aes(x = size, fill = type)) +
  #   geom_bar(position = "stack", stat = "identity") +
  #   labs(title = "Distribution of CNVs by Size and Type",
  #        x = "CNV Size (# base pairs)",
  #        y = "Number of CNVs") +
  #   theme_minimal()
  # p + theme(legend.position = "right")
  library(ggplot2)
  library(dplyr)
  cnv_data$size <- cnv_data$end_position - cnv_data$start_position
  cnv_data$size_category <- cut(cnv_data$size, breaks = 21)
  # size_distribution <- table(cnv_data$size_category)
  # barplot(size_distribution,
  #         main = "Distribution of CNV Sizes",
  #         xlab = "Size Category",
  #         ylab = "Number of CNVs")
  cnv_summary <- dplyr::summarise(dplyr::group_by(cnv_data, size_category, type), count = dplyr::n())
  plot.new()
  ggplot(cnv_summary, aes(x = size_category, y = count, fill = type)) +
    geom_bar(stat = "identity") +
    scale_x_discrete(labels = label_every_third(21)) +
    ggtitle("Distribution of CNV Sizes with Type Breakdown") +
    xlab("Size Category") +
    ylab("Number of CNVs")

}

label_every_third <- function(n) {
  labels <- rep("", n)
  labels[seq(1, n, by = 3)] <- levels(cnv_summary$size_category)[seq(1, n, by = 3)]
  return(labels)
}
