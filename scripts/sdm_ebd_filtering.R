### Filtering eBird dataset to observations within Seiur de Monts
### Schoodic Institute at Acadia National Park, 2023


#------------------------------------------------#
####           Packages Required              ####
#------------------------------------------------#
library(tidyverse)
library(sf)


#------------------------------------------------#
####        Cleaning and Filtering            ####
#------------------------------------------------#

## Read in the dataset and make all column names lowercase
ebd <- tibble(read.delim("ebd_US-ME-009_relAug-2023.txt", header = T, quote = "")) %>% 
  rename_with(tolower)


## Read in the SdM polygon
sdm.bounds <- sf::read_sf("polygon/sdm_biodiversity_polygon.shp")


## Create a new geometry column from the lat/long columns 
ebd2 <- ebd %>% 
  mutate(longitude.keep = longitude,
         latitude.keep = latitude) %>% 
  sf::st_as_sf(., coords = c("longitude","latitude"), crs = sf::st_crs(sdm.bounds))


## Filter data to observations only plotted within the SdM polygon and clean
output <- sf::st_join(ebd2, sdm.bounds, left = F) %>% 
  st_set_geometry(., NULL) %>% 
  dplyr::select(-c(`x`, Name:icon)) %>% 
  rename(latitude = latitude.keep, longitude = longitude.keep)


## Export as a CSV
write.csv(output, "sdm_ebd_2023.csv", row.names = F)



