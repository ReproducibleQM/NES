# Define Paths ------------------------------------------------------------

Path474 <- 'C://Users//cmfor//Documents//GitHub//gReen2O//474//res_review.csv'
Path475 <-'C://Users//cmfor//Documents//GitHub//gReen2O//475//res_review.csv'
Path476 <- 'C://Users//cmfor//Documents//GitHub//gReen2O//476//res_review.csv'
Path477 <- 'C://Users//cmfor//Documents//GitHub//gReen2O//477//res_review.csv'
StoretPath <- 'C://Users//cmfor//Documents//GitHub//gReen2O//storet.csv'

# Import Data -------------------------------------------------------------

df474 <- read.csv(Path474, header = TRUE, colClasses = rep("character", 34))
df474 <- df474[, -c(35:36)]
df475 <- read.csv(Path475, header = TRUE, colClasses = rep("character", 34))
df476 <- read.csv(Path476, header = TRUE, colClasses = rep("character", 34))
df477 <- read.csv(Path477, header = TRUE, colClasses = rep("character", 34))
dfStoret <- read.csv(StoretPath, header = TRUE, colClasses = c(rep("character", 6)))
dfStoret <- dfStoret[, -c(1:3)]

# Merge Dataframes --------------------------------------------------------

df_final <- merge(df474, df475, all = TRUE)
df_final <- merge(df_final, df476, all = TRUE)
df_final <- merge(df_final, df477, all = TRUE)
df_final <- merge(df_final, dfStoret, by.x = "storet_code", by.y = "Storet", all.x = TRUE)
df_final <- df_final[, -2]

df_final$Long <- (-1 * as.numeric(df_final$Long))

# Export Dataframe as CSV -------------------------------------------------

write.csv(df_final, file = "res_review_final.csv")
