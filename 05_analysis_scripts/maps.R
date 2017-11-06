
library(downloader) #
library(rgdal) # 
library(sp)
library(maptools) # 
library(ggplot2)
library(gstat) #
library(raster) #
library(tmap)
library(RColorBrewer) # 
library(png)

# https://robjhyndman.com/hyndsight/crop-r-figures/
savepdf <- function(file, width=16, height=10){
  fname <- paste("06_images/",file,".pdf",sep="")
  pdf(fname, width = width, height = height,
      pointsize = 10)
  par(mgp=c(2.2, 0.45, 0), tcl = -0.4, mar = c(0, 0, 1.1, 1.1))
}

# Read in the file
lakes.dat <- read.csv("./nes_data.csv")

# Remove any rows with NA coordinates
lakes.dat <- subset(lakes.dat, !is.na(lat))
lakes.dat <- subset(lakes.dat, !is.na(long))
which(is.na(lakes.dat$lat) == TRUE) # This should now be zero
which(is.na(lakes.dat$long) == TRUE) # This should now be zero

# Make the longitudes negative if they aren't already
for(i in 1:nrow(lakes.dat)){
  if(lakes.dat$long[i] > 0){
    lakes.dat$long[i] <- -lakes.dat$Long[i]
  } 
}

# Map the US ####
# CRS for the US National Atlas Map
us.atlas.proj <- CRS(paste0("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0", 
                            " +a=6370997 +b=6370997 +units=m +no_defs"))
# CRS for the US in WGS 1984 (world geographic 1984)
wgs1984.proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


# Download US map
# download("http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_state_20m.zip", dest="./05_analysis_scripts/map_data/us_states.zip", mode="wb") 
# download("http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_nation_20m.zip", dest="./05_analysis_scripts/map_data/us_nation.zip", mode="wb") 
# unzip("./05_analysis_scripts/map_data/us_states.zip", exdir = "./05_analysis_scripts/map_data")
# unzip("./05_analysis_scripts/map_data/us_nation.zip", exdir = "./05_analysis_scripts/map_data")

# read in the shapefile
us.states <- readShapePoly(
  "./05_analysis_scripts/map_data/cb_2014_us_state_20m.shp")
us.nation <- readShapePoly(
  "./05_analysis_scripts/map_data/cb_2014_us_nation_20m.shp")
# Extract the US without Hawaii, Alaska or Puerto Rico
us.49 <- us.states[us.states$NAME != "Hawaii",]
us.48 <- us.49[us.49$NAME != "Alaska",]
us.48 <- us.48[us.48$NAME != "Puerto Rico",]

# Crop the nation map to the extent of the state map
us.nation <- crop(us.nation, us.48)
us.unproj.nation <- us.nation # keep a copy for cropping the raster later

# Define the extent of the map (will use for creating IDW grid later)
x.range <- as.numeric(us.48@bbox[1,])  
y.range <- as.numeric(us.48@bbox[2,])  

# Project us.48, but not usr.48
proj4string(us.48)     <- wgs1984.proj
proj4string(us.nation) <- wgs1984.proj
us.48     <- spTransform(us.48, us.atlas.proj)
us.nation <- spTransform(us.nation, us.atlas.proj)
# plot(us.48)
# plot(us.nation)

# Define a color ramp for the maps
my.palette <- brewer.pal(n = 9, name = "YlOrRd")

pal <- colorRampPalette(c("white", "brown"))

########  IDW  ##########################################################
# Create new columns for lat and long
lakes.dat$x <- lakes.dat$long  
# define x & y as longitude and latitude - not really necessary
# could just do with Long Lat in the next line
lakes.dat$y <- lakes.dat$lat 

# Designate x and y columns as coordinates
coordinates(lakes.dat) = ~x + y

# Create a data frame from all combinations of the supplied vectors or factors.
grd <- expand.grid(x = seq(from = x.range[1], to = x.range[2], by = 0.1), 
                   y = seq(from = y.range[1], to = y.range[2], by = 0.1)) 
coordinates(grd) <- ~x + y
gridded(grd)     <- TRUE

# Plot the points and grid
# plot(grd, cex = 1.5, col = "grey")
# points(lakes.dat, pch = 1, col = "red", cex = 1)

############  CONDUCTIVITY  ###################################################
# Make a new df with no NAs for conductivity
lakes.con <- lakes.dat[complete.cases(lakes.dat$conductivity),]

# Apply the IDW
idw <- idw(formula = conductivity ~ 1, locations = lakes.con, newdata = grd)
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.cond <- mask(idw.ras, us.unproj.nation)
plot(us.cond)

plot(us.cond, xaxt="n", yaxt = "n")
axis(1, xaxp=c(10, 200, 19), las=2)
axis(1, at = seq(10, 200, by = 10), las=2)

# Reproject the raster in the us.atlas projection
us.cond <- projectRaster(us.cond, crs = us.atlas.proj, over = T)
plot(log(us.cond), col = pal(255), axes = F, box = F, legend = F)
plot(log(us.cond), legend.only = T, col = pal(255), 
     smallplot = c(.755, .78, .4, .65), 
     legend.args = list(text =  "log(conductivity)", side = 4, font = 2, 
                        line = 2, cex = .8))   
# terrain.colors(255))  # rev(heat.colors(255))
title("Conductivity", line =  -2)
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)

plot(us.cond, add = T)

# this will get the right axes
# plot(us.unproj.nation, axes = TRUE, border = "white") 
# Something like this in the plot of the raster might get the right axis labels
# Would set the seq using meters, but then make the labels degrees.
# axis.args=list(at=seq(r.range[1], r.range[2], 25), 
# labels=seq(r.range[1], r.range[2], 25), cex.axis=0.6),

############  ALKALINITY ######################################################
lakes.alk <- lakes.dat[complete.cases(lakes.dat$alkalinity),]

idw     <- idw(formula = alkalinity ~ 1, locations = lakes.alk, 
               newdata = grd)  
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
# plot(idw.ras)

# Crop the data to the US outline
us.alk <- mask(idw.ras, us.unproj.nation)
# plot(us.alk)

savepdf("alkalinity", 5, 4.7)
us.alk <- projectRaster(us.alk, crs = us.atlas.proj, over = T)
plot(log(us.alk), col = pal(255), axes = F, box = F, legend = F)
plot(log(us.alk), legend.only = T, col = pal(255), 
     smallplot = c(.755, .78, .4, .65), 
     legend.args = list(text =  "log(alkalinity)", side = 4, font = 2, 
                        line = 2, cex = .8))
# title("Alkalinity", line = -2)
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)
dev.off()
system("pdfcrop 06_images/alkalinity.pdf")
unlink("06_images/alkalinity.pdf")

############  SECCHI  #########################################################
lakes.sec <- lakes.dat[complete.cases(lakes.dat$secchi),]

idw <- idw(formula = secchi ~ 1, locations = lakes.sec, newdata = grd)
idw.ras <- raster(idw)

proj4string(idw.ras) <- wgs1984.proj

us.sec <- mask(idw.ras, us.unproj.nation)
# plot(us.sec)

savepdf("secchi", 5, 4.7)
us.sec <- projectRaster(us.sec, crs = us.atlas.proj, over = T)
plot(log(us.sec), col = pal(255), axes = F, box = F, legend = F)
plot(log(us.sec), legend.only = T, col = pal(255), 
     smallplot = c(.755, .78, .4, .65), 
     legend.args = list(text =  "log(meters)", side = 4, font = 2, 
                        line = 2, cex = .8))
# title("Secchi", line =  -2)
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)
dev.off()
system("pdfcrop 06_images/secchi.pdf")
unlink("06_images/secchi.pdf")

############  TOTAL_P  ########################################################
# Make a new df with no NAs for conductivity
lakes.p.total <- lakes.dat[complete.cases(lakes.dat$p_total),]

# Apply the IDW
idw <- idw(formula = p_total ~ 1, locations = lakes.p.total, newdata = grd)  
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
# plot(idw.ras)

# Crop the data to the US outline
us.p.total <- mask(idw.ras, us.unproj.nation)
# plot(us.p.total)

# Reproject the raster in the us.atlas projection
us.p.total <- projectRaster(us.p.total, crs = us.atlas.proj, over = T)
plot(log(us.p.total), col = pal(255), axes = F, box = F, legend = F)
plot(log(us.p.total), legend.only = T, col = pal(255), 
     smallplot = c(.755, .78, .4, .65), 
     legend.args = list(text =  "log[P]", side = 4, font = 2, line = 2, 
                        cex = .8)) 
title("P_Total", line =  -2)
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)


############  TOTAL_N  ########################################################
# Make a new df with no NAs for conductivity
lakes.n.total <- lakes.dat[complete.cases(lakes.dat$n_total),]

# # If you want the log values:
# lakes.n.total$n_total <- abs(lakes.n.total$n_total)
# lakes.n.total$n_total <- log10(lakes.n.total$n_total)

# Apply the IDW
idw <- idw(formula = n_total ~ 1, locations = lakes.n.total, newdata = grd)  
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.n.total <- mask(idw.ras, us.unproj.nation)
plot(us.n.total)

# Reproject the raster in the us.atlas projection
us.n.total <- projectRaster(us.n.total, crs = us.atlas.proj, over = T)
plot(log(us.n.total), col = pal(255), axes = F, box = F, legend = F)
plot(log(us.n.total), legend.only = T, col = pal(255), 
     smallplot = c(.755, .78, .4, .65), 
     legend.args = list(text =  "log[N]", side = 4, font = 2, line = 2, 
                        cex = .8)) 
title("N_Total", line =  -2)
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)

###################  REGION MAP  ##############################################
lat.col <- which(colnames(lakes.dat) == "lat")
long.col <- which(colnames(lakes.dat) == "long")

lakes <- SpatialPoints(coords = na.omit(lakes.dat[,c(long.col, lat.col)]), 
                       proj4string=wgs1984.proj)

lakes.equal <- spTransform(lakes, us.atlas.proj)

rgbbPal <- colorRampPalette(c('#a6cee3', '#1f78b4', '#b2df8a', '#33a02c'))

lakes.dat$Col   <- rgbbPal(4)[as.numeric(cut(lakes.dat$pdf,breaks = 4))]
lakes.dat$shape <- as.numeric(cut(lakes.dat$pdf,breaks = 4))

savepdf("points_regions", width = 5, height = 4.7)
plot(us.n.total, legend = FALSE, axes = F, box = F)
plot(us.48, add = TRUE, col = "white")
points(lakes.equal, cex = .5, col = lakes.dat$Col, pch = lakes.dat$shape)
legend(x = 2500000, y = 1, 
       legend = c("Northeastern", "Southeastern", "Central", "Western"), 
       bty = "n", col = c('#a6cee3', '#1f78b4', '#b2df8a', '#33a02c'), 
       pch = c(1, 2, 3, 4), title = "Regions", xpd = TRUE, title.adj = 0.39)
dev.off()
system("pdfcrop 06_images/points_regions.pdf")
unlink("06_images/points_regions.pdf")
