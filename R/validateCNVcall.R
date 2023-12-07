# Validate the input CNV call data frame
#
# A function that terminates execution and produces an error message when the
# user enters a CNV call that does not meet format requirements.
#
# Function is called from getCNVgenes() and plotCNVsize().


validateCNVcall <- function(CNV_call){

  if (!is.data.frame(CNV_call)){
    stop("First argument passed must be a dataframe.")
  }
  if (nrow(CNV_call) < 1){
    stop("There are no rows in the input CNV call dataframe.")
  }
  if (ncol(CNV_call) != 4){
    stop("The CNV call dataframe must have 4 columns.")
  }
  if (!all(colnames(CNV_call) %in% c("chromosome_name", "start_position", "end_position", "type"))){
    stop("The CNV call dataframe must have columns named chromosome_name, start_position, end_position, and type in that order.")
  }
  if (!all(CNV_call$chromosome_name %in% c(1:22, "X", "Y"))){
    stop("All chromosome numbers in the CNV call must be 1-22, X, or Y.")
  }
  if (!all(is.numeric(CNV_call$start_position)) | !all(is.numeric(CNV_call$end_position))){
    stop("Start and end position must be positive integer values.")
  }
  if (!all(is.integer(as.integer(CNV_call$start_position))) | !all(is.numeric(as.integer(CNV_call$end_position)))
      | !all(CNV_call$start_position > 0) | !all(CNV_call$end_position > 0)){
    stop("Start and end position must be positive integer values.")
  }
  if (!all(CNV_call$start_position < CNV_call$end_position)){
    stop("The start position must be before the end position for each CNV.")
  }
  if (!all(CNV_call$type %in% c("DEL", "DUP"))){
    stop("The value of the CNV type must be either 'DUP' or 'DEL'.")
  }

}
