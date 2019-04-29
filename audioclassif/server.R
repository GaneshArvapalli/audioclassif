#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    #object to hold all your recordings in to plot
    rvs <- reactiveValues(
        recording = data_frame(value = numeric(), frequency = integer())  
    )
    
    #set up server component of shinyearr
    recorder <- callModule(shinyearr, "my_recorder")
    
    observeEvent(recorder(), {
        my_recording <- recorder()
        
        #make dataframe of the results.
        rvs$recording <- data_frame(value = my_recording, frequency = 1:256)
        
        # Generate a plot of the recording we just made
        output$frequencyPlot <- renderPlot({
            ggplot(rvs$recording, aes(x = frequency, y = value)) +
                geom_line()
        })
    })

})

# link together ui and server and run the application
shinyApp(ui = ui, server = server)
