# load libraries
library(rgdal)
library(dplyr)
library(ggplot2)

# import the Data
url <- "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip"
file <- basename(url) 
download.file(url, file)

# read the data
clients <- read.csv("clients.csv")

world <- readOGR(dsn = folder, 
                 layer = "ne_50m_admin_0_countries",
                 encoding = "latin1", #you may need to use a different encoding
                 verbose = FALSE)

# inspect the data
str(clients)
head(clients)

clients$region <- clients$country %>%
  toupper() %>%
  countrycode("iso2c", "country.name") %>%
  tolower()

head(clients)

# create some basic stats
avg <- clients %>%
  group_by(region) %>%
  summarise(value=mean(clients, na.rm=TRUE))

country_choropleth(na.omit(avg))

