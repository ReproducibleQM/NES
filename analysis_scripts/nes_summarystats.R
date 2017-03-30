# This code calculates a mean, standard deviation, and N for each measured variable by region & lake type

# read the summary file
# need to figure out how to read file directly from GitHub
nes_all <- read.csv("/Users/dustinkincaid/gReen2O/nes_data.csv", header=TRUE, na.strings="NA")

# temporary code: rename JERSEY to NEW JERSEY
levels(nes_all$state)[levels(nes_all$state)=="JERSEY"] <- "NEW JERSEY"
# temporary code: classify Lake Wissota in WI (Northeast) to IMPOUNDMENT
nes_all$lake_type[nes_all$name %in% "LAKE WISSOTA"] <- "IMPOUNDMENT"

# add a column to specify region
nes_all[nes_all$state %in% c("VERMONT", "CONNECTICUT", "RHODE ISLAND", "NEW HAMPSHIRE", "NEW YORK", "MAINE", "MASSACHUSETTS", "WISCONSIN", "MINNESOTA", "MICHIGAN"), "region"] <- "NORTHEAST"
nes_all[nes_all$state %in% c("ALABAMA", "DELAWARE", "FLORIDA", "GEORGIA", "ILLINOIS", "INDIANA", "KENTUCKY", "MARYLAND", "MISSISSIPPI", "NEW JERSEY", "NORTH CAROLINA", "OHIO", "PENNSYLVANIA", "SOUTH CAROLINA", "TENNESSEE", "VIRGINIA", "WEST VIRGINIA"), "region"] <- "EASTERN"
nes_all[nes_all$state %in% c("ARKANSAS", "IOWA", "KANSAS", "LOUISIANA", "MISSOURI", "NEBRASKA", "NORTH DAKOTA", "OKLAHOMA", "SOUTH DAKOTA", "TEXAS"), "region"] <- "CENTRAL"
nes_all[nes_all$state %in% c("ARIZONA", "CALIFORNIA", "COLORADO", "IDAHO", "MONTANA", "NEVADA", "NEW MEXICO", "OREGON", "UTAH", "WASHINGTON", "WYOMING"), "region"] <- "WESTERN"
# make REGION a factor
nes_all$region <- as.factor(nes_all$region)

# reshape data to [n]es_[a]ll [l]ong format
library(reshape2)
nal <- melt(nes_all, 
            id.vars = c("state", "name", "region", "lake_type"),
            measure.vars = c((names(nes_all)[c(7:34)])))

# calculate mean, standard dev, and N for each variable by region and lake type
library(plyr)
summary_nes = ddply(nal, .(variable, region, lake_type), summarize,
                mean = mean(value, na.rm=TRUE),
                sd = sd(value, na.rm=TRUE),
                N = length(value[!is.na(value)])
)

# now how to report numbers? let's convert them to character strings & round means & sd's to 2 decimal places for now
summary_nes$mean <- as.character(round(summary_nes$mean, digits=2))
summary_nes$sd <- as.character(round(summary_nes$sd, digits=2))
summary_nes$N <- as.character(summary_nes$N)

# add parentheses around N
summary_nes$N <- paste("(", summary_nes$N, ")", sep="")

# now create a column with the 3 values & the +- symbol (using paste?)
summary_nes$stat <- paste(summary_nes$mean, summary_nes$sd, summary_nes$N, sep=" ")

# how to make +- symbol
x<-"Mean \u00b1 SD or N (%)"
Encoding(x)<-"UTF-8"
