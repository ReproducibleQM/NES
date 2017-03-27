#' @import compareDF
#' @examples \dontrun{
#' diff_summary("474/res.csv", "474/res_review.csv")
#' diff_summary("475/res.csv", "475/res_review.csv")
#' diff_summary("476/res.csv", "476/res_review.csv")
#' diff_summary("477/res.csv", "477/res_review.csv")
#' }
diff_summary <- function(original_csv, hand_edit_csv){
  orig_csv  <- read.csv(original_csv, stringsAsFactors = FALSE)
  hedit_csv <- read.csv(hand_edit_csv, stringsAsFactors = FALSE)[,1:ncol(orig_csv)]
  
  res <- compareDF::compare_df(hedit_csv, orig_csv, c("pagenum"))
  
  rows_changed <- res$change_summary[3]
  cell_changes <- length(grep("\\+", unlist(res$comparison_table_diff[,3:ncol(res$comparison_table_diff)])))
  percent_diff <- round(cell_changes / length(unlist(res$comparison_table_diff[,3:ncol(res$comparison_table_diff)])) * 100, 2)
  
  paste0(cell_changes, " cells changed; ",rows_changed, " rows changed; ", percent_diff, "% percent difference")
}


#' @import daff
#' @examples \dontrun{
#' diff_patch_create("474/res.csv", "474/res_review.csv")
#' diff_patch_create("475/res.csv", "475/res_review.csv")
#' diff_patch_create("476/res.csv", "476/res_review.csv")
#' diff_patch_create("477/res.csv", "477/res_review.csv")
#' }
diff_patch_create <- function(original_csv, hand_edit_csv){
  orig_csv  <- read.csv(original_csv, stringsAsFactors = FALSE)
  hedit_csv <- read.csv(hand_edit_csv, stringsAsFactors = FALSE)[,1:ncol(orig_csv)]

  res <- daff::diff_data(orig_csv, hedit_csv)
  
  dir.create("diff_patch", showWarnings = FALSE)
  daff::write_diff(res, paste0("diff_patch/", dirname(original_csv), ".csv"))
}

# dt_orig    <- read.csv("474/res.csv", stringsAsFactors = FALSE)
# dt_cleaned <- read.csv("474/res_review.csv", stringsAsFactors = FALSE)
# test <- daff::patch_data(dt_orig, daff::read_diff("diff_patch/474.csv"))
# 
# sapply(1:ncol(test), function(x) identical(test[,x], dt_cleaned[,x]))
