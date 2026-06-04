# Shiny interactivity practice app
# Nathaniel D Porter
# 2026-06-04

# load libraries
# install.packages(c("shiny","shinythemes","shinyjs"))
library(shiny)
library(shinythemes)
library(shinyjs)
library(tidyverse)

#ui
ui <- fluidPage(
  titlePanel("Interactive Greeting Application"),
  
  textInput(inputId = "user_input",
            label = "Enter your greeting:",
            value = "Hello, World!"),
  
  textOutput(outputId = "greeting")
)

#server
server <- function(input, output) {
  output$greeting <- renderText({
    paste0(input$user_input)
  })
}

#launch app
shinyApp(ui, server)