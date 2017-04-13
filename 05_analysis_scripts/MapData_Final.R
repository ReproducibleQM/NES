# DESCRIPTION
# This code reads in the Eutrification data table, downloads US base maps and projects
# the data points and data values, using inverse distance weighting (IDW) for the latter. 

# Written by Ryan Nagelkirk
# Date: 20170413


# Load Libraries
library(downloader)
library(rgdal)
library(sp)
library(maptools)
library(ggplot2)
library(gstat)
library(raster)
library(tmap)



# Read in the file
lakes.dat <- read.csv("./nes_data.csv")

# Remove any rows with NA coordinates
lakes.dat <- subset(lakes.dat, !is.na(Lat))
lakes.dat <- subset(lakes.dat, !is.na(Long))
which(is.na(lakes.dat$Lat) == TRUE) # This should now be zero
which(is.na(lakes.dat$Lat) == TRUE) # This should now be zero

# Make the longitudes negative if they aren't already
for(i in 1:nrow(lakes.dat)){
  if(lakes.dat$Long[i] > 0){
    lakes.dat$Long[i] <- -lakes.dat$Long[i]
  } 
}

# Map the US
# CRS for the US National Atlas Map
us.atlas.proj <- CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")
# CRS for the US in WGS 1984 (world geographic 1984)
wgs1984.proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


# Download US map
download("http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_state_20m.zip", dest="us_states.zip", mode="wb") 
download("http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_nation_20m.zip", dest="us_nation.zip", mode="wb") 
unzip ("us_states.zip", exdir = ".")
unzip("us_nation.zip", exdir = ".")

# read in the shapefile
us.states <- readShapePoly("cb_2014_us_state_20m.shp")
us.nation <- readShapePoly("cb_2014_us_nation_20m.shp")
# Extract the US without Hawaii, Alaska or Puerto Rico
us.49 <- us.states[us.states$NAME != "Hawaii",]
us.48 <- us.49[us.49$NAME != "Alaska",]
us.48 <- us.48[us.48$NAME != "Puerto Rico",]


# Crop the nation map to the extent of the state map
us.nation <- crop(us.nation, us.48)
us.unproj.nation <- us.nation # keep a copy for cropping the raster later

# Define the extent of the map (will use for creating IDW grid later)
x.range <- as.numeric(us.48@bbox[1,])  # min/max longitude of the interpolation area
y.range <- as.numeric(us.48@bbox[2,])  # min/max latitude of the interpolation area


# Project us.48, but not usr.48
proj4string(us.48) <- wgs1984.proj
proj4string(us.nation) <- wgs1984.proj
us.48 <- spTransform(us.48, us.atlas.proj)
us.nation <- spTransform(us.nation, us.atlas.proj)
plot(us.48)
plot(us.nation)



########  IDW  ##########################################################
# Create new columns for lat and long
lakes.dat$x <- lakes.dat$Long  # define x & y as longitude and latitude - not really necessary...could just do with Long Lat in the next line
lakes.dat$y <- lakes.dat$Lat 

# Designate x and y columns as coordinates
coordinates(lakes.dat) = ~x + y

# Create a data frame from all combinations of the supplied vectors or factors.
grd <- expand.grid(x = seq(from = x.range[1], to = x.range[2], by = 0.1), y = seq(from = y.range[1], to = y.range[2], by = 0.1))  # expand points to grid
coordinates(grd) <- ~x + y
gridded(grd) <- TRUE

# Plot the points and grid
plot(grd, cex = 1.5, col = "grey")
points(lakes.dat, pch = 1, col = "red", cex = 1)


############  CONDUCTIVITY  ############################################################
# Make a new df with no NAs for conductivity
lakes.con <- lakes.dat[complete.cases(lakes.dat$conductivity),]

# Apply the IDW
idw <- idw(formula = conductivity ~ 1, locations = lakes.con, newdata = grd)  # apply idw model for the data
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.cond <- mask(idw.ras, us.unproj.nation)
plot(us.cond)

# Reproject the raster in the us.atlas projection
us.cond <- projectRaster(us.cond, crs = us.atlas.proj, over = T)
plot(us.cond, main = "Conductivity")
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)

# plot(us.unproj.nation, axes = TRUE, border = "white") # this will get the right axes


############  ALKALINITY ############################################################

# Make a new df with no NAs for conductivity
lakes.alk <- lakes.dat[complete.cases(lakes.dat$alkalinity),]

# Apply the IDW
idw <- idw(formula = alkalinity ~ 1, locations = lakes.alk, newdata = grd)  # apply idw model for the data
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.alk <- mask(idw.ras, us.unproj.nation)
plot(us.alk)

# Reproject the raster in the us.atlas projection
us.alk <- projectRaster(us.alk, crs = us.atlas.proj, over = T)
plot(us.alk, main = "Alkalinity")
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)


############  SECCHI  ############################################################
# Make a new df with no NAs for conductivity
lakes.sec <- lakes.dat[complete.cases(lakes.dat$sechhi),]

# Apply the IDW
idw <- idw(formula = sechhi ~ 1, locations = lakes.sec, newdata = grd)  # apply idw model for the data
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.sec <- mask(idw.ras, us.unproj.nation)
plot(us.sec)

# Reproject the raster in the us.atlas projection
us.sec <- projectRaster(us.sec, crs = us.atlas.proj, over = T)
plot(us.sec, main = "Secchi")
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)


############  TOTAL_P  ############################################################
# Make a new df with no NAs for conductivity
lakes.p.total <- lakes.dat[complete.cases(lakes.dat$p_total),]

# Apply the IDW
idw <- idw(formula = p_total ~ 1, locations = lakes.p.total, newdata = grd)  # apply idw model for the data
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.p.total <- mask(idw.ras, us.unproj.nation)
plot(us.p.total)

# Reproject the raster in the us.atlas projection
us.p.total <- projectRaster(us.p.total, crs = us.atlas.proj, over = T)
plot(us.p.total, main = "P_Total")
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)


############  TOTAL_N  ############################################################
# Make a new df with no NAs for conductivity
lakes.n.total <- lakes.dat[complete.cases(lakes.dat$n_total),]

# # If you want the log values:
# lakes.n.total$n_total <- abs(lakes.n.total$n_total)
# lakes.n.total$n_total <- log10(lakes.n.total$n_total)

# Apply the IDW
idw <- idw(formula = n_total ~ 1, locations = lakes.n.total, newdata = grd)  # apply idw model for the data
idw.ras <- raster(idw)

# Rasterize and crop the IDW (might not be needed)
proj4string(idw.ras) <- wgs1984.proj
plot(idw.ras)

# Crop the data to the US outline
us.n.total <- mask(idw.ras, us.unproj.nation)
plot(us.n.total)

# Reproject the raster in the us.atlas projection
us.n.total <- projectRaster(us.n.total, crs = us.atlas.proj, over = T)
plot(us.n.total, main = "N_Total")
plot(us.48, add = T, border = "gray")
plot(us.nation, add = TRUE)



###################  REGION MAP  #########################################################
# Get the lat and long column numbers
lat.col <- which(colnames(lakes.dat) == "Lat")
long.col <- which(colnames(lakes.dat) == "Long")

# Make points out of the lake locations 
lakes <- SpatialPoints(coords=na.omit(lakes.dat[,c(long.col, lat.col)]), proj4string=wgs1984.proj)
# Reproject
lakes.equal <- spTransform(lakes, us.atlas.proj)

# Make color palatte
rgbbPal <- colorRampPalette(c('red', 'green', 'blue', 'black'))

# Break into 4 colors...should be able to do this another way
lakes.dat$Col <- rgbbPal(4)[as.numeric(cut(lakes.dat$Pdf,breaks = 4))]

# Plot the points
plot(us.n.total, legend = FALSE)
plot(us.48, add = TRUE, col = "white")
points(lakes.equal, cex = .5, col = lakes.dat$Col)
