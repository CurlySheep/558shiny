library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(tidyverse)

shinyServer(function(input, output, session) {
  
  #####################Tag 1####################
  
  # Create URL links
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
  
  
  #####################Tag 2#####################
  
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
  
  
  
  
  #####################Tag 3#####################
  
  # Create subsetted data set
  Inputdata <- reactive({
    if(length(input$city_selecte_tag3)==0){return(air_data)}else{
      temp <- air_data %>%
        filter(city==input$city_selecte_tag3) %>%
        select(city, date, input$var_selecte_tag3)
      return(temp)
    }
  })
  
  # Draw the plot
  Outputplot <- reactive({
    if (input$plot_select=="Box plot"){
      gplot <- ggplot(data = Inputdata()) + geom_boxplot(aes(x=city,y=Inputdata()[,input$var_selecte_tag3])) +
        theme_bw() + labs(x='City',y=input$var_selecte_tag3)
    } else{
      if (input$plot_select=="Time series (line plot)"){
        gplot <- ggplot(data = Inputdata()) + geom_line(aes(x=date, y=Inputdata()[,input$var_selecte_tag3],
                                                            group=city,color=city),size=1.5) + 
          theme_bw() + labs(x='Date',y=input$var_selecte_tag3)
      } else{
        gplot <- ggplot(data = Inputdata()) + geom_bar(aes(x=date, y=Inputdata()[,input$var_selecte_tag3],
                                                           fill=city), stat = "identity", position = "dodge") +
          theme_bw() + labs(x='Date',y=input$var_selecte_tag3)
      }
    } 
    return(gplot)
  })
  
  # Output the plot
  output$plot_tag3 <- renderPlot({
    req(Outputplot())
    Outputplot()
  })
  
  # Download function
  output$down_plot <- downloadHandler(
    filename = function(){paste0("plot_tag3", ".png")},
    content = function(file){
      ggsave(file, plot = Outputplot())
    }
  )
  
  # Create summary table
  output$table_tag3 <- renderTable({
    tempvar <- quo(!!sym(input$var_selecte_tag3))  
    temp <- Inputdata() %>%
      select(city, !!tempvar) %>%
      group_by(city) %>%
      summarise(Min = min(!!tempvar), `1st Qu` = quantile(!!tempvar, 0.25) , Mean = mean(!!tempvar, na.rm=T),
                `3rd Qu` = quantile(!!tempvar, 0.75), Max = max(!!tempvar), inputqu = quantile(!!tempvar, input$perc))
    names(temp)[7] <- paste0(as.character(input$perc)," Qu")
    temp
  })
  
})