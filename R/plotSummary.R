
# import ggplot2

plotCNVsize <- function(CNV_call, chromosome_number = NULL){

  if(!is.data.frame(CNV_call)){
    stop("First argument passed into function plotCNVsize() must be a dataframe.")
  }
  if(nrow(CNV_call) < 1){
    stop("There are no rows in the input CNV call dataframe.")
  }
  if(ncol(CNV_call) != 4){
    stop("The CNV call dataframe must have 4 columns.")
  }
  if(colnames(CNV_call) != c("chromosome_name", "start_position", "end_position", "type")){
    stop("The CNV call dataframe must have columns named chromosome_name, start_position, end_position, and type in that order.")
  }
  if(!all(CNV_call$chromosome_name %in% c(1:22, "X", "Y"))){
    stop("Chromosome number must be 1-22, X, or Y.")
  }
  if(!all(is.numeric(CNV_call$start_position)) | !all(is.numeric(CNV_call$end_position))){
    stop("Start and end position must be integer values.")
  }
  if(!all(CNV_call$start_position < CNV_call$end_position)){
    stop("The start position must be before the end position for each CNV.")
  }
  if(!all(CNV_call$type %in% c("DEL", "DUP"))){
    stop("The value of the CNV type must be either 'DUP' or 'DEL'.")
  }

  if(!is.null(chromosome_number)){
    CNV_call <- CNV_call[CNV_call$chromosome_name == chromosome_number, ]
  }


  cnv_data$size <- cnv_data$end_position - cnv_data$start_position

  cnv_size_hist <- ggplot() +
    geom_histogram(cnv_data[cnv_data$type == 'DEL', ],
                   mapping=aes(x = size, fill = "del"),
                   color = "black",
                   position = "stack") +
    scale_x_log10() +
    geom_histogram(cnv_data[cnv_data$type == 'DUP', ],
                   mapping = aes(x = size, fill = "dup"),
                   color = "black",
                   position = "stack") +
    theme_bw() +
    ggtitle('Distribution of CNV Sizes') +
    xlab("Log-Size of CNV") +
    ylab("Number of CNVs") +
    scale_fill_manual(name = NULL,
                      values = c('del' = "paleturquoise3",'dup' = "plum3"),
                      labels = c('Deletion','Duplication')) +
    theme(legend.position = 'right')

  cnv_size_hist
}
