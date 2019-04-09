
# Load the libraries needed
library(shiny)
library(ggplot2)
library(magrittr)
library(tidyr)

# We will use the diamonds dataset built into the ggplot2 library. 
# Additional data preparation here
cut_options <- as.character(unique(diamonds$cut))


# Define UI
ui <- fluidPage(
  
  titlePanel("Welcome to Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput(inputId = "cut_input", label = "Select Diamond Cut:",  
                  choices = cut_options, selected = cut_options[1])
    ),
    
    mainPanel(
      # Output 1: a reactive title
      h3(textOutput(outputId = 'plot_title')),
      # Output 2: a scatterplot in ggplot
      plotOutput(outputId = "diamonds_plot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # STEP 1: Filter the data!
  # Return the requested dataset
  diamonds_filtered <- reactive({
    
    df <- diamonds %>% filter(cut==input$cut_input)
    return(df)
    
    # Another way to filter in base R
    # df <- diamonds[diamonds$cut==input$cut_input,]
    # return(df)
    
  })
  
  # STEP 2: Feed the filtered data to the outputs
  
  output$plot_title <- renderText({paste("Plot for", input$cut_input, "Diamonds:")})
  
  output$diamonds_plot <- renderPlot({
    
    # Call the function so it is treated as a dataset
    data_for_plot <- diamonds_filtered()
    
    # Use normal ggplot code for plotting
    ggplot(data_for_plot, aes(x = carat, y = price, colour = color)) + 
      geom_point() +
      xlab("Carat") + ylab("Price")
  })
}

# Run the app
shinyApp(ui = ui, server = server)


