library(dplyr)
library(tidyr)

#set directory and import data
setwd("~/Documents/mapping/final_project/analysis/")
buffer_analysis_general <- read.csv("buffer_analysis_general_streets.csv", stringsAsFactors=FALSE)
buffer_analysis_bike_lanes <- read.csv("buffer_analysis_bike_lanes.csv", stringsAsFactors = FALSE)
bike_network <- read.csv("bike_network_export.csv", stringsAsFactors = FALSE)

#start by finding the general average for all streets
#density = incidents / length
buffer_analysis_general <- buffer_analysis_general %>%
  transform(density = count_vals / shape_length)
#print average density for all streets
general_density <- mean(buffer_analysis_general$density)
print(paste("General street bike accident density: ", toString(general_density)))

#now average density for bike laned streets, very similar operation to above
buffer_analysis_bike_lanes <- buffer_analysis_bike_lanes %>%
  transform(density = count_vals / shape_length)
#another print
bike_lane_density <- mean(buffer_analysis_bike_lanes$density)
print("Summary of adjusted bike lane accident density")
print(summary(buffer_analysis_bike_lanes$density))

#transform bike lane data to adjust for general density
#also add colmun for binary comparison
buffer_analysis_bike_lanes <- buffer_analysis_bike_lanes %>%
  transform(adjusted_density = density / general_density) %>%
  transform(binary_danger = ifelse(adjusted_density > 1, 1, 0))
print("Summary of adjusted bike lane accident density")
print(summary(buffer_analysis_bike_lanes$adjusted_density))
 
#final operation, do a join between bike lane buffer analysis and the original bike network data
#join based on the street name
joinable_bike_lanes_buffer_analysis <- buffer_analysis_bike_lanes %>%
  select(seg_id, count_vals, density, adjusted_density, binary_danger)

adjusted_bike_network <- inner_join(bike_network, joinable_bike_lanes_buffer_analysis)

write.csv(adjusted_bike_network, "adjusted_bike_network.csv", row.names = FALSE)
