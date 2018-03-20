# Prep for QA ####
raw_paths <- c("../nesR/474/res.csv",
               "../nesR/475/res.csv",
               "../nesR/476/res.csv",
               "../nesR/477/res.csv")
surveys <- 474:477

dt_raw <- lapply(seq_len(length(surveys)), function(x){
  dt <- read.csv(raw_paths[x], stringsAsFactors = FALSE)
  dt$survey <- surveys[x]
  dt
})

dt <- do.call("rbind", dt_raw)
dt <- dt[, c("survey", "pagenum", "chl")]
write.csv(dt, "02_raw_data/merged_data/chl.csv", row.names = FALSE)

# after QA ####

nes   <- read.csv("nes_data.csv", stringsAsFactors = FALSE)
dt_qa <- read.csv("03_qa_data/chl.csv", stringsAsFactors = FALSE)

nes <- dplyr::left_join(nes, dt_qa, by = c("pdf" = "survey", "pagenum"))
write.csv(nes, "nes_data.csv", row.names = FALSE)