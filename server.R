library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  #####################Read in Data####################
  InputTable <- reactive({
    
    #Air Data
    air_data = read.csv("air_polution.csv", header = TRUE,encoding = "UTF-8")
    air_data$level <- as.factor(air_data$level)
    
    #Change the City name from Chinese character to English
    names(air_data)[1] <- "city"
    air_data$city <- c(rep("WZ", 26), rep("SH",26), rep("HZ", 26), rep("XY", 26), rep("HF", 26))
    
    #return(list(air_data = air_data))
    return(air_data)
  })
 
  #####################Create URL Links####################
  output$link1 <- renderUI({
    tagList("Health Commission of Wenzhou:", a("Note that all the Health Commission websites are in Chinese", href="http://wjw.wenzhou.gov.cn/"))
  })
  
  output$link2 <- renderUI({
    tagList("Shanghai Municipal Health Commission:", a("Click here!", href="https://wsjkw.sh.gov.cn/"))
  })
  
  output$link3 <- renderUI({
    tagList("Hangzhou Municipal Health Commission:", a("Click here!", href="http://wsjkw.hangzhou.gov.cn/"))
  })
  
  output$link4 <- renderUI({
    tagList("Xinyang Health Commission:", a("Click here!", href="http://wsjkw.xinyang.gov.cn/index.html"))
  })
  
  output$link5 <- renderUI({
    tagList("Hefei Municipal Health Commission:", a("IPs outside of the Mainland China may be banned from accessing this website and I don't know why", href="http://wjw.hefei.gov.cn/"))
  })
  
  output$link6 <- renderUI({
    tagList("Weather Underground:", a("The only website in English!", href="https://www.wunderground.com/"))
  })
  
  
  
  
})