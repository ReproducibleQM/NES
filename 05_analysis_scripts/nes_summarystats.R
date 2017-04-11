# This code calculates a mean, standard deviation, and N for each measured variable by region & lake type

# read the summary file
# need to figure out how to read file directly from GitHub
nes_all <- read.csv("nes_data.csv", header=TRUE, na.strings="NA", stringsAsFactors = FALSE)

# add a column to specify region
nes_all[nes_all$state %in% c("VERMONT", "CONNECTICUT", "RHODE ISLAND", "NEW HAMPSHIRE", "NEW YORK", "MAINE", "MASSACHUSETTS", "WISCONSIN", "MINNESOTA", "MICHIGAN"), "region"] <- "NORTHEASTERN"
nes_all[nes_all$state %in% c("ALABAMA", "DELAWARE", "FLORIDA", "GEORGIA", "ILLINOIS", "INDIANA", "KENTUCKY", "MARYLAND", "MISSISSIPPI", "NEW JERSEY", "NORTH CAROLINA", "OHIO", "PENNSYLVANIA", "SOUTH CAROLINA", "TENNESSEE", "VIRGINIA", "WEST VIRGINIA"), "region"] <- "EASTERN"
nes_all[nes_all$state %in% c("ARKANSAS", "IOWA", "KANSAS", "LOUISIANA", "MISSOURI", "NEBRASKA", "NORTH DAKOTA", "OKLAHOMA", "SOUTH DAKOTA", "TEXAS"), "region"] <- "CENTRAL"
nes_all[nes_all$state %in% c("ARIZONA", "CALIFORNIA", "COLORADO", "IDAHO", "MONTANA", "NEVADA", "NEW MEXICO", "OREGON", "UTAH", "WASHINGTON", "WYOMING"), "region"] <- "WESTERN"
# make REGION a factor
nes_all$region <- as.factor(nes_all$region)
# reorder region levels so final table reads from west to east 
nes_all$region <- factor(nes_all$region, levels = c("WESTERN", "CENTRAL", "NORTHEASTERN", "EASTERN"))

# reshape data to [n]es_[a]ll [l]ong format
library(reshape2)

# nes_all[,9:34] <- apply(nes_all[,9:34], 2, as.numeric) 

nal <- melt(nes_all, 
            id.vars = c("state", "name", "region", "lake_type"),
            measure.vars = c((names(nes_all)[c(9:34)])))
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
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[6:12]), "variable_type"] <- "PHYSIOCHEMICAL"
summary_nes[summary_nes$variable %in% c(levels(summary_nes$variable)[13:28]), "variable_type"] <- "LOADING"

# let's make three different dataframes for each of the variable types (each will be a separate table)
morph <- summary_nes[summary_nes$variable_type=="MORPHOMETRY", ]
physchem <- summary_nes[summary_nes$variable_type=="PHYSIOCHEMICAL", ]
load <- summary_nes[summary_nes$variable_type=="LOADING", ]

# let's reshape these
morph_wide <- dcast(morph, variable + lake_type ~ region, value.var="stat")
physchem_wide <- dcast(physchem, variable + lake_type ~ region, value.var="stat")  
load_wide <- dcast(load, variable + lake_type ~ region, value.var="stat")

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
  kable_styling()), "test.tex")

# Example code
# LaTeX Table
# kable(dt, format = "latex", booktabs = T, caption = "Demo Table") %>%
#   kable_styling(latex_options = c("striped", "hold_position"), 
#                 full_width = F) %>%
#   add_header_above(c(" ", "Group 1" = 2, "Group 2[note]" = 2)) %>%
#   add_footnote(c("table footnote"))

