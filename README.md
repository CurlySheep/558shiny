# Brief Introduction

In this APP I want to study several meteorological factors and air quality indicators between 5 cities in China, and  conducts modelling analysis on whether the transmission of COVID-19 is affected by atmosphere.

4 pages are included in this APP, which are `About` page, `Data` page, `Data exploration` page and `Modeling` page.

# List of Packages

ggplot2, shiny, shinydashboard, DT, tidyverse, highcharter, gbm, caret

# Code for Installing All the Packages

```R
packages <- c("ggplot2","shiny", "shinydashboard", "DT", "tidyverse", "highcharter", "gbm", "caret")
lapply(packages, install.packages, character.only = TRUE)
```

# Code for Running the APP

```R
runGitHub(repo = "558shiny", username = "CurlySheep", ref = "main")
```


