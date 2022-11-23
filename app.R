library(shiny)
library(maps)
library(stringr)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(geobr)
library(magrittr)

#Getting data

wildfiresBz <- data.frame(read.csv("wildfiresBz.csv"))

map.data <- map_data("world")
br <- read_state()
deforest_2021 <- data.frame(read.csv("deforest_2021.csv"))
br %<>% left_join(deforest_2021)
#sidebar
year_sidebar <- sidebarPanel(
  sliderInput("YearSelect", "Select the corresponding year:",
              min = as.numeric(2011), max = as.numeric(2021),
              value = as.numeric(2020), sep = "", step = 1))

#main panel
plot_brazil <- mainPanel(plotOutput(outputId = "wildfire_plot"))




#UI

ui <- 
  fluidPage(titlePanel("Incidence of Wildfires in Brazil"), year_sidebar, plot_brazil)                


# Define server logic required
server <- function(input, output) {
  
  filter_year <- reactive({
    wildfiresBz %>%  filter(wildfiresBz$year == input$YearSelect)
  })

  output$wildfire_plot <- renderPlot({
    df <- data.frame(filter_year())
    ggplot() +
      geom_sf(data = br, aes(fill= Deforestation_ratio), color= "white", size=.15) +
      scale_fill_gradient( low = "darkseagreen3" , high = "black", name = 'Deforestation ratio')+
      geom_point(data = df, aes(x = longitude, y = latitude, color = "red"), 
                 show.legend = FALSE, size = 0.01, alpha = 0.02) +
      theme(axis.line = element_blank(), 
            axis.text = element_blank(), 
            axis.ticks = element_blank(), 
            axis.title = element_blank(), 
            panel.background = element_rect(fill = "white", color = NA), 
            panel.border = element_blank(), 
            panel.grid.major = element_blank(), 
            panel.grid.minor = element_blank(),
            )
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)