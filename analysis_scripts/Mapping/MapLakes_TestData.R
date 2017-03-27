# Set the working directory
setwd("~/Dropbox/Permanent/Grad School/Classes/ReproducibleMethods/Lakes Work")

# Read in the file
lakes.dat <- read.csv("Maplakes.csv")


# Map the US
# CRS for the US National Atlas Map
us.atlas.proj <- CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs")
# CRS for the US in WGS 1984 (world geographic 1984)
wgs1984.proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


# Download US Regions map
download("http://www2.census.gov/geo/tiger/GENZ2014/shp/cb_2014_us_state_20m.zip", dest="us.zip", mode="wb") 
unzip ("us.zip", exdir = ".")
# read in the shapefile
usr <- readShapePoly("cb_2014_us_state_20m.shp")

# Set the projection
proj4string(usr) <- wgs1984.proj
usr.equal <- spTransform(usr, us.atlas.proj)
# Extract only the Northeast
us.49 <- usr.equal[usr.equal$NAME != "Hawaii",]
plot(us.49)

# Make the points 

lakes <- SpatialPoints(coords=lakes.dat[,c(5,4)], proj4string=wgs1984.proj)
# Reproject
lakes.equal <- spTransform(lakes, us.atlas.proj)

plot(us.49)
points(lakes.equal)

# Add the points with values for some variable (yet to be written)