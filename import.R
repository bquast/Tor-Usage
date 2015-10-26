# load libraries
library(rgdal)
library(dplyr)
library(ggplot2)
library(leaflet)

# import the Data
url <- "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"
file <- basename(url) 
download.file(url, file)
folder <- getwd()
unzip(file, exdir = folder)

# read the data
clients <- read.csv("clients.csv")

world <- readOGR(dsn = folder, 
                 layer = "ne_50m_admin_0_countries",
                 encoding = "latin1", #you may need to use a different encoding
                 verbose = FALSE)

# inspect the data
str(clients)
head(clients)

# create some basic stats
avg <- clients %>%
  group_by(country) %>%
  summarise(value=mean(clients, na.rm=TRUE))

avg$country %<>%
  toupper()

avg$country %<>%
  countrycode("iso2c", "iso3c")

avg %<>%
  na.omit()

avg2 <- merge(avg, world, by.x="country", by.y="adm0_a3")

new   <- merge(x = world,
               y = avg2,
               by.x = "adm0_a3",
               by.y = "country",
               all.x = TRUE)

pal <- colorQuantile("YlOrRd", NULL, n = 20)

leaflet(data = new) %>%
  addTiles() %>%
  addPolygons(fillColor = ~pal(world$pop_est))

