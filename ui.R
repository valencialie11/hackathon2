packages_to_use <- c("shiny", "shinydashboard","shinythemes")


install_load <- function(packages){
  to_install <- packages[!(packages %in% installed.packages()[, "Package"])] # identify unavailable packages
  
  if (length(to_install)){  # install unavailable packages 
    install.packages(to_install, repos='http://cran.us.r-project.org', dependencies = TRUE)  # install those that have not yet been installed
  }
  
  for(package in packages){  # load all of the packges 
    suppressMessages(library(package, character.only = TRUE))
  }
}

install_load(packages_to_use)

dashboardPage(
  dashboardHeader(title = "Dr. Dashboard",
                  dropdownMenu(type = "messages",
                               messageItem(
                                 from = "Database",
                                 message = "TWO(2) diseases in our database.",
                                 icon = icon("database")
                               ),
                               messageItem(
                                 from = "New User?",
                                 message = "Subscribe for daily medicine news!",
                               ),
                               messageItem(
                                 from = "Support",
                                 message = "Email us at doctor@dashboard.com",
                                 icon = icon("life-ring")
                               )
                  ),
                  dropdownMenu(type = "notifications",
                               notificationItem(
                                 text = "5 new subscribers this week!",
                                 icon("users")
                               ),
                               notificationItem(
                                 text = "20 predictions made!",
                                 icon("chart-line"),
                                 status = "success"
                               )
                               )
                    ),
  dashboardSidebar(sidebarMenu(
    menuItem("Introduction", icon = icon("android"), tabName = "intro"),
    menuItem("Prediction", tabName = "predict", icon = icon("stethoscope")),
    menuItem("Subscription", icon = icon("users"), tabName = "subscribe",
             badgeLabel = "new", badgeColor = "green")
    
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "intro",
              box(img(src = "drdashboard.png", height = 200, width = 200), background = "black", width = 3),
              h2("Hello, I am", strong("DR.DASHBOARD,"), "here as your personal virtual doctor!",style = "font-family: 'times'; font-si16pt"),
              h4("I am here to assist professional doctors by recommending them on whether you need further treatments to confirm their suspicion based on your symptoms.
                 Rest assured all your information are kept",
                 span(strong("confidential."), style = "color:red"), style = "font-family: 'times'; font-si16pt"),
              h3("Please treat my predictions as a",  strong("medical advice and not a diagnosis!"), style = "font-family: 'times'; font-si16pt"),
              br(),
              box(em("The team behind Dr. Dashboard is working hard to enlarge the database, so please bear with us at the moment. We will be back with more to serve you better!", style = "font-family: 'times'; font-si20pt", color = "white"),background = "black", width = 12),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              h6("Licensed by SmackerHacker 2020.", align = "center", style = "font-family: 'times'; font-si16pt")
      ),
      
      tabItem(tabName = "predict",
              fluidPage(navlistPanel(
                tabPanel("COVID-19", fluidRow(
                  tags$h4("Please upload your data according to the sample csv and get back predictions based on the likelihood
                          of you getting COVID-19 based on your current symptoms!", style="font-size:150%"
                    ),
                  fluidRow(
                  column(width = 4,
                         fileInput('file1', em('Upload test data in csv format ',style="text-align:center;color:blue;font-size:150%"),multiple = FALSE,
                                   accept=c('.csv')),
                         tableOutput("sample_input_data"),
                         valueBoxOutput("Prediction"))))),
                tabPanel("Cervical Cancer", fluidRow(
                  tags$h4("Please upload your data according to the sample csv and get back predictions based on the likelihood
                          of you getting Cervical Cancer based on your current risk factors!", style="font-size:150%"
                  ),
                  fluidRow(
                    column(width = 4,
                           fileInput('file2', em('Upload test data in csv format ',style="text-align:center;color:blue;font-size:150%"),multiple = FALSE,
                                     accept=c('.csv')),
                           tableOutput("sample_input_data2"),
                           valueBoxOutput("Prediction2")))))
      ))),
      tabItem(tabName = "subscribe",
              h2("Subscribe to our email for more medical news daily!", align = "center", style = "font-family: 'times'; font-si16pt"),
              br(),
              br(),
              br(),
              br(),
              br(),
              br(),
              textInput(inputId = "email", label = "Email address:"),
                  passwordInput(inputId = "password", label = "Password:"), align = "center",
      actionButton(inputId = "done", label = "Done")
  ))
)
)

