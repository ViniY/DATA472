#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
library(leaflet)
library(shinydashboard)

guns<-readRDS("/Users/vini/Desktop/2021T1/DATA472/Assignments/Project/gunsMerged.rds")

header <- dashboardHeader(title = "Gun voilence in the US 2013-2017 (With US GDP by States)", titleWidth=500)


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(h4("Dashboard"), tabName = "dashboard"),
  hr(),
  h5("The default dates cover the full date range available.
     If you change the start or end date,
     the graphs will be refreshed for the selected date range", align="center"),
  dateRangeInput(inputId = "start",
                 label = "Select period",
                 start = min(guns$date),
                 end = max(guns$date),
                 min = min(guns$date),
                 max = max(guns$date))
  )
)
body<-(
  tabItems(
    tabItem(tabName= "dashboard",
            fluidRow(
              tabBox(id = "erik", width=12, height=700,
                     tabPanel("Map",
                              br(),
                              fluidRow(h4("By hovering over the map, a label shows up which shows the name of the state and the number of incidents per 100,000 inhabitants in the selected period.
                                          In addition, you can zoom in or out. By zooming out, Alaska and Hawaii also become visible.
                                          Please note that the range in the legend also gets updated after a new date selection.", align='left')),
                              br(),
                              fluidRow(leafletOutput("usmap", height=700))),
                     tabPanel("Bar chart",
                              br(),
                              h4("Within the selected period, you can specify how many states you want
                                 to display in the bar charts. By hovering over the charts, a label shows up which shows the exact number of incidents in the selected period.", align="left"),
                              sliderInput(inputId = "num",
                                          label = "Choose Top N states with most incidents",
                                          value = 10,
                                          min = 1,
                                          max = (n_distinct(guns$state)-1)),
                              fluidRow(plotlyOutput("plot1")),
                              fluidRow(plotlyOutput("plot2"))),
                     tabPanel("Table",
                              br(),
                              fluidRow(h4("The default sort of this table is by descending number of incidents per 100,000 inhabitants in the selected period (column Per100k).", align='left')),
                              br(),
                              fluidRow(DT::dataTableOutput(outputId="table"))))
              
                              )
            )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')
   })
}


ui <- dashboardPage(header, sidebar,body)


# Run the application 
shinyApp(ui = ui, server = server)

