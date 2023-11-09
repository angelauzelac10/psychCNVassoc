
# import ggplot2

plotCNVsize <- function(CNV_call, chromosome_number = NULL){

  validateCNVcall(CNV_call)

  hist_title <- "Distribution of CNV Sizes"

  if(!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
    hist_title <- paste0(hist_title, " (Chromosome ", chromosome_number, ")", sep = "")
  }

  CNV_call$size <- CNV_call$end_position - CNV_call$start_position

  cnv_size_hist <- ggplot() +
    geom_histogram(CNV_call[CNV_call$type == 'DEL', ],
                   mapping=aes(x = size, fill = "del"),
                   color = "black",
                   position = "stack") +
    scale_x_log10() +
    geom_histogram(CNV_call[CNV_call$type == 'DUP', ],
                   mapping = aes(x = size, fill = "dup"),
                   color = "black",
                   position = "stack") +
    theme_bw() +
    ggtitle(hist_title) +
    xlab("Log-Size of CNV") +
    ylab("Number of CNVs") +
    scale_fill_manual(name = NULL,
                      values = c('del' = "paleturquoise3",'dup' = "plum3"),
                      labels = c('Deletion','Duplication')) +
    theme(legend.position = 'right')

  cnv_size_hist
}
