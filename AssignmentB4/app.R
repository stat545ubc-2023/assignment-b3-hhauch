# loading libraries ----------------------
library(shiny)
library(ggplot2)
library(dplyr)
library(maps)
library(wesanderson)
library(rsconnect)
library(tidyverse)
library(DT)
library(shinythemes)

# importing data ---------------------------

#importing Antibiotic use in livestock - European Commission & Van Boeckel et al.

ab.use.ls <- read.csv("Antibiotic use in livestock - European Commission & Van Boeckel et al..csv")

ab.use.ls.trend <- ab.use.ls %>%
  group_by(Entity) %>%
  mutate(count = n()) %>%
  filter(count > 1)

ab.use.ls.avg <- ab.use.ls %>%
  group_by(Year) %>%
  summarise(year_avg = mean(Antibiotic.use.in.livestock))

 #reads cvs


# Define UI----------------------------
ui <- fluidPage(

  theme = shinytheme("journal"), #theme for the UI

  #navigation bar
  navbarPage("Antibiotic Use Livestock",
       tabPanel("Welcome",
                h2("Antibiotic Use in Livestock"),
                fluidRow(
                  column(12,
                         img(src='FT_-_Antibiotics_v3-770x462.jpg', align = "right"),
                         p("This shiny app presents the use of antibiotics in livestock. The dataset is from owid-datasets and is comprised of multiple sources.
                           Primarly the European Commision and Van Boeckel et al. Antibiotic use in livestock can potentially lead to anitbiotic resistant strains of harmful
                           bacteria that can cause severe and untreatable disease in human and animals. Image from foodtank.com. "))
                ),

                ),


        #World Overview panel
        tabPanel("Bar Graph",

             h2("World Livestock Antibiotic Bar Graph"),
                  fluidRow(
                      column(12,
                            p("Use the slider to visualize the use of antibiotics in livestock by year"))
                      ),


            #create slider
                  fluidRow(
                    column(4,
                           sliderInput("year_slider",
                                       "Year:", #title of slider
                                       min = 2010, #minimum value
                                       max = 2015, #maximum value
                                       value = 2012,
                                       sep =""
                    )),

                    column(12, align = "center",
                           plotOutput("bar"))
                    ),
            ),


       tabPanel("Trends",
                h2("Livestock Antibiotic Usage by Country"),
                fluidRow(
                  column(12,
                         p("Use drop down menu to select country"))
                ),


                fluidRow(
                  column(3, align = "center",
                         selectInput("country", "Country",
                                     choices = unique(ab.use.ls.trend$Entity),
                                     selected = "Belgium")# default selection,

       ),
       column(12,
              plotOutput("linegraph")),
       ),

       fluidRow(
         column(12,
                p(strong("Note:"),
                "Only countries with data from more than 1 year are shown in the drop down menu, to visualize data from all countries please use the interactive table under the Table tab")
       ),
       fluidRow(
         column(12,
                h3("Avgerage Livestock Antibiotic Usage between 2010 and 2015"),
             plotOutput("line_year")))


)),
      tabPanel("Table",
               p("Use the search bar to search by year or country."),
               DT::dataTableOutput("ab_table"),
               downloadButton("downloadab.use.ls", "Download Selected Data")

)))

# Define server logic required to draw a histogram
server <- function(input, output) {


  # creates  map
  output$bar = renderPlot ({
    ab.use.ls.year <- filter(ab.use.ls, Year == input$year_slider)
    ggplot(ab.use.ls.year, aes(Entity, Antibiotic.use.in.livestock, fill = Entity)) +
      geom_col(aes(color = Entity))+
      theme(legend.position="none")+
      ylab("Antibiotic Use (mg/kg meat) ") +
      xlab("Country")


  })

  output$linegraph = renderPlot ({
   ab.use.ls.trend <- filter(ab.use.ls, Entity == input$country)
   min <- as.numeric(min(ab.use.ls.trend$Year, na.rm=TRUE))
   max <- as.numeric(max(ab.use.ls.trend$Year, na.rm=TRUE))
     ggplot(ab.use.ls.trend, aes(Year, Antibiotic.use.in.livestock)) +
      geom_line(size = 2) +
       geom_point(size = 5) +# line size
      ggtitle(paste("Antibiotic Use in", input$country)) +
       scale_x_continuous(breaks = seq(min, max, by = 1)) +
      labs(x = "Year", y = "Antibiotic Use (mg/kg meat)")
  })

  output$line_year = renderPlot ({
    ggplot(ab.use.ls.avg, aes(Year, year_avg)) +
      geom_line(size = 2) +
      geom_point(size = 5) +
      ylab("Antibiotic Use (mg/kg meat)")


  })

  output$ab_table <- DT::renderDataTable({ab.use.ls
  })

  output$downloadab.use.ls <- downloadHandler(
    filename = function() {
      paste0(input$dataset,".csv")
    },
    content = function(file) {
      write.csv(ab.use.ls, file)
    })


  }

# Run the application
shinyApp(ui = ui, server = server)

