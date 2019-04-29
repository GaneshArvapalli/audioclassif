library(shiny)
library(shinyearr)
library(tidyverse)
library(forcats)

ui <- fluidPage(
  titlePanel("Voice Gender Classification Demo"),
  hr(),
  sidebarLayout(
    sidebarPanel(
      helpText("Press the button to start recording your voice. (Make sure the app can use your mic)"),
      shinyearrUI("my_recorder")
    ),
    mainPanel(
      h3(textOutput("finalClassification"), align="center"),
      plotOutput("frequencyPlot"),
      plotOutput("classificationPlot"),
      plotOutput("rocPlot_"),
      h5(textOutput("auc_"), align="center")
    )
  )
)

server <- function(input, output) {
  
  #object to hold all your recordings in to plot
  rvs <- reactiveValues(
    recording = data_frame(value = numeric(), frequency = integer())
  )
  
  #set up server component of shinyearr
  recorder <- callModule(shinyearr, "my_recorder")
  
  output$finalClassification<-renderText({""})
  
  observeEvent(recorder(), {
    my_recording <- recorder()
    
    # make dataframe of the results.
    rvs$recording <- data_frame(value = my_recording, frequency = 1:256)
    
    # Frequencies found in recording
    output$frequencyPlot <- renderPlot({
      ggplot(rvs$recording, aes(x = frequency, y = value)) +
        geom_line() + ggtitle("Frequency Distribution of Audio Input") +
        theme(plot.title = element_text(hjust = 0.5))
    })
    
    source("voice-gender.R", local=TRUE)
    
    output$classificationPlot <- renderPlot({
      classPlot
    })
    
    output$rocPlot_ <- renderPlot({
      rocPlot
    })
    
    output$auc_ <- renderText({
      paste("AUC:", toString(auc))
    })
  })
}

shinyApp(ui = ui, server = server)