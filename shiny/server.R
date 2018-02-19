library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  output$hitrosti.serve <- renderPlot({
    ggplot(data = hitrosti.serve %>% filter(Razvrstitev ==input$mesto),
           aes(x = Spol, y = Hitrost)) +
      geom_col(color = "purple", fill = "white")
  }) 
  
  
})

