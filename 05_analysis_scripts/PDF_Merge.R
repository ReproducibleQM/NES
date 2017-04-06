# Define Paths ------------------------------------------------------------

Path474 <- '03_qa_data//474//res_review.csv'
Path475 <- '03_qa_data//475//res_review.csv'
Path476 <- '03_qa_data//476//res_review.csv'
Path477 <- '03_qa_data//477//res_review.csv'
StoretPath <- '04_supporting_data//storet.csv'
retention_units <- '04_supporting_data/retention_time_units.csv'

# Import Data -------------------------------------------------------------

df474 <- read.csv(Path474, header = TRUE, colClasses = rep("character", 34))
df474 <- df474[, -c(35:36)]
df475 <- read.csv(Path475, header = TRUE, colClasses = rep("character", 34))
df476 <- read.csv(Path476, header = TRUE, colClasses = rep("character", 34))
df477 <- read.csv(Path477, header = TRUE, colClasses = rep("character", 34))
dfStoret <- read.csv(StoretPath, header = TRUE, colClasses = c(rep("character", 6)))
dfStoret <- dfStoret[, -c(1:3)]

retention_units <- read.csv(retention_units, stringsAsFactors = FALSE)

# Add Pdf Origin Column ---------------------------------------------------

df474$Pdf <- "474"
df475$Pdf <- "475"
df476$Pdf <- "476"
df477$Pdf <- "477"

# Merge Dataframes --------------------------------------------------------

df_final <- merge(df474, df475, all = TRUE)
df_final <- merge(df_final, df476, all = TRUE)
df_final <- merge(df_final, df477, all = TRUE)
df_final <- merge(df_final, dfStoret, by.x = "storet_code", by.y = "Storet", 
                  all.x = TRUE)
# df_final <- df_final[, -2]

df_final$Long <- (-1 * as.numeric(df_final$Long))
names(df_final) <- tolower(names(df_final))

df_final <- merge(df_final, retention_units, by = c("pdf", "pagenum"), all.x = TRUE, all.y = FALSE)

ret_time_pos <- which(names(df_final) == "retention_time")
ret_time_units_pos <- which(names(df_final) == "retention_time_units")

df_final <- df_final[,c(
  1:ret_time_pos, 
  ret_time_units_pos, 
  (ret_time_pos + 1):(ncol(df_final) - 1)
  )]

# Export Dataframe as CSV -------------------------------------------------

write.csv(df_final, file = "nes_data.csv")
