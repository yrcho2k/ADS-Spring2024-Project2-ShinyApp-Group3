#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
###############################Install Related Packages #######################
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("readr")) {
  install.packages("readr")
  library(readr)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("leaflet.extras")) {
  install.packages("leaflet.extras")
  library(leaflet.extras)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}


# Define server logic
server <- function(input, output) {
  
  # Filtered data reactive expression for COVID-19 cases
  filteredData <- reactive({
    data <- data_df
    if(input$weekend) {
      # Filter for weekends
      data <- data %>% mutate(weekday = weekdays(DeclarationDate)) %>%
        filter(weekday %in% c('Saturday', 'Sunday'))
    }
    
    if(!is.null(input$stateSelect)) {
      # Filter for selected states
      data <- data %>% filter(state %in% input$stateSelect)
    }
    
    data
  })
  
  # Heatmap render for COVID-19 cases
  output$map <- renderLeaflet({
    req(filteredData())  # Ensure filteredData is available before rendering
    
    # Plotly heatmap for COVID-19 cases
    leaflet(data = filteredData()) %>%
      addTiles() %>%
      addHeatmap(lng = ~longitude, lat = ~latitude, intensity = ~cases,
                 blur = 20, max = 0.05, radius = 15) %>%
      setView(lng = -95.7129, lat = 37.0902, zoom = 4) # Center of the USA
  })
  
  # Plot for comparing COVID-19 cases over time
  output$timeComparisonPlot <- renderPlot({
    data <- filteredData()
    ggplot(data, aes(x = DeclarationDate, y = cases, group = state, color = state)) +
      geom_line() +
      labs(title = "COVID Cases Over Time by State", x = "Date", y = "Number of Cases") +
      theme_minimal()
  })
  
  # Plot for comparing total COVID-19 cases by state
  output$stateComparisonPlot <- renderPlot({
    data <- filteredData() %>%
      group_by(state) %>%
      summarize(totalCases = sum(cases))
    ggplot(data, aes(x = reorder(state, totalCases), y = totalCases, fill = state)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Total COVID Cases by State", x = "State", y = "Total Cases") +
      theme_minimal()
  })
  
  # Filter data for selected incident type
  filtered_data <- reactive({
    data_og %>%
      filter(incidentType == input$incidentTypeSelect)  
  })
  
  # Aggregate data to find dominant disaster type for each state
  dominant_disaster <- reactive({
    filtered_data() %>%
      group_by(state, incidentType) %>%
      summarise(count = n()) %>%
      arrange(state, desc(count)) %>%
      slice(1)  # Get the dominant disaster type for each state
  })
  
  # Create geographic visualization for dominant disaster type
  output$mapDisaster <- renderLeaflet({
    leaflet(data = dominant_disaster()) %>%
      addTiles() %>%
      addMarkers(data = dominant_disaster(), 
                 lng = data_df$longitude, 
                 lat = data_df$latitude, 
                 popup = ~paste(state, "<br>", incidentType, "<br>", count))
  })
}
