library(shiny)
library(shinydashboard)
library(DT)
library(ggplot2)
library(tidyverse)
library(highcharter)
library(gbm)
library(caret)

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
  
  # Create subset data set
  Inputdata <- reactive({
    if(length(input$city_selecte_tag3)==0){
      return(air_data %>% select(city, date, input$var_selecte_tag3))
      }else{
      temp <- air_data %>%
        filter(city %in% input$city_selecte_tag3) %>%
        select(city, date, input$var_selecte_tag3)
      return(temp)
    }
  })
  
  # Draw the plot
  Outputplot <- reactive({
    if (input$plot_select=="Box plot"){
      gplot <- ggplot(data = Inputdata()) + geom_boxplot(aes(x=city,y=Inputdata()[,input$var_selecte_tag3])) +
        theme_bw() + labs(x='City',y=input$var_selecte_tag3)
    #} else{
    #  if (input$plot_select=="Time series (line plot)"){
       # gplot <- ggplot(data = Inputdata()) + geom_line(aes(x=date, y=Inputdata()[,input$var_selecte_tag3],
       #                                                     group=city,color=city),size=1.5) + 
       #   theme_bw() + labs(x='Date',y=input$var_selecte_tag3)
    #    gplot <- hc_plot(Inputdata(), input$city_selecte_tag3, input$var_selecte_tag3)
      } else{
        gplot <- ggplot(data = Inputdata()) + geom_bar(aes(x=date, y=Inputdata()[,input$var_selecte_tag3],
                                                           fill=city), stat = "identity", position = "dodge") +
          theme_bw() + labs(x='Date',y=input$var_selecte_tag3)
      }
    return(gplot)
  })
  
  # High charter plot
  output$hc_plot <- renderHighchart({
    if (input$down_type=="Box/Bar plot"){
      hc_plot(Inputdata(), input$city_selecte_tag3, input$var_selecte_tag3)
    } else{
      hc_plot(Inputdata(), input$city_selecte_tag3, input$var_selecte_tag3) %>%
        hc_exporting(
          enabled = T,
          url = "https://export.highcharts.com",
          formAttributes = list(target = "_blank"),
          buttons = list(contextButton = list(
            text = "Export",
            theme = list(fill = "transparent"),
            menuItems = export
        ))
        )
    }
    
  })
  
  # Output the plot
  output$plot_tag3 <- renderPlot({
    req(Outputplot())
    Outputplot()
  })
  
  # Download function for Box/Bar plot
  output$down_plot <- downloadHandler(
    filename = function(){paste0("plot_tag3", ".png")},
    content = function(file){
      ggsave(file, plot = Outputplot())
    }
  )
  
  # Download function for highcharter
  #output$down_hc_plot <- downloadHandler(
  #  filename = function(){paste0("hc_plot", ".png")},
  #  content = function(file){
  #    png(file, width=800, height=800)
  #    hc_plot(Inputdata(), input$city_selecte_tag3, input$var_selecte_tag3)
  #    dev.off()
  #  }
  #)
  
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
  
  
  #####################Tag 4#####################
  
  # Train/Test data split
  Splitdata <- reactive({
    set.seed(233)
    index <- sample(1:nrow(air_data),size = input$size*nrow(air_data))
    train <- air_data[index,]
    test <- air_data[-index,]
    return(list(Train=train, Test=test))
  })
  
  # Create formula first
  formu <- reactive({
    if (length(input$var_tag4)==0){
      return(formula(paste0(input$Re_tag4,'~','AQI+level+PM2.5+PM10+SO2+CO+NO2+O3_8h+high_tem+low_tem')))
    } else{
      n <- length(input$var_tag4)
      temp <- paste0(input$var_tag4,c(rep("+",n-1),""))
      temp <- paste0(temp, collapse = "")
      return(formula(paste0(input$Re_tag4, '~', temp)))
    }
  })
  
  # Fit the Linear model
  fit_lm <- eventReactive(input$gobutton,{
    fit.lm <- lm(formu(), data = Splitdata()[["Train"]])
    return(fit.lm)
  })
  
  # Fit the boosted tree model
  
  fit_Tree <- eventReactive(input$gobutton,{
    gbm.fit <- gbm(
      formula = formu(),
      distribution = "gaussian",
      data = Splitdata()[["Train"]],
      n.trees = 50,
      cv.folds = input$cv_fold,
      n.cores = NULL, # will use all cores by default
      verbose = FALSE
    )
    return(gbm.fit)
  })
  
  # Fit Random Forest model
  fit_random <- eventReactive(input$gobutton,{
    trctrl <- trainControl(method = "repeatedcv", number=input$cv_fold, repeats=1)
    rf_grid <- expand.grid(mtry = 1:11)
    rf_train <- train(formu(), 
                      data= Splitdata()[["Train"]], 
                      method='rf', 
                      trControl=trctrl,
                      tuneGrid = rf_grid,
                      preProcess=c("center", "scale"))
    return(rf_train)
  })
  
  # Output summary for linear
  output$summary_lm <- renderPrint({
    if (input$gobutton){
      summary(fit_lm())
    }
  })
  
  # Output summary for tree
  output$summary_tree <- renderPrint({
    if (input$gobutton){
      fit_Tree()
    }
  })
  
  # Output summary for random forest
  output$summary_random <- renderPrint({
    if (input$gobutton){
      fit_random()[["results"]]
    }
  })
  
  # Output RMSE and Test MSE
  output$RMSE <- renderTable({
    RMSE_lm <- sqrt(mean(fit_lm()$residuals^2))
    RMSE_Tree <- sqrt(mean((fit_Tree()$fit-Splitdata()[["Train"]][,input$Re_tag4])^2))  
    RMSE_random <- min(fit_random()$results$RMSE)
    
    temp <- data.frame(method = c('Linear Regression', 'Boosted Tree', 'Random Forest'), RMSE = rep(NA,3),
                       `Test.MSE`=rep(NA,3))
    temp$RMSE <- c(RMSE_lm, RMSE_Tree, RMSE_random)
    
    Test <- Splitdata()[["Test"]]
    obs <- Test[,input$Re_tag4]
    
    MSE_lm <- RMSE(predict(fit_lm(), Test), obs)
    MSE_Tree <- RMSE(predict(fit_Tree(),n.trees =fit_Tree()$n.trees, Test), obs)
    MSE_random <- RMSE(predict(fit_random()$finalModel, Test),obs)
    temp$`Test.MSE` <- c(MSE_lm, MSE_Tree, MSE_random)
    temp
  })
  
  # Predict
  output$predict <- eventReactive(input$prebutton, {
    temp <- air_data[1,]
    temp$AQI <- input$AQI
    temp$level <- input$level
    temp$PM2.5 <- input$PM2
    temp$PM10 <- input$PM10
    temp$SO2 <- input$SO2
    temp$CO <- input$CO
    temp$NO2 <- input$NO2
    temp$O3_8h <- input$O3
    temp$high_tem <- input$high_tem
    temp$low_tem <- input$low_tem
    
    if (input$model_select=="Linear Regression"){
      return(as.numeric(predict(fit_lm(),temp)))
    } else{
      if (input$model_select=="Boosted Tree"){
        return(as.numeric(predict(fit_Tree(),n.trees =fit_Tree()$n.trees,temp)))
      } else{
        return(as.numeric(predict(fit_random()$finalModel,temp)))
      }
    }
    
  })
  
})