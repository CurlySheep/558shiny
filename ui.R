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
              column(6,
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
                         h4("")
                        )
                    ),
              
              # How to Use
              column(6,
                     h1("How to Use"),
                     
                     # Box
                     box(width = 12,
                         h4("The controls for the app are located to the left and the visualizations 
                            are available on the right.")
                         )
                    ),

              # Data Source
              column(6,
                     h1("Source"),
                     box(width = 12,
                         h4("I collected these data from many sources last year, when the 
                            epidemic broke out in China at the begining of 2020. The number of confirmed cases came from
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
              h1("Test")
              
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