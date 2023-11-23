#Loading data and packages
library(shiny)
library("gapminder")
library(tidyverse)
library(DT)
library(shinythemes)

# defining UI
ui <- fluidPage(
  theme = shinytheme("cerulean"), #theme for the UI
    # Application title
    titlePanel("Assignment B3 - Gapminder Shiny App"),
    #Page title
  h1("Gapminder Data Set"),
  #subtitle
    h3("Visual Presentation of the Gapminder Data Set with Ability to Select for Life Expectancy"),
    # Sidebar with a slider input for Life Expectancy
    sidebarLayout(
        sidebarPanel(
            sliderInput("Life_Exp_Slider", #Feature 1: Adding an input slider is useful as it allows participants to select the ranges of life expectancy they are curious about and see that data presented in the plot or on the interactive table.
                        "Life Expectancy Range:", #title of slider
                        min = 23, #minimum value
                        max = 83, #maximum value
                        value = c(23,83) #beginning set shows all data

        ),  downloadButton("downloadGapminder", "Download Selected Data") #Feature 2: Adding a download button allows app visitors to select for data using the interactive table and then download the data they selected for.
        ),


    #main panel with plot on one tab and interactive data table on another
      mainPanel(
        tabsetPanel( #adding tabs
          tabPanel("Life Expectancy vs. GDP Plot", plotOutput("LEGDP_pointplot")), #first tab with life expectancy plot
          tabPanel("Table", DT::dataTableOutput("gm_table")) #second tab with interactive data table
        )
    )
))

#defining server-------------------------------------------------------
server <- function(input, output) {
 #creating data
   filter_gapminder <- reactive({gapminder %>%
    filter(lifeExp < input$Life_Exp_Slider[2],
           lifeExp > input$Life_Exp_Slider[1])})

   #creating output for plot
  output$LEGDP_pointplot <- renderPlot ({
    ggplot(filter_gapminder(), aes(gdpPercap, lifeExp)) +
    geom_point(aes(color = continent), alpha = 0.3) +
    scale_x_log10("GDP per capita", labels = scales::dollar_format()) +
    ylab("Life Expectancy")

  })
  #creating output for table
  output$gm_table <- DT::renderDataTable({filter_gapminder()
  }) #Feature 3: Creating an interactive table allows app visitors to select the data they want to see presented in the table.

  #creating output for download button
  output$downloadGapminder <- downloadHandler(
    filename = function() {
      paste0(input$dataset, ".csv")
    },
    content = function(file) {
      write.csv(filter_gapminder(), file)
    }
  )
    }


# Run the application
shinyApp(ui = ui, server = server)
