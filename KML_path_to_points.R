#Reading kml path created on google earth and extracting coordinates to 
# make point lists

#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#*     Load packages
#* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
library(maps)
library(ggmap)
library(mapdata)
library(mapproj)
library(maptools)
library(RColorBrewer)
library(classInt)
library(rgdal)
library(scales)

#Setting up directory and file list
dirName <- "C:/Users/Toshiba/Documents/R-stat/Code01/points/"
fileList <- c(dir(dirName))
numFiles <- length(fileList)
#Reading coordinates from KML file created from paths
#  drawn in Google Earth
lon.kt <- numeric(0)
lat.kt <- numeric(0)
for (i in 1:numFiles) {
  dirTemp <- paste(dirName, fileList[i], sep="")
  kt <- getKMLcoordinates(dirTemp) #read kml file
  for (j in 1:(length(kt))) {
    rept <- length(unlist(kt[j]))/3
    tex <- unlist(kt[j])
    for (k in 1:rept) {
      lon.kt <- c(lon.kt, tex[k])
      lat.kt <- c(lat.kt, tex[k+rept])
    }
    
  }
}
path.df <- data.frame(lon.kt, lat.kt)
names(path.df) <- c("lon", "lat")
#Write extracted coordinates to a csv file
write.csv(path.df, file="C:/Users/Toshiba/Documents/R-stat/Code01/HousePoints.csv")
#Reading coordinates
path.df2 <- read.csv(file="C:/Users/Toshiba/Documents/R-stat/Code01/HousePoints.csv", header=TRUE)
path.df2 <- path.df2[,-1] #dropping first column
couleur <- brewer.pal(9, "PuRd")
#getting centroid
long.cen <- mean(path.df$lon)
lat.cen <- mean(path.df$lat)
dmk.map <- qmap(location=c(long.cen, lat.cen), zoom=13, maptype="satellite")
dmk.map + geom_point(aes(x = lon, y = lat), data = path.df, color = couleur[7])

