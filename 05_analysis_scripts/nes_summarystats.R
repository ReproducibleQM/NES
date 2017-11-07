# Calculate mean, standard deviation, and N for each measured variable
# Setup ####

nes_all <- read.csv("nes_data.csv", header=TRUE, na.strings="NA", 
                    stringsAsFactors = FALSE)

nes_all[nes_all$state %in% c("VERMONT", "CONNECTICUT", "RHODE ISLAND", 
                             "NEW HAMPSHIRE", "NEW YORK", "MAINE", 
                             "MASSACHUSETTS", "WISCONSIN", "MINNESOTA", 
                             "MICHIGAN"), "region"] <- "Northeastern"
nes_all[nes_all$state %in% c("ALABAMA", "DELAWARE", "FLORIDA", "GEORGIA",
                             "ILLINOIS", "INDIANA", "KENTUCKY", "MARYLAND", 
                             "MISSISSIPPI", "NEW JERSEY", "NORTH CAROLINA", 
                             "OHIO", "PENNSYLVANIA", "SOUTH CAROLINA", 
                             "TENNESSEE", "VIRGINIA", 
                             "WEST VIRGINIA"), "region"] <- "Southeastern"
nes_all[nes_all$state %in% c("ARKANSAS", "IOWA", "KANSAS", "LOUISIANA", 
                             "MISSOURI", "NEBRASKA", "NORTH DAKOTA", "OKLAHOMA",
                             "SOUTH DAKOTA", "TEXAS"), "region"] <- "Central"
nes_all[nes_all$state %in% c("ARIZONA", "CALIFORNIA", "COLORADO", "IDAHO", 
                             "MONTANA", "NEVADA", "NEW MEXICO", "OREGON", 
                             "UTAH", "WASHINGTON", 
                             "WYOMING"), "region"] <- "Western"
nes_all$region <- as.factor(nes_all$region)
nes_all$region <- factor(nes_all$region, levels = c("Western", "Central", 
                                                    "Northeastern", 
                                                    "Southeastern"))
nes_all$Region <- nes_all$region

# convert days to years
nes_all$retention_time[nes_all$retention_time_units == "days" & 
                     !is.na(nes_all$retention_time_units)] <- 
  nes_all$retention_time[nes_all$retention_time_units == "days" & 
                       !is.na(nes_all$retention_time_units)] / 365

# Reshape data to long format ####
library(reshape2)

nal <- melt(nes_all, 
            id.vars = c("state", "name", "region"),
            measure.vars = c((names(nes_all)[c(8:37)])))
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

# summary_nes$N <- paste("(", summary_nes$N, ")", sep = "")

# Formatting with +- symbol ###################################################

summary_nes$stat <- paste(summary_nes$mean, "\u00b1", summary_nes$sd, sep=" ")

summary_nes[is.na(summary_nes$sd), "stat"] <- 
  paste(summary_nes[is.na(summary_nes$sd), "mean"])
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
  levels(summary_nes$variable) == "drainage_area"] <- 
                                          "Drainage area"
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
  levels(summary_nes$variable)=="p_pnt_source_industrial"] <- 
                                    "P pt. source ind."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_pnt_source_septic"] <- "P pt. source sep."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_nonpnt_source"] <- "P nonpt. source"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_total"] <- "P total inputs"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_pnt_source_muni"] <- "N pt. source mun."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_pnt_source_industrial"] <- 
                                    "N pt. source ind."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_pnt_source_septic"] <- "N pt. source sep."
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_nonpnt_source"] <- "N nonpt. source"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_total"] <- "N total inputs"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_total_out"] <- "P total exports"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_percent_retention"] <- "P retention"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="p_surface_area_loading"] <- "P load per area"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_total_out"] <- "N total exports"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_percent_retention"] <- "N retention"
levels(summary_nes$variable)[
  levels(summary_nes$variable)=="n_surface_area_loading"] <- "N load per area"

# let's make three different dataframes for each of the variable types 
# (each will be a separate table)

morphdf    <- subset(summary_nes, summary_nes$variable_type == "MORPHOMETRY")
physchemdf <- subset(summary_nes, 
                     summary_nes$variable_type == "PHYSIOCHEMICAL")
loaddf     <- subset(summary_nes, summary_nes$variable_type == "LOADING")

reorg_table   <- function(dt, include_header = FALSE){
  dt$param <- dt$variable
  dt <- dt[,-which(names(dt) %in% c("variable", "stat", "variable_type", "N"))]
  
  vars <- as.character(unique(dt$param))
  
  dt <- melt(dt, id = c("param", "region"))
  dt <- dt[order(dt$param, dt$region),]
  dt <- t(dcast(dt, variable ~ param + region, value.var = "value"))
  dt <- dt[-1,]
  
  res <- matrix(nrow = nrow(dt) / 4, ncol = 3 * 4)
  res[,seq(2, ncol(res), by = 3)] <- "\u00b1"
  
  # Western
  res[,1] <- dt[seq(1, nrow(dt), by = 4), 1]
  res[,3] <- dt[seq(1, nrow(dt), by = 4), 2]
  
  # Central
  res[,4] <- dt[seq(2, nrow(dt), by = 4), 1]
  res[,6] <- dt[seq(2, nrow(dt), by = 4), 2]
  
  # Northeastern
  res[,7] <- dt[seq(3, nrow(dt), by = 4), 1]
  res[,9] <- dt[seq(3, nrow(dt), by = 4), 2]
  
  # Southeastern
  res[,10] <- dt[seq(4, nrow(dt), by = 4), 1]
  res[,12] <- dt[seq(4, nrow(dt), by = 4), 2]
  
  res <- data.frame(res, stringsAsFactors = FALSE)
  
  if(include_header){
    res <- rbind(res, c("Mean", NA, "sd",
                        "Mean", NA, "sd",
                        "Mean", NA, "sd",
                        "Mean", NA, "sd"))
    res$Variable <- c(vars, NA)
  }else{
    res$Variable <- vars
  }
  
  res <- res[,c(ncol(res), 1:(ncol(res) - 1))]
  
  if(include_header){
    res <- res[c(nrow(res), 1:(nrow(res) - 1)), ]
  }
  
  names(res) <- c(NA, 
                  NA, "Western", NA, 
                  NA, "Central", NA,
                  NA, "Northeastern", NA,
                  NA, "Southeastern", NA)
  
  res
}

reorg_table_n <- function(dt, include_header = FALSE){

  dt$param <- dt$variable
  dt <- dt[,-which(names(dt) %in% 
                     c("variable", "stat", "variable_type", "mean", "sd"))]
  
  vars <- as.character(unique(dt$param))
  
  dt <- melt(dt, id = c("param", "region"))
  dt <- dt[order(dt$param, dt$region),]
  dt <- t(dcast(dt, variable ~ param + region, value.var = "value"))
  dt <- dt[-1,]
  
  res <- matrix(nrow = length(dt) / 4, ncol = 4)
  
  # Western
  res[,1] <- dt[seq(1, length(dt), by = 4)]
  # Central
  res[,2] <- dt[seq(2, length(dt), by = 4)]
  # Northeastern
  res[,3] <- dt[seq(3, length(dt), by = 4)]
  # Southeastern
  res[,4] <- dt[seq(4, length(dt), by = 4)]
  
  res <- data.frame(res, stringsAsFactors = FALSE)
  res$Variable <- vars
  
  res <- res[,c(ncol(res), 1:(ncol(res) - 1))]
  
  names(res)[2:5] <- c("Western", "Central", "Northeastern", "Southeastern")
  
  res
}

big_reorg   <- rbind(reorg_table(morphdf, include_header = TRUE),
                   reorg_table(physchemdf),
                   reorg_table(loaddf))

big_reorg_n <- rbind(reorg_table_n(morphdf),
                   reorg_table_n(physchemdf),
                   reorg_table_n(loaddf))

# morph_wide    <- dcast(morphdf   , variable ~ region, 
#                        value.var = c("mean", "sd"))
# physchem_wide <- dcast(physchemdf, variable ~ region, value.var = "stat")  
# load_wide     <- dcast(loaddf    , variable ~ region, value.var = "stat")
# big_wide      <- rbind(morph_wide, physchem_wide, load_wide)

# Make the tables ####

library(knitr)
library(kableExtra)
library(magrittr)

# Define table format #########################################################

sink_text <- function(dt, fname){
  unlink(fname)
  write(file = fname, c("\\documentclass{article}",
                        "\\usepackage{booktabs}",
                        "\\usepackage{pdflscape}",
                        "\\usepackage{siunitx}",
                        "\\usepackage[table]{xcolor}",
                        "\\begin{document}",
                        "\\begin{landscape}",
                        gsub("±", "$\\\\pm$", dt),
                        "\\end{landscape}",
                        "\\end{document}"))
}

# sink_text((kable(morph_wide, format = "latex", booktabs = T) %>%
#   kable_styling()), "07_tables/morph_table.tex")
#
# sink_text((kable(physchem_wide, format = "latex", booktabs = T) %>%
#              kable_styling()), "07_tables/physchem_table.tex")
# 
# sink_text((kable(load_wide, format = "latex", booktabs = T) %>%
#              kable_styling()), "07_tables/load_table.tex")
# 
# sink_text((kable(big_wide, format = "latex", booktabs = T) %>%
#              kable_styling()), "07_tables/big_table.tex")

names(big_reorg) <- big_reorg[1,]
names(big_reorg)[1] <- "Variable"
names(big_reorg)[seq(3, ncol(big_reorg), by = 3)] <- "\u00a0"

units <- c(NA, " ($km^{2}$)", " ($km^{2}$)", " ($m$)", 
           " ($m^{3} \\cdot s^{-1}$)",
           " ($years$)", " ($mg \\cdot l^{-1}$)",
           " ($\\si{\\micro\\ohm}$)", " ($m$)", " ($mg \\cdot l^{-1}$)",
           " ($mg \\cdot l^{-1}$)", " ($mg \\cdot l^{-1}$)",
           " ($mg \\cdot l^{-1}$)", " ($kg \\cdot yr^{-1}$)", 
           " ($kg \\cdot yr^{-1}$)", " ($kg \\cdot yr^{-1}$)", 
           " ($kg \\cdot yr^{-1}$)", " ($kg \\cdot yr^{-1}$)",
           " ($kg \\cdot yr^{-1}$)", " ($kg \\cdot yr^{-1}$)", 
           " ($kg \\cdot yr^{-1}$)", " ($kg \\cdot yr^{-1}$)", 
           " ($kg \\cdot yr^{-1}$)", " ($kg \\cdot yr^{-1}$)",
           " (\\%)", "($g / m^{2} / day$)", " ($kg \\cdot yr^{-1}$)", " (\\%)",
           " ($g / m^{2} / day$)")
big_reorg[,"Variable"] <- paste0(big_reorg$Variable, units)

knitr::kable(big_reorg[-1,], 
        format = "latex", booktabs = FALSE, row.names = FALSE, escape = FALSE) %>%     add_header_above(c("Region", 
                          "Western" = 3,
                          "Central" = 3,
                          "Northeastern" = 3,
                          "Southeastern" = 3))), 
  "07_tables/big_table_no_n.tex")

knitr::kable(big_reorg_n, 
                format = "latex", booktabs = FALSE, row.names = FALSE)

