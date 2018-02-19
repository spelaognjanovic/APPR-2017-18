

library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Primerjava hitrosti serve"),
  
  tabsetPanel(
    tabPanel("Primerjava po spolu",
             sidebarPanel(
               selectInput("mesto",
                           label = "Izberite razvrstitev",
                           choices = sort(unique(hitrosti.serve$Razvrstitev))
                           
             )),
    mainPanel(plotOutput("hitrosti.serve"))
    )
    )
  )
)