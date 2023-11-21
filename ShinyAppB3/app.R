
library(shiny)
library("gapminder")
library(tidyverse)
library(DT)
library(shinythemes)

gmds <- gapminder

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("cerulean"),
    # Application title
    titlePanel("Assignment B3 - Gapminder Shiny App"),
    h1("Gapminder Data Set"),
    h3("Visual Presentation of the Gapminder Data Set with Ability to Select for Life Expectancy"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("Life_Exp_Slider",
                        "Life Expectancy Range:",
                        min = 23,
                        max = 83,
                        value = c(23,83)

        ),  downloadButton("downloadGapminder", "Download Selected Data")
        ),


        # Show a plot of the generated distribution
      mainPanel(
        tabsetPanel(
          tabPanel("Life Expectancy vs. GDP Plot", plotOutput("LEGDP_pointplot")),
          tabPanel("Table", DT::dataTableOutput("gm_table"))
        )
    )
))

# Define server logic required to draw a histogram
server <- function(input, output) {
  filter_gapminder <- reactive({gapminder %>%
    filter(lifeExp < input$Life_Exp_Slider[2],
           lifeExp > input$Life_Exp_Slider[1])})

  output$LEGDP_pointplot <- renderPlot ({
    ggplot(filter_gapminder(), aes(gdpPercap, lifeExp)) +
    geom_point(aes(color = continent), alpha = 0.3) +
    scale_x_log10("GDP per capita", labels = scales::dollar_format()) +
    ylab("Life Expectancy")

  })

  output$gm_table <- DT::renderDataTable({filter_gapminder()
  })

  output$downloadGapminder <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0(input$dataset, ".csv")
    },
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      write.csv(filter_gapminder(), file)
    }
  )
    }


# Run the application
shinyApp(ui = ui, server = server)
