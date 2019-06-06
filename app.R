library(shiny)
library(ggplot2)
library(dplyr)

names <- source("private/names.r")[[1]]
df <- readRDS("message_data.RDS")

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("The Baby Schedule"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("weeks",
                     "Weeks to show:",
                     min = min(df$week),
                     max =  max(df$week),
                     value = c(min, max)),
         
         checkboxInput("showBaby1", "Baby1", value = TRUE),
         checkboxInput("showBaby2", "Baby2", value = TRUE)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("timePlot")
      )
   )
)

# server logic
server <- function(input, output) {
  
  output$timePlot <- renderPlot({
    ggplot(data = df %>% 
             filter(week %in% input$weeks[1]:input$weeks[2]) %>% 
             { if(!input$showBaby1) filter(., baby != names[1]) else . } %>% 
             { if(!input$showBaby2) filter( ., baby != names[2] ) else . },
           aes(xmin = start_time, xmax = end_time, ymin = ymin, ymax = ymax, fill = factor(event))) +
      geom_rect(alpha = 0.5) +
      facet_grid(day ~ week) +
      theme(axis.text.y = element_blank(), axis.ticks = element_blank())
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)