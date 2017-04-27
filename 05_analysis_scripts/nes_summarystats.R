# This code calculates a mean, standard deviation, and N for each measured
# variable by region & lake type ##############################################

nes_all <- read.csv("nes_data.csv", header=TRUE, na.strings="NA", stringsAsFactors = FALSE)

nes_all[nes_all$state %in% c("VERMONT", "CONNECTICUT", "RHODE ISLAND", "NEW HAMPSHIRE", "NEW YORK", "MAINE", "MASSACHUSETTS", "WISCONSIN", "MINNESOTA", "MICHIGAN"), "region"] <- "Northeastern"
nes_all[nes_all$state %in% c("ALABAMA", "DELAWARE", "FLORIDA", "GEORGIA", "ILLINOIS", "INDIANA", "KENTUCKY", "MARYLAND", "MISSISSIPPI", "NEW JERSEY", "NORTH CAROLINA", "OHIO", "PENNSYLVANIA", "SOUTH CAROLINA", "TENNESSEE", "VIRGINIA", "WEST VIRGINIA"), "region"] <- "Eastern"
nes_all[nes_all$state %in% c("ARKANSAS", "IOWA", "KANSAS", "LOUISIANA", "MISSOURI", "NEBRASKA", "NORTH DAKOTA", "OKLAHOMA", "SOUTH DAKOTA", "TEXAS"), "region"] <- "Central"
nes_all[nes_all$state %in% c("ARIZONA", "CALIFORNIA", "COLORADO", "IDAHO", "MONTANA", "NEVADA", "NEW MEXICO", "OREGON", "UTAH", "WASHINGTON", "WYOMING"), "region"] <- "Western"
nes_all$region <- as.factor(nes_all$region)
nes_all$region <- factor(nes_all$region, levels = c("Western", "Central", "Northeastern", "Eastern"))

# reshape data to [n]es_[a]ll [l]ong format
library(reshape2)

nal <- melt(nes_all, 
            id.vars = c("state", "name", "region"),
            measure.vars = c((names(nes_all)[c(9:37)])))
nal$value <- as.numeric(nal$value)

library(plyr)
summary_nes <- ddply(nal, .(variable, region), summarize,
                mean = mean(value, na.rm = TRUE),
                sd = sd(value, na.rm = TRUE),
                N = length(value[!is.na(value)]))

summary_nes$mean <- round(summary_nes$mean, digits = 2)
summary_nes$sd   <- round(summary_nes$sd, digits = 2)

summary_nes$mean[summary_nes$mean >= 100 & !is.na(summary_nes$mean)] <- 
  format(summary_nes$mean[summary_nes$mean >= 100 & !is.na(summary_nes$mean)], 
         digits = 2)

summary_nes$sd[summary_nes$sd >= 100 & !is.na(summary_nes$sd)] <- 
  format(summary_nes$sd[summary_nes$sd >= 100 & !is.na(summary_nes$sd)], 
         digits = 2)

summary_nes$mean <- as.character(summary_nes$mean)
summary_nes$sd   <- as.character(summary_nes$sd)
summary_nes$N    <- as.character(summary_nes$N)

summary_nes$N <- paste("(", summary_nes$N, ")", sep = "")

# Formatting with +- symbol ###################################################

summary_nes$stat <- paste(summary_nes$mean, "\u00b1", summary_nes$sd, 
                          summary_nes$N, sep=" ")
summary_nes[is.na(summary_nes$sd), "stat"] <- 
  paste(summary_nes[is.na(summary_nes$sd), "mean"], summary_nes[is.na(summary_nes$sd), "N"])
summary_nes[summary_nes$mean == "NaN", "stat"] <- ""

Encoding(summary_nes$stat) <- "UTF-8"

summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[1:5]), 
            "variable_type"] <- "MORPHOMETRY"
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[7:13]), 
            "variable_type"] <- "PHYSIOCHEMICAL"
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[14:29]), 
            "variable_type"] <- "LOADING"

# Rename variables ############################################################

levels(summary_nes$variable)[
  levels(summary_nes$variable) == "drainage_area"] <- "Drainage area"
levels(summary_nes$variable)[
  levels(summary_nes$variable) == "surface_area"] <- "Surface area"
levels(summary_nes$variable)[
  levels(summary_nes$variable) == "mean_depth"] <- "Mean depth"
levels(summary_nes$variable)[
  levels(summary_nes$variable) == "total_inflow"] <- "Total inflow"
levels(summary_nes$variable)[
  levels(summary_nes$variable) == "retention_time"] <- "Retention time"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="alkalinity"] <- "Alkalinity"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="conductivity"] <- "Conductivity"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="secchi"] <- "Secchi depth"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="tp"] <- "Total P"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="po4"] <- "Total inorg. P"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="tin"] <- "Total inorg. N"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="tn"] <- "Total N"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_pnt_source_muni"] <- "P pt. source mun."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_pnt_source_industrial"] <- "P pt. source ind."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_pnt_source_septic"] <- "P pt. source sep."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_nonpnt_source"] <- "P nonpt. source"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_total"] <- "P total inputs"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_pnt_source_muni"] <- "N pt. source mun."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_pnt_source_industrial"] <- "N pt. source ind."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_pnt_source_septic"] <- "N pt. source sep."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_nonpnt_source"] <- "N nonpt. source"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_total"] <- "N total inputs"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_total_out"] <- "P total exports"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_percent_retention"] <- "P retention (%)"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_surface_area_loading"] <- "P load per area"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_total_out"] <- "N total exports"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_percent_retention"] <- "N retention (%)"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_surface_area_loading"] <- "N load per area"

# let's make three different dataframes for each of the variable types (each will be a separate table)

morphdf    <- subset(summary_nes, summary_nes$variable_type == "MORPHOMETRY")
physchemdf <- subset(summary_nes, 
                     summary_nes$variable_type == "PHYSIOCHEMICAL")
loaddf     <- subset(summary_nes, summary_nes$variable_type == "LOADING")

morph_wide <- dcast(morphdf, variable ~ region, value.var="stat")
physchem_wide <- dcast(physchemdf, variable ~ region, value.var="stat")  
load_wide <- dcast(loaddf, variable ~ region, value.var="stat")

# let's make the tables
# install.packages("devtools")
# devtools::install_github("rstudio/rmarkdown")
# For dev version
# devtools::install_github("haozhu233/kableExtra")

library(knitr)
library(kableExtra)
library(magrittr)

# Define table format #########################################################

sink_text <- function(dt, fname){
  unlink(fname)
  write(file = fname, c("\\documentclass{article}",
                        "\\usepackage{booktabs}",
                        "\\usepackage{pdflscape}",
                        "\\begin{document}",
                        "\\begin{landscape}",
                        gsub("±", "$\\\\pm$", dt),
                        "\\end{landscape}",
                        "\\end{document}"))
}

sink_text((kable(morph_wide, format = "latex", booktabs = T) %>%
  kable_styling()), "07_tables/morph_table.tex")

sink_text((kable(physchem_wide, format = "latex", booktabs = T) %>%
             kable_styling()), "07_tables/physchem_table.tex")

sink_text((kable(load_wide, format = "latex", booktabs = T) %>%
             kable_styling()), "07_tables/load_table.tex")

sink_text((kable(rbind(morph_wide, physchem_wide, load_wide), 
                 format = "latex", booktabs = T) %>%
             kable_styling()), "07_tables/big_table.tex")
