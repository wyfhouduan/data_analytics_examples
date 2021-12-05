# Load the data
library(data.table)
data(mtcars)
data.table::data.table(mtcars) 

library(shiny)
h1("My title")
mtcarsel <- mtcars
mtcarsel$am <- factor(mtcarsel$am, labels = c("Automatic", "Manual"))

server <- function(input, output) {
  
  formulaText <- reactive({
    paste("mpg ~ ",input$variable)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(formulaText()),
            data = mtcarsel,
            outline = input$outliers,
            col = "grey", pch = 19)
  })
  
}
ui <- fluidPage(
  
# App title 
  titlePanel("Miles/(US) gallon"),
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput("variable", "Variable:",
                  c("Cylinders" = "cyl",
                    "Displacement" ="disp",
                    "Gross horsepower" = "hp",
                    "Transmission" = "am",
                    "Rear axle ratio" = "drat",
                    "Weight" = "wt",
                    "1/4 mile time" = "qsec",
                    "Engine" = "vs",
                    "Gears" = "gear")),
      checkboxInput("outliers", "Show outliers", TRUE)
      
    ),
    mainPanel(
      h1("Click on the arrow on the left to select a variable"),
      plotOutput("mpgPlot")
      
    )
  )
)

shinyApp(ui, server)

