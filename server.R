library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(tidyverse)

shinyServer(function(input, output, session) {
  
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
  output$link7 <- renderUI({
    tagList("You can find detailed information about AQI here:", a("Wiki page.", href="https://en.wikipedia.org/wiki/Air_quality_index"))
  })
  
  
  #####################Create Data Frame for Tag 2#####################
  
  # Switch the input city
  cityinput <- reactive({
    switch(input$city_selecte,
           "All" = "All",
           "Hangzhou" = "HZ",
           "Shanghai" = "SH",
           "Hefei" = "HF",
           "Wenzhou" = "WZ",
           "Xinyang" = "XY")
  })
  
  # Create the data frame
  output$dataf <- renderDataTable({
    index <- cityinput()
    if (index == "All"){
      air_data %>%
        select(city, date, input$var_selecte) %>%
        datatable()
    } else{
      air_data %>%
        filter(city==index) %>%
        select(city, date, input$var_selecte) %>%
        datatable()
    }
  })
  
  # Create the download function
  output$down_dat <- downloadHandler(
    filename = function(){"Dataframe.csv"},
    content = function(fname){
      index <- cityinput()
      if (index == "All"){
        temp <- air_data %>%
          select(city, date, input$var_selecte)
        write.csv(temp, fname)
      } else{
        temp <- air_data %>%
          filter(city==index) %>%
          select(city, date, input$var_selecte)
        write.csv(temp, fname)
      }
    }
  )
  
  
  
})