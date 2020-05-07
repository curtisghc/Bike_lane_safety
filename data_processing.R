library(dplyr)
library(tidyr)

#functions
gps_to_decimal <- function(gps) {
  gps <- unlist(strsplit(gps, " "))
  deg <- as.numeric(gps[1])
  gps <- unlist(strsplit(gps[2], ":"))
  min <- as.numeric(gps[1])
  sec <- as.numeric(gps[2])
  
  dec <- deg + min/60 + sec/(60*60)
  return(dec)
}

negate <- function(n){
  return(-n)
}

#set directory and import data
setwd("~/Documents/mapping/final_project/data/")
crashes <- read.csv("crash_data_collision_crash_2013_2017_vz.csv", stringsAsFactors=FALSE)

#data operations
filtered <- crashes %>%
  #select(latitude, longitude, fatal, bicycle_count) %>%
  filter(bicycle_count > 0) #%>%
#  filter(fatal > 0)

filtered$latitude <- sapply(filtered$latitude, gps_to_decimal)
filtered$longitude <- filtered$longitude %>%
  sapply(gps_to_decimal) %>%
  sapply(negate)
  
#write.csv(filtered, "fatal.csv", row.names=FALSE)

