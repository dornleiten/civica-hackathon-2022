 # CIVICA's Hackaton

library(ggplot2)
library(maps)
library(plotly)
library(openxlsx)
library(geobr)

setwd("/Users/luchobarajas/Documents/ASDS/CIVICA Hackaton/")

wildfiresBz = read.csv("modis_2021_Brazil.csv", sep = ";")


map.data <- map_data("world")


br = read_state()
deforest = read.xlsx("BRA.xlsx", sheet = 4)
deforest_2021 = deforest %>% select(name_state = subnational1, area = extent_2010_ha, threshold, 
                                    deforestation_2021 = tc_loss_ha_2021) %>% 
  filter(threshold == 10) %>% select(-threshold) %>% mutate(Def_ratio =deforestation_2021 / area)

deforest_2021 %<>% mutate(name_state = if_else(name_state == "Rio Grande do Norte","Rio Grande Do Norte", name_state))
deforest_2021 %<>% mutate(name_state = if_else(name_state == "Rio Grande do Sul","Rio Grande Do Sul", name_state))
deforest_2021 %<>% mutate(name_state = if_else(name_state == "Espírito Santo","Espirito Santo", name_state))
deforest_2021 %<>% mutate(name_state = if_else(name_state == "Rio de Janeiro","Rio De Janeiro", name_state))
deforest_2021 %<>% mutate(name_state = if_else(name_state == "Mato Grosso do Sul","Mato Grosso Do Sul", name_state))



br %<>% left_join(deforest_2021)

ggplot()+
  geom_sf(data = br, aes(fill= Def_ratio), color= "white", size=.15, show.legend = FALSE) +
  scale_fill_gradient( low = "green" , high = "black")+
  geom_point(data = wildfiresBz, aes(x = longitude, y = latitude, color = "firebrick1"), show.legend = FALSE, size = 0.01,
          alpha = 0.10) + 
  theme(axis.line = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(), 
        panel.background = element_rect(fill = "white", color = NA), 
        panel.border = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())
 


ggplot()+
  geom_sf(data = br, aes(fill= Def_ratio), color= "white", size=.15, show.legend = FALSE) +
 scale_fill_distiller(palette = "Spectral", name="Deforestation", limits = c(55,707681)) +
  geom_point(data = wildfiresBz, aes(x = longitude, y = latitude, color = "firebrick1"), show.legend = FALSE, size = 0.01,
             alpha = 0.10) + 
  theme(axis.line = element_blank(), 
        axis.text = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(), 
        panel.background = element_rect(fill = "white", color = NA), 
        panel.border = element_blank(), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank())
