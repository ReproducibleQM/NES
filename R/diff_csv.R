#' @import compareDF
#' @examples \dontrun{
#' diff_csv_summary("474/res.csv", "474/res_review.csv")
#' diff_csv_summary("475/res.csv", "475/res_review.csv")
#' diff_csv_summary("476/res.csv", "476/res_review.csv")
#' diff_csv_summary("477/res.csv", "477/res_review.csv")
#' }
diff_csv_summary <- function(original_csv, hand_edit_csv){
  orig_csv  <- read.csv(original_csv, stringsAsFactors = FALSE)
  hedit_csv <- read.csv(hand_edit_csv, stringsAsFactors = FALSE)[,1:ncol(orig_csv)]
  
  res <- compareDF::compare_df(hedit_csv, orig_csv, c("pagenum"))
  
  rows_changed <- res$change_summary[3]
  cell_changes <- length(grep("\\+", unlist(res$comparison_table_diff[,3:ncol(res$comparison_table_diff)])))
  percent_diff <- round(cell_changes / length(unlist(res$comparison_table_diff[,3:ncol(res$comparison_table_diff)])) * 100, 2)
  
  paste0(cell_changes, " cells changed; ",rows_changed, " rows changed; ", percent_diff, "% percent difference")
}