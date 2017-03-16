#' @import compareDF
#' @examples \dontrun{
#' diff_csv("474/res.csv", "474/res_REVIEW.csv")
#' diff_csv("475/res.csv", "475/res_review.csv")
#' diff_csv("476/res.csv", "476/res_review.csv")
#' diff_csv("477/res.csv", "477/res_review.csv")
#' }
diff_csv <- function(original_csv, hand_edit_csv){
  orig_csv  <- read.csv(original_csv, stringsAsFactors = FALSE)
  hedit_csv <- read.csv(hand_edit_csv, stringsAsFactors = FALSE)[,1:ncol(orig_csv)]
  
  
  # doctr::issues(doctr::compare(orig_csv, hedit_csv))
  
  # # daff ####
  # res <- daff::diff_data(orig_csv, hedit_csv)
  
  # compareDF ####
  res <- compareDF::compare_df(hedit_csv, orig_csv, c("pagenum"))
  
  res$change_count
  # head(res$comparison_table_diff, 7)
  rows_changed <- res$change_summary[3]
  cell_changes <- length(grep("\\+", unlist(res$comparison_table_diff[,3:ncol(res$comparison_table_diff)])))
  percent_diff <- round(cell_changes / length(unlist(res$comparison_table_diff[,3:ncol(res$comparison_table_diff)])) * 100, 2)
  
  # write(res$html_output, "compareDF.html")
  
  paste0(cell_changes, " cells changed; ",rows_changed, " rows changed; ", percent_diff, "% percent difference")
}