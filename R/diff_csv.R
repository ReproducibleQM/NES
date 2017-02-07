#' @import daff
#' @examples \dontrun{
#' diff_csv("475/res.csv", "475/res_review.csv")
#' diff_csv("476/res.csv", "476/res_review.csv")
#' }
diff_csv <- function(original_csv, hand_edit_csv){
  orig_csv  <- read.csv(original_csv, stringsAsFactors = FALSE)
  hedit_csv <- read.csv(hand_edit_csv, stringsAsFactors = FALSE)
  
  daff::render_diff(daff::diff_data(orig_csv, hedit_csv))
}