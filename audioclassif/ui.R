#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
# Requires devtools::install_github("nstrayer/shinyearr")
library(shinyearr)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Voice Gender Classification"),

    hr(),
    shinyearrUI("my_recorder"),
    plotOutput("frequencyPlot"),
))
