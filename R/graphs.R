flist <- paste0("../", c(475:477), "/res_review.csv")

dt <- do.call("rbind", lapply(flist, function(x) read.csv(x, stringsAsFactors = FALSE)))

for(i in 7:length(names(dt))){
  plot(dt[,i], main = names(dt)[i])#, ylim = c(0, range(dt[,1])[2]*1))
}

dt[which.max(dt[,"n_total_out"]),]

