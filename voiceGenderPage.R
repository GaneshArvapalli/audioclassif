library(shiny)
library(shinyearr)
library(tidyverse)
library(forcats)
library(Hmisc)

ui <- fluidPage(
  titlePanel("Voice Gender Classification Demo"),
  hr(),
  sidebarLayout(
    sidebarPanel(
      helpText("Press the button to start recording your voice.
               Make sure the app can use your mic. Try reading these 
               instructions for example!"),
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
    
    # Scale down to between 0 and 1
    scaledRecording <- rvs$recording
    scaledRecording$value <- (scaledRecording$value - 
                                min(scaledRecording$value))/(diff(range(scaledRecording$value)))
    scaledRecording$frequency <- (scaledRecording$frequency - 
                                    min(scaledRecording$frequency))/(diff(range(scaledRecording$frequency)))
    
    # Calculate meanfreq
    myVoice<-wtd.mean(scaledRecording$frequency, scaledRecording$value, na.rm=T)
    
    # SD
    myVoice<-c(myVoice, sqrt(wtd.var(scaledRecording$frequency, scaledRecording$value, na.rm=T)))
    
    # Q25, Median, Q75
    myVoice<-c(myVoice, wtd.quantile(x=scaledRecording$frequency, probs=c(0.25, 0.5, 0.75), weights=scaledRecording$value, na.rm=T))

    # IQR
    myVoice<-c(myVoice, myVoice[5] - myVoice[3])
    
    output$finalClassification <- renderText({
      predictGender(fit, data.frame(t(myVoice)))
    })
  })
}

shinyApp(ui = ui, server = server)