
pull_residence_units <- function(folder){
  f_list <- list.files(folder, full.names = TRUE, include.dirs = TRUE)
  f_list  <- f_list[grep("[0-9].csv", f_list)]
  
  page <- strsplit(basename(f_list), "\\.")
  page <- do.call("c", lapply(page, function(x) x[1]))
  
  units <- lapply(f_list, nesR::get_residence_units)
  units <- purrr::flatten_chr(units)
  
  pdf <- dirname(f_list)

  data.frame(pdf = pdf, pagenum = page, retention_time_units = units)
}

res <- lapply(c("474", "475", "476", "477"), pull_residence_units)
res <- do.call("rbind", res)

write.csv(res, row.names = FALSE, "retention_time_units.csv")