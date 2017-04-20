# This code calculates a mean, standard deviation, and N for each measured variable by region & lake type

# read the summary file
# make sure you open the Project in R
nes_all <- read.csv("nes_data.csv", header=TRUE, na.strings="NA", stringsAsFactors = FALSE)

# add a column to specify region
nes_all[nes_all$state %in% c("VERMONT", "CONNECTICUT", "RHODE ISLAND", "NEW HAMPSHIRE", "NEW YORK", "MAINE", "MASSACHUSETTS", "WISCONSIN", "MINNESOTA", "MICHIGAN"), "region"] <- "Northeastern"
nes_all[nes_all$state %in% c("ALABAMA", "DELAWARE", "FLORIDA", "GEORGIA", "ILLINOIS", "INDIANA", "KENTUCKY", "MARYLAND", "MISSISSIPPI", "NEW JERSEY", "NORTH CAROLINA", "OHIO", "PENNSYLVANIA", "SOUTH CAROLINA", "TENNESSEE", "VIRGINIA", "WEST VIRGINIA"), "region"] <- "Eastern"
nes_all[nes_all$state %in% c("ARKANSAS", "IOWA", "KANSAS", "LOUISIANA", "MISSOURI", "NEBRASKA", "NORTH DAKOTA", "OKLAHOMA", "SOUTH DAKOTA", "TEXAS"), "region"] <- "Central"
nes_all[nes_all$state %in% c("ARIZONA", "CALIFORNIA", "COLORADO", "IDAHO", "MONTANA", "NEVADA", "NEW MEXICO", "OREGON", "UTAH", "WASHINGTON", "WYOMING"), "region"] <- "Western"
# make REGION a factor
nes_all$region <- as.factor(nes_all$region)
# reorder region levels so final table reads from west to east 
nes_all$region <- factor(nes_all$region, levels = c("Western", "Central", "Northeastern", "Eastern"))

# reshape data to [n]es_[a]ll [l]ong format
library(reshape2)

# nes_all[,9:34] <- apply(nes_all[,9:34], 2, as.numeric) 

nal <- melt(nes_all, 
            id.vars = c("state", "name", "region", "lake_type"),
            measure.vars = c((names(nes_all)[c(9:37)])))
nal$value <- as.numeric(nal$value)

# mean(
#   as.numeric(nal[nal$variable == "p_surface_area_loading" & 
#            nal$region == "EASTERN" & 
#            nal$lake_type == "NATURAL", "value"])
#   , na.rm = TRUE)

# calculate mean, standard dev, and N for each variable by region and lake type
library(plyr)
summary_nes = ddply(nal, .(variable, region, lake_type), summarize,
                mean = mean(value, na.rm=TRUE),
                sd = sd(value, na.rm=TRUE),
                N = length(value[!is.na(value)]))

# any(!is.na(summary_nes$mean))

# now how to report numbers? let's convert them to character strings & round means & sd's to 2 decimal places for now
summary_nes$mean <- as.character(round(summary_nes$mean, digits=2))
summary_nes$sd <- as.character(round(summary_nes$sd, digits=2))
summary_nes$N <- as.character(summary_nes$N)

# add parentheses around N
summary_nes$N <- paste("(", summary_nes$N, ")", sep="")

# now create a column with the 3 values & the +- symbol (using paste?)
summary_nes$stat <- paste(summary_nes$mean, "\u00b1", summary_nes$sd, summary_nes$N, sep=" ")
# Didn't need to do this so far, but might need to execute the following if +- symbol doesn't work
Encoding(summary_nes$stat) <- "UTF-8"

# now name classify variables into morphometry, physicochemical, & loading variables
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[1:5]), "variable_type"] <- "MORPHOMETRY"
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[7:13]), "variable_type"] <- "PHYSIOCHEMICAL"
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[14:29]), "variable_type"] <- "LOADING"

# Rename variables
levels(summary_nes$variable)[levels(summary_nes$variable)=="drainage_area"] <- "Drainage area"
levels(summary_nes$variable)[levels(summary_nes$variable)=="surface_area"] <- "Surface area"
levels(summary_nes$variable)[levels(summary_nes$variable)=="mean_depth"] <- "Mean depth"
levels(summary_nes$variable)[levels(summary_nes$variable)=="total_inflow"] <- "Total inflow"
levels(summary_nes$variable)[levels(summary_nes$variable)=="retention_time"] <- "Retention time"
levels(summary_nes$variable)[levels(summary_nes$variable)=="alkalinity"] <- "Alkalinity"
levels(summary_nes$variable)[levels(summary_nes$variable)=="conductivity"] <- "Conductivity"
levels(summary_nes$variable)[levels(summary_nes$variable)=="secchi"] <- "Secchi depth"
levels(summary_nes$variable)[levels(summary_nes$variable)=="tp"] <- "Total P"
levels(summary_nes$variable)[levels(summary_nes$variable)=="po4"] <- "Total inorg. P"
levels(summary_nes$variable)[levels(summary_nes$variable)=="tin"] <- "Total inorg. N"
levels(summary_nes$variable)[levels(summary_nes$variable)=="tn"] <- "Total N"
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_pnt_source_muni"] <- "P pt. source mun."
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_pnt_source_industrial"] <- "P pt. source ind."
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_pnt_source_septic"] <- "P pt. source sep."
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_nonpnt_source"] <- "P nonpt. source"
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_total"] <- "P total inputs"
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_pnt_source_muni"] <- "N pt. source mun."
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_pnt_source_industrial"] <- "N pt. source ind."
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_pnt_source_septic"] <- "N pt. source sep."
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_nonpnt_source"] <- "N nonpt. source"
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_total"] <- "N total inputs"
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_total_out"] <- "P total exports"
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_percent_retention"] <- "P retention (%)"
levels(summary_nes$variable)[levels(summary_nes$variable)=="p_surface_area_loading"] <- "P load per area"
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_total_out"] <- "N total exports"
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_percent_retention"] <- "N retention (%)"
levels(summary_nes$variable)[levels(summary_nes$variable)=="n_surface_area_loading"] <- "N load per area"

# Rename lake types
summary_nes$lake_type <- as.factor(summary_nes$lake_type)
levels(summary_nes$lake_type)[levels(summary_nes$lake_type)=="IMPOUNDMENT"] <- "Impoundment"
levels(summary_nes$lake_type)[levels(summary_nes$lake_type)=="NATURAL"] <- "Natural"

# let's make three different dataframes for each of the variable types (each will be a separate table)
# morph <- summary_nes[summary_nes$variable_type=="MORPHOMETRY", ]
# physchem <- summary_nes[summary_nes$variable_type=="PHYSIOCHEMICAL", ]
# load <- summary_nes[summary_nes$variable_type=="LOADING", ]
#Getting weird rows in dataframes created above, changed to use subset function

morphdf <- subset(summary_nes, summary_nes$variable_type == "MORPHOMETRY")
physchemdf <- subset(summary_nes, summary_nes$variable_type == "PHYSIOCHEMICAL")
loaddf <- subset(summary_nes, summary_nes$variable_type == "LOADING")



# THIS NEXT STEP BREAKS IT :(
# let's reshape these
morph_wide <- dcast(morphdf, variable + lake_type ~ region, value.var="stat")
physchem_wide <- dcast(physchemdf, variable + lake_type ~ region, value.var="stat")  
load_wide <- dcast(loaddf, variable + lake_type ~ region, value.var="stat")

# let's make the tables
# install.packages("devtools")
# devtools::install_github("rstudio/rmarkdown")
# For dev version
# devtools::install_github("haozhu233/kableExtra")

# load libraries
library(knitr)
library(kableExtra)
library(magrittr)

# define the table format as 
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

#Cant get table to not run off page
sink_text((kable(load_wide, format = "latex", booktabs = T) %>%
             kable_styling()), "07_tables/load_table.tex")



# Example code
# LaTeX Table
# kable(dt, format = "latex", booktabs = T, caption = "Demo Table") %>%
#   kable_styling(latex_options = c("striped", "hold_position"), 
#                 full_width = F) %>%
#   add_header_above(c(" ", "Group 1" = 2, "Group 2[note]" = 2)) %>%
#   add_footnote(c("table footnote"))

