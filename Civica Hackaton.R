 # CIVICA's Hackaton

library(ggplot2)
library(maps)
library(plotly)
library(openxlsx)

setwd("/Users/luchobarajas/Documents/ASDS/CIVICA Hackaton/")

wildfiresBz = read.csv("modis_2021_Brazil.csv", sep = ";")


map.data <- map_data("world")

# To check max and min of longitude and latitude for setting scale below
# max(tweets$longitude)
# min(tweets$longitude)
# max(tweets$latitude)
# min(tweets$latitude)

# Now map using ggplot
# Set up map background using map.data data frame
B1 = ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "black", 
                            color = "white", size = 0.25) + expand_limits(x = map.data$long, y = map.data$lat) + 
  # Limits for x and y axis based on min and max of longitude and latitude
  scale_x_continuous(limits=c(-75, -33)) + scale_y_continuous(limits = c(-37, 8)) +
  # Adding the dot for each tweet and specifying dot size, transparency, and colour by language
  geom_point(data = wildfiresBz, aes(x = longitude, y = latitude, color = "red"), show.legend = FALSE, size = 0.01,
             alpha = 0.01) +
  # Removing unnecessary graph elements + changing background to black to match inspiratin from Pablo Barberá's twitter page
  theme(axis.line = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(), 
        panel.background = element_rect(fill = "black", color = NA), 
        panel.border = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        plot.background = element_rect(fill= "black")) +
  # Add title directly onto graph via annotate
  #annotate("text", x=-1, y=68, label="Tweets by Language", size=6, color = "white", fontface = 2)
  annotate("text", x=-1, y=68, label='underline("Tweets by Language")', parse = TRUE, size=6, color = "white")

B1

install.packages("geobr")
library(geobr)

br = read_state()
deforest = read.xlsx("BRA.xlsx", sheet = 4)
deforest_2021 = deforest %>% select(name_state = subnational1, deforestation_2021 = tc_loss_ha_2021)
