library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)

dashboardPage(skin = "red",
  
  # Add Title
  dashboardHeader(title = "The Impact of Air Pollution on the Spread of COVID-19 in China", titleWidth = 800),
  
  # Define Sidebar Items
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "Tab1"),
    menuItem("Data", tabName = "Tab2"),
    menuItem("Data Exploratin", tabName = "Tab3"),
    menuItem("Modeling", tabName = "Tab4")
  )),
  
  # Define the Body of the APP
  dashboardBody(
    tabItems(
      
      #####################First Tab Content####################
      tabItem(tabName = "Tab1",
              
              # Describe the Purpose
              column(4,
                     h1("Brief Introduction"),
                
                     # Box to Contain Description
                     box(width=12,
                         h4("This application want to study several meteorological factors 
                            and air quality indicators between 5 cities in China, and 
                            conducts modelling analysis on whether the transmission of COVID-19
                            is affected by atmosphere."),
                         h4("The number of confirmed cases reported by Health Commision of Wenzhou,
                            Shanghai, Hangzhou, Xinyang, Hefei from 2020/1/20 to 2020/2/14 (26days in total) 
                            are collected."),
                         h4("AQI (Air quality index) along with 7 meteorological numerics PM2.5, PM10, SO2,
                            CO, NO2, O3 and temperature were collected. Note that AQI can seen as a piecewise linear function 
                            of the pollutant concentratin."),
                         h4(uiOutput("link7"))
                        )
                    ),
              
              # How to Use
              column(4,
                     h1("How to Use"),
                     
                     # Box
                     box(width = 12,
                         h4("The controls for the app are located to the left and the visualizations 
                            are available on the right.")
                         )
                    ),

              # Data Source
              column(4,
                     h1("Source"),
                     box(width = 12,
                         h4("The number of confirmed cases came from
                            the Health Commission websites of the 5 cities, and the weather data came from
                            a web site called Weather Underground. Here's the link:"),
                         h4(uiOutput("link1")),
                         h4(uiOutput("link2")),
                         h4(uiOutput("link3")),
                         h4(uiOutput("link4")),
                         h4(uiOutput("link5")),
                         h4(uiOutput("link6"))
                         )
                     ),
              
              
              # Add Picture
              
              shiny::img(src="wikiimage.jpg", height = '500px')
              
              
              ),
      
      #####################Second Tab Content####################
      tabItem(tabName = "Tab2",
              
              # Subset rows by city
              column(6,
                     h4("You can subset the data by cities below:"),
                     selectInput(inputId = "city_selecte",
                                 label = "Choose one city to summarize (Default shows all 5 cities)",
                                 choices = c("All", "Wenzhou", "Shanghai", "Hangzhou", "Xinyang", "Hefei")
                     )
                     ),
              
              # Select variables
              column(6,
                     h4("You can subset the data by variables below (multiple choices):"),
                     selectInput(inputId = "var_selecte",
                                 label = "Choose variables to summarize (can't ignore city and date)",
                                 choices = names(air_data)[-c(1:2)], multiple = T
                     )
                     ),
              
              # Provide download button
              downloadButton(outputId = "down_dat", label = "Download the data"),
              
              
              # Show the data frame
              dataTableOutput("dataf"),
              
              h1("Variables explanation"),
              
              # Provide variables explanation
              column(6,

                     box(width = 12,
                         h6("City: The abbreviation of city name. HF for Hefei, HZ for Hangzhou, SH for Shanghai, 
                            WZ for Wenzhou and XY for Xinyang."),
                         h6("Date: Recorded date."),
                         h6(p("AQI: Air quality index. See details at the ",
                              strong("About"), " page.")),
                         h6("Level: Air quality level grouped by AQI, ranged form 1 to 4. 1 for the best air 
                            quality and 4 for the worest."),
                         h6("PM2.5: Numeric variable for PM2.5."),
                         h6("PM10: Numeric variable for PM10."),
                         h6("SO2: Numeric variable for SO2."), height = 200
                     )
              ),
              column(6,
                     box(width = 12,
                         h6("CO: Numeric variable for CO."),
                         h6("NO2: Numeric variable for NO2"),
                         h6("O3_8h: Numeric variable for O3"),
                         h6("new: Reported number of confirmed cases for that day."),
                         h6("new_no_HB: Reported number of confirmed cases without sojourn history for Hubei. 
                            Note that Hubei is the first city which burst the epedamic in China."),
                         h6("high_tem: The highest temperature."),
                         h6("low_tem: The lowest temperature."), height = 200
                         )
                     )
              
            
              
              ),
      
      #####################Third Tab Content####################
      tabItem(tabName = "Tab3",
              h1("Test")
              
      ),
      
      #####################Forth Tab Content####################
      tabItem(tabName = "Tab4",
              h1("Test")
              
              )
    )
  )
)