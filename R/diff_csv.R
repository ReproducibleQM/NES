#' @import compareDF
#' @examples \dontrun{
#' diff_csv("475/res.csv", "475/res_review.csv")
#' diff_csv("476/res.csv", "476/res_review.csv")
#' }
diff_csv <- function(original_csv, hand_edit_csv){
  orig_csv  <- read.csv(original_csv, stringsAsFactors = FALSE)
  hedit_csv <- read.csv(hand_edit_csv, stringsAsFactors = FALSE)
  
  res <- compareDF::compare_df(hedit_csv, orig_csv, c("pagenum"))
  res$change_summary
  res$change_count
  res$comparison_table_diff
  write(res$html_output, "compareDF.html")
}