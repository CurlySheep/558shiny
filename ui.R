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
              h1("Test")
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