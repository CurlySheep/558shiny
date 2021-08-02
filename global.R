library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)

#####################Read in Data####################

  #Air Data
  air_data = read.csv("air_polution.csv", header = TRUE,encoding = "UTF-8")
  air_data$level <- as.factor(air_data$level)
  
  #Change the City name from Chinese character to English
  names(air_data)[1] <- "city"
  air_data$city <- c(rep("WZ", 26), rep("SH",26), rep("HZ", 26), rep("XY", 26), rep("HF", 26))
  air_data[is.na(air_data)] <- 0
