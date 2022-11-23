
library(shiny)
library(maps)
library(stringr)
library(shinythemes)
library(ggplot2)

#Getting data

filename <- c()
for (a in 2019) {
  filename <- append(filename, sprintf("modis_%g_Brazil.csv", a) )
}

wildfiresBz <- data.frame()
for(i in filename){
  new_df <- read.csv(i)[c(1, 2, 6)]
  wildfiresBz <- rbind(wildfiresBz, new_df)
}

wildfiresBz$year <- str_extract(wildfiresBz$acq_date, "[0-9]{4}")
wildfiresBz <- subset(wildfiresBz, select = -c(acq_date))

map.data <- map_data("world")

#UI

ui <- fluidPage(
    titlePanel("Brazil Fires"),
    navbarPage("Fire map",
               tabPanel("Mapplot",
                        mainPanel(plotOutput("mapplot")))))                


# Define server logic required
server <- function(input, output) {
  
  
  output$mapplot <- renderPlot({
    ggplot(map.data) + geom_map(aes(map_id = region), map = map.data, fill = "black", 
                                color = "white", size = 0.25) + expand_limits(x = map.data$long, y = map.data$lat) + 
      scale_x_continuous(limits=c(-75, -33)) + scale_y_continuous(limits = c(-37, 8)) +
      geom_point(data = wildfiresBz, aes(x = longitude, y = latitude, color = "red"), 
                 show.legend = FALSE, size = 0.01, alpha = 0.01) +
      theme(axis.line = element_blank(), 
            axis.text = element_blank(), 
            axis.ticks = element_blank(), 
            axis.title = element_blank(), 
            panel.background = element_rect(fill = "black", color = NA), 
            panel.border = element_blank(), 
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(), 
            plot.background = element_rect(fill= "black"))
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
