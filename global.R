library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(highcharter)
library(tidyverse)

#####################Read in Data####################

  #Air Data
  air_data = read.csv("air_polution.csv", header = TRUE,encoding = "UTF-8")
  #air_data$level <- as.factor(air_data$level)
  
  #Change the City name from Chinese character to English
  names(air_data)[1] <- "city"
  air_data$city <- c(rep("WZ", 26), rep("SH",26), rep("HZ", 26), rep("XY", 26), rep("HF", 26))
  air_data[is.na(air_data)] <- 0
  
  #####################Function for highcharter plot#####################

  hc_plot <- function(data, secity, var){
    temp <- data %>%
      spread(city, var)
    th <- "hc_theme_google()"
    title <- var
    
    # Paste the command function
    command <- paste0("highchart() %>% hc_xAxis(categories = temp$date) %>% 
                    hc_add_theme(", th, ")  %>%  
                    hc_title(text = \"" ,title, "\", align = 'center', style = list(fontsize = \"40px\" ) ) ")
    
    for (i in 2:dim(temp)[2]){
      command <- paste0(command,
                        "%>% hc_add_series(name= colnames(temp)[",i,"], data = temp[,",i,"])") 
    }
    eval(parse(text = command))
  }
  
  
  # Define export options
  export <- list(
    list(
      text = "PNG",
      onclick = JS("function () {
                   this.exportChart({ type: 'image/png' }); }")
    ),
    list(
      text = "JPEG",
      onclick = JS("function () {
                   this.exportChart({ type: 'image/jpeg' }); }")
    ),
    list(
      text = "SVG",
      onclick = JS("function () {
                   this.exportChart({ type: 'image/svg+xml' }); }")
    ),
    list(
      text = "PDF",
      onclick = JS("function () {
                   this.exportChart({ type: 'application/pdf' }); }")
    )
  )
  
  
  
  
  
  
  