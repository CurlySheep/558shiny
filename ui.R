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
              column(4,
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
                         h4("AQI (Air quality index) along with 7 meteorological numerics PM2.5, PM10, SO2,
                            CO, NO2, O3 and temperature were collected. Note that AQI can seen as a piecewise linear function 
                            of the pollutant concentratin."),
                         h4(uiOutput("link7"))
                        )
                    ),
              
              # How to Use
              column(4,
                     h1("How to Use"),
                     
                     # Box
                     box(width = 12,
                         h4("The controls for the app are located to the left and the visualizations 
                            are available on the right."),
                         h4("At each page, usually the interaction features are listed on the left or 
                         top, and the results are displayed on the right."),
                         h4("There are 4 pages in this APP."),
                         h4("At About page, you can see the basic information and find the sources of data."),
                         h4("At Data page, you can go through the data, subset the data by rows and columns,
                            and download the data."),
                         h4("At Data Exploratin page, you can view/download some summary plots."),
                         h4("At Modeling page, you can fit 3 models, and then use them to predict.")
                         )
                    ),

              # Data Source
              column(4,
                     h1("Source"),
                     box(width = 12,
                         h4("The number of confirmed cases came from
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
              
              div(img(src="wikiimage.jpg", height = '500px'), style="text-align: center;")
              
              
              ),
      
      #####################Second Tab Content####################
      tabItem(tabName = "Tab2",
              
              # Subset rows by city
              column(6,
                     h4("You can subset the data by cities below:"),
                     selectInput(inputId = "city_selecte",
                                 label = "Choose one city to summarize (Default shows all 5 cities)",
                                 choices = c("All", "Wenzhou", "Shanghai", "Hangzhou", "Xinyang", "Hefei")
                     )
                     ),
              
              # Select variables
              column(6,
                     h4("You can subset the data by variables below (multiple choices):"),
                     selectInput(inputId = "var_selecte",
                                 label = "Choose variables to summarize (can't ignore city and date)",
                                 choices = names(air_data)[-c(1:2)], multiple = T
                     )
                     ),
              
              # Provide download button
              downloadButton(outputId = "down_dat", label = "Download the data"),
              
              
              # Show the data frame
              dataTableOutput("dataf"),
              
              h1("Variables explanation"),
              
              # Provide variables explanation
              column(6,

                     box(width = 12,
                         h6("City: The abbreviation of city name. HF for Hefei, HZ for Hangzhou, SH for Shanghai, 
                            WZ for Wenzhou and XY for Xinyang."),
                         h6("Date: Recorded date."),
                         h6(p("AQI: Air quality index. See details at the ",
                              strong("About"), " page.")),
                         h6("Level: Air quality level grouped by AQI, ranged form 1 to 4. 1 for the best air 
                            quality and 4 for the worest."),
                         h6("PM2.5: Numeric variable for PM2.5."),
                         h6("PM10: Numeric variable for PM10."),
                         h6("SO2: Numeric variable for SO2."), height = 200
                     )
              ),
              column(6,
                     box(width = 12,
                         h6("CO: Numeric variable for CO."),
                         h6("NO2: Numeric variable for NO2"),
                         h6("O3_8h: Numeric variable for O3"),
                         h6("new: Reported number of confirmed cases for that day."),
                         h6("new_no_HB: Reported number of confirmed cases without recently visited to Hubei. 
                            Note that Hubei is the first provience which burst the epedamic in China."),
                         h6("high_tem: The highest temperature."),
                         h6("low_tem: The lowest temperature."), height = 200
                         )
                     )
              
            
              
              ),
      
      #####################Third Tab Content####################
      tabItem(tabName = "Tab3",
              fluidRow(
                column(width = 3,
                       
                       # Select Cities
                       box(width = 12,
                           h4("You can filter the rows by cities below (multiple choices):"),
                           selectInput(inputId = "city_selecte_tag3",
                                       label = "By default it select all 5 cities",
                                       choices = c("WZ", "SH", "HZ", "XY", "HF"),
                                       multiple = T
                           )
                           ),
                       
                       # Select Variables
                       box(width = 12,
                           h4("You can change the variables below for both plot and numeric summary (single choices):"),
                           selectInput(inputId = "var_selecte_tag3",
                                       label = "Choose variables to summarize:",
                                       choices = names(air_data)[-c(1:2)], multiple = F
                           )
                           ),
                       
                       # Select the type of plot
                       box(width = 12,
                           h4("You can change the type of plots below:"),
                           radioButtons(inputId = "plot_select",
                                        label = "",
                                        choices = c("Box plot", "Bar plot"),
                                        selected = "Box plot"
                           )
                           ),
                       
                       # Add change summary type button
                       box(width = 12,
                           h4("You can change the quantile of summary variable below:",
                              numericInput(inputId = "perc",
                                           label = "Range from 0.01 to 0.99",
                                           value = 0.01, min = 0.01, max = 0.99, step = 0.01)
                              )
                           ),
                       
                       # Download plot
                       box(width = 12,
                           h4("You can download the plot by select the type first:"),
                           h4("(Dynamic UI 1)", style = "color:red;"),
                           radioButtons(inputId = "down_type",
                                        label = "",
                                        choices = c("Box/Bar plot", "Line plot")
                                        ),
                           conditionalPanel(condition = "input.down_type == 'Box/Bar plot'",
                                            downloadButton(outputId = "down_plot", label = "Box/Bar Plot!")
                           ),
                           conditionalPanel(condition = "input.down_type == 'Line plot'",
                                            h4("Click the upper right corner button of the line plot.", style = "color:red;"),
                                            h4("You need open this APP in browser in order to download the line plot!", style = "color:red;")
                                            )
                           )
                       
                       
                       ),
                column(width = 9,
                       h1("Plot:"),
                       plotOutput("plot_tag3"),
                       br(),
                       highchartOutput("hc_plot"),
                       h1("Numerical Summary:"),
                       box(width = 12,
                           skin="white",
                           tableOutput("table_tag3")
                           )
                       )
              )
      ),
      
      #####################Forth Tab Content####################
      tabItem(tabName = "Tab4",
              
              #add in latex functionality if needed
              withMathJax(),
              
              tabsetPanel(
                tabPanel("Modeling Info",
                         fluidRow(
                           column(width = 4,
                                  h1("Linear Regression"),
                                  box(width = 12,
                                      h4("Linear regression accomplishes this by learning a model that best fits the 
                                         linear relationship between the predictor and response variables.
                                         The model is fit by minimizing the sum of squared residuals (difference between 
                                         the observed and predicted responses)."),
                                      h4("Given a data set \\(y_i,x_{i1},\\cdots,x_{ip}\\) The model takes the form"),
                                      p("\\(y_i=\\beta_0+\\beta_1x_{i1}+\\cdots+\\beta+px_{ip}+\\varepsilon_i \\)"),
                                      h4("In the least-squares setting, the optimum parameter is defined as such that minimizes the
                                         sum of mean squared loss:"),
                                      p("\\(\\hat{\\beta}=argmin_{\\beta}L(D,\\beta)=argmin_{\\beta}\\sum_{i=1}^n(\\beta x_i-y_i)^2 \\)"),
                                      h4(strong("Benefits:")),
                                      h4("Simple and ease with implementation;"),
                                      h4("Has a considerably lower time complexity;"),
                                      h4("Perfroms extremely well for linearly data."),
                                      h4(strong("Drawbacks:")),
                                      h4("Requires some assumptions like constant residuals;"),
                                      h4("May be sensitive to Outliers;"),
                                      h4("Lack of practicality, since most cases in our real world aren't 'linear'")
                                      )
                                  ),
                           column(width = 4,
                                  h1("Regression Tree"),
                                  box(width = 12,
                                      h4("A regression tree is built through a process known as binary recursive partitioning, 
                                         which is an iterative process that splits the data into partitions or branches, and then 
                                         continues splitting each partition into smaller groups as the method moves up each branch."
                                         ),
                                      h4("In this APP I used boosted tree."),
                                      h4("We are usually given a training set \\((x_1,y_1),\\cdots,(x_n,y_n)\\) of 
                                         known sample values of x and corresponding values of y. In acoordance with the empirical
                                         risk minimization principle, the method tries to find an approximation \\(\\hat{F}(x)\\) 
                                         that minimizes the average value of the loss function on the training set."),
                                      h4(strong("Benefits:")),
                                      h4("Lots of flexibility;"),
                                      h4("Can optimize on different loss functions and provides several hyper parameter tuning options;"),
                                      h4("It can curbs over-fitting easily."),
                                      h4(strong("Drawbacks:")),
                                      h4("May be sensitive to Outliers;"),
                                      h4("Requires a lot of times;"),
                                      h4("The method is almost impossible to scale up since every estimator bases its correctness on the
                                         previous predictors, thus making the procedure difficult to streamline.")
                                      )
                                  ),
                           column(width = 4,
                                  h1("Random Forest"),
                                  box(width = 12,
                                      h4("Random Forest works by creating a number of decision trees from bootstrap samples using 
                                         the training data set, with no interaction between the trees, and aggregates the result 
                                         from these trees before outputting the most optimal result."),
                                      h4("The training algorithm for random forests applies the general technique of bootstrap 
                                         aggregating, or bagging, to tree learners. Given a training set \\(X=x_1,\\cdots,x_n\\) with
                                         responses \\(Y=y_1,\\cdots,y_n\\), bagging repeatedly (B times) selects a random sample with
                                         replacement of the training set and fits trees to these samples:"),
                                      h4("For \\(b=1,\\cdots,B\\):"),
                                      h4("1. Sample, with replacement, n training examples from X,Y; call these \\(X_b,Y_b\\)."),
                                      h4("2. Train a classification or regression tree \\(f_b\\) on \\(X_b,Y_b\\)."),
                                      h4(strong("Benefits:")),
                                      h4("It reduces overfitting in decision trees and helps to improve the accuracy;"),
                                      h4("It works well with both categorical and continuous values;"),
                                      h4("It automates missing values present in the data."),
                                      h4(strong("Drawbacks:")),
                                      h4("Requires much computational power as well as resources;"),
                                      h4("Requires much time for training;"),
                                      h4("Due to the ensemble of decision trees, it also suffers interpretability and fails to 
                                         determine the significance of each variable.")
                                      )
                                  )
                         )
                         ),
                tabPanel("Model Fitting",
                         fluidRow(
                           column(width = 3,
                                  
                                  br(),
                                  # Change train/test set
                                  box(width = 12,
                                      sliderInput("size", "Percentage of Training Set",
                                                  min = 0.01, max = 0.99, value = 0.80, step = 0.01)
                                      ),
                                  
                                  # Select the Response
                                  box(width = 12,
                                      selectInput(inputId = 'Re_tag4',
                                                  label = "Please select the Response variable first:",
                                                  choices = c("new","new_no_HB")
                                                  ),
                                      h6(strong("new:"), " Reported number of confirmed cases."),
                                      h6(strong("new_no_HB:"), " Reported number of confirmed cases without recently visited to Hubei.")
                                      ),
                                  
                                  # Select variables
                                  box(width = 12,
                                      selectInput(inputId = 'var_tag4',
                                                  label = "Please select variables for all models (multiple choices):",
                                                  choices = c("AQI","level","PM2.5","PM10","SO2","CO","NO2","O3_8h",
                                                              "high_tem","low_tem"), multiple = T
                                                  ),
                                      h6("By default it selects all the variables.")
                                      ),
                                  
                                  # Cross-validation
                                  box(width = 12,
                                      sliderInput("cv_fold", "Cross validation folds:",
                                                  min = 1, max = 10, value = 3, step = 1)
                                  ),
                                  
                                  # Action Button
                                  box(width = 12,
                                      actionButton("gobutton", "Click here to start!"),
                                      h4(strong("Usually it will take 3-5 mins."))
                                      )
                                  ),
                           
                           column(width = 9,
                                  br(),
                                  
                                  
                                  # Summary
                                  box(width = 12,
                                      column(4,
                                             h4("Summary for linear regression:"),
                                             verbatimTextOutput("summary_lm")
                                             ),
                                      column(4,
                                             h4("Summary for boosted tree:"),
                                             verbatimTextOutput("summary_tree")
                                             ),
                                      column(4,
                                             h4("Summary for Random Forest:"),
                                             verbatimTextOutput("summary_random")
                                      )
                                      ),
                                  
                                  # Table
                                  box(width = 12,
                                      tableOutput("RMSE")
                                      )
                                  )
                         )
                         ),
                tabPanel("Prediction",
                         fluidRow(
                           column(width = 3,
                                  br(),
                                  
                                  # Select the Model
                                  box(width = 12,
                                      h4("You can select a model to predict:"),
                                      radioButtons(inputId = "model_select",
                                                   label = "",
                                                   choices = c("Linear Regression", "Boosted Tree", "Random Forest"),
                                                   selected = "Linear Regression")
                                      ),
                                  
                                  # Predict Button
                                  box(width = 12,
                                      h4(strong("Be sure to run the models first!")),
                                      actionButton("prebutton", "Click here to predict!")
                                      ),
                                  
                                  # AQI
                                  box(width = 12,
                                      sliderInput("AQI", "Input the value of AQI",
                                                               min = 1, max = 200, value = 50, step = 1)
                                  ),
                                  
                                  # level
                                  box(width = 12,
                                      sliderInput("level", "Input the value of level",
                                                  min = 1, max = 5, value = 1, step = 1)
                                  ),
                                  
                                  # PM2.5
                                  box(width = 12,
                                      sliderInput("PM2", "Input the value of PM2.5",
                                                  min = 1, max = 200, value = 50, step = 1)
                                  ),
                                  
                                  # PM10
                                  box(width = 12,
                                      sliderInput("PM10", "Input the value of PM10",
                                                  min = 1, max = 250, value = 50, step = 1)
                                  ),
                                  
                                  # SO2
                                  box(width = 12,
                                      sliderInput("SO2", "Input the value of SO2",
                                                  min = 1, max = 10, value = 5, step = 1)
                                  ),
                                  
                                  # CO
                                  box(width = 12,
                                      sliderInput("CO", "Input the value of CO",
                                                  min = 0, max = 2, value = 0.7, step = 0.1)
                                  ),
                                  
                                  # NO2
                                  box(width = 12,
                                      sliderInput("NO2", "Input the value of NO2",
                                                  min = 1, max = 100, value = 20, step = 1)
                                  ),
                                  
                                  # O3
                                  box(width = 12,
                                      sliderInput("O3", "Input the value of O3",
                                                  min = 1, max = 150, value = 50, step = 1)
                                  ),
                                  
                                  # High tem
                                  box(width = 12,
                                      sliderInput("high_tem", "Input the value of highest temperature",
                                                  min = 1, max = 30, value = 10, step = 1)
                                  ),
                                  
                                  # Low tem
                                  box(width = 12,
                                      sliderInput("low_tem", "Input the value of lowest temperature",
                                                  min = -10, max = 20, value = 5, step = 1)
                                  )
                                  
                                  ),
                           column(width = 9,
                                  br(),
                                  # Show the result
                                  h1("The predicted value is:"),
                                  verbatimTextOutput("predict")
                                  
                                  )
                         )
                         )
              )
              
              )
    )
  )
)