library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output, session) {
  
  getData <- reactive({
    newData <- msleep %>% filter(vore == input$vore)
  })
  
  # Update Slideinput
  observeEvent(input$REM==TRUE, {
    updateSliderInput(session, inputId = "size", min = if(input$REM==F){1}else{3})
  })
  
  #create plot
  output$sleepPlot <- renderPlot({
    #get filtered data
    newData <- getData()
    
    #create plot
    g <- ggplot(newData, aes(x = bodywt, y = sleep_total))
    
    if(input$conservation){
      if (input$REM){
        g + geom_point(size = input$size, aes(col = conservation, alpha = sleep_rem))
      } else {
        g + geom_point(size = input$size, aes(col = conservation))
      }
    } else {
      g + geom_point(size = input$size)
    }
  })
  
  #create text info
  output$info <- renderText({
    #get filtered data
    newData <- getData()
    
    paste("The average body weight for order", input$vore, "is", round(mean(newData$bodywt, na.rm = TRUE), 2), "and the average total sleep time is", round(mean(newData$sleep_total, na.rm = TRUE), 2), sep = " ")
  })
  
  #create output of observations    
  output$table <- renderTable({
    getData()
  })
  
  # Title
  titleinput <- reactive({
    switch(input$vore,
           "carni" = "Carnivore",
           "herbi" = "Herbivore",
           "insecti" = "Insectivore",
           "omni" = "Omnivore")
  })
  output$tab <- renderUI({
    tagList("Investigation of ", titleinput(), " Mammal Sleep Data")
  })
  
})