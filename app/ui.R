
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


# Define UI
ui <- fluidPage(
  navbarPage(
    title = "COVID-19 Cases Comparison",
    
    # Page 1: Heatmap of COVID-19 Cases
    tabPanel("COVID-19 Cases Heatmap",
             titlePanel("COVID-19 Cases Heatmap"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("stateSelect", 
                             "Select State(s):", 
                             choices = unique(data_df$state), 
                             selected = NULL, 
                             multiple = TRUE),
                 checkboxInput("weekend", "Compare by Weekends", value = FALSE)
               ),
               mainPanel(
                 leafletOutput("map")
               )
             )
    ),
    
    # Page 2: Comparison of COVID Cases Over Time
    tabPanel("COVID Cases Over Time",
             titlePanel("COVID Cases Over Time by State"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("stateSelectTime", 
                             "Select State(s):", 
                             choices = unique(data_df$state), 
                             selected = NULL, 
                             multiple = TRUE),
                 checkboxInput("weekendTime", "Compare by Weekends", value = FALSE)
               ),
               mainPanel(
                 plotOutput("timeComparisonPlot")
               )
             )
    ),
    
    # Page 3: Comparison of Total COVID Cases by State
    tabPanel("Total Cases by State",
             titlePanel("Total COVID Cases by State"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("stateSelectTotal", 
                             "Select State(s):", 
                             choices = unique(data_df$state), 
                             selected = NULL, 
                             multiple = TRUE)
               ),
               mainPanel(
                 plotOutput("stateComparisonPlot")
               )
             )
    ),
    
    # Page 4: Dominant Disaster Type by State
    tabPanel("Dominant Disaster Type",
             titlePanel("Dominant Disaster Type by State"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("incidentTypeSelect", 
                             "Select Incident Type:", 
                             choices = unique(data_og$incidentType), 
                             selected = "Biological")
               ),
               mainPanel(
                 leafletOutput("mapDisaster")
               )
             )
    )
  )
)
