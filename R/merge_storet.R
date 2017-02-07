#' @examples \dontrun{
#' merge_storet("storet.csv", "476/res_review.csv")
#' }

merge_storet <- function(storet_path, data_path){
  dt     <- read.csv(data_path, stringsAsFactors = FALSE)
  zero_pad <- function(x){
    if(!is.na(x)){
      if(nchar(x) == 3){paste0("0", x)
        }else{x}
    }else{x}
  }
  dt$storet_code <- sapply(dt$storet_code, zero_pad)
  
  storet <- read.csv(storet_path, stringsAsFactors = FALSE)
  storet$Long <- storet$Long * -1
  
  res <- merge(dt, storet, by.x = "storet_code", by.y = "Storet")
  res
}