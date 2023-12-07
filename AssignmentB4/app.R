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

#creating tibble that only contains countie with data across multiple years to make trend line graph
ab.use.ls.trend <- ab.use.ls %>%
  group_by(Entity) %>%
  mutate(count = n()) %>%
  filter(count > 1)

#creating tibble that shows average antibiotic use by year to create trend by year line graph
ab.use.ls.avg <- ab.use.ls %>%
  group_by(Year) %>%
  summarise(year_avg = mean(Antibiotic.use.in.livestock))


# Define UI----------------------------
ui <- fluidPage(

  theme = shinytheme("journal"), #theme for the UI

  #navigation bar
  navbarPage("Antibiotic Use Livestock",
              #panels in nav bar
             tabPanel("Welcome",
               #page title
                h2("Antibiotic Use in Livestock"),

                #into to the app and image
                fluidRow(
                  column(12,
                         img(src='FT_-_Antibiotics_v3-770x462.jpg', align = "right"),
                         p("This shiny app presents the use of antibiotics in livestock. The purpose of this app is to allow users to explore the Antibiotic Use in Livestock Data Set and to see antibiotic use in mulitple countries and the trends in antibiotic use in livestock. The dataset is from owid-datasets and is comprised of multiple sources.
                           Primarly the European Commision and Van Boeckel et al. Antibiotic use in livestock can potentially lead to anitbiotic resistant strains of harmful
                           bacteria that can cause severe and untreatable disease in human and animals. Image from foodtank.com. "))
                ),

                ),


        #Use by year panel
        tabPanel("Bar Graph",
            #title
             h2("World Livestock Antibiotic Bar Graph"),
            #slider instructions
            fluidRow(
                      column(12,
                            p("Use the slider to visualize the use of antibiotics in livestock by year"))
                      ),


            #create slider
            #Feature 1: Adding an input slider is useful as it allows participants
            #to select years they are curious about and see that data presented in the bar graph
                  fluidRow(
                    column(4,
                           sliderInput("year_slider",
                                       "Year:", #title of slider
                                       min = 2010, #minimum value
                                       max = 2015, #maximum value
                                       value = 2012,
                                       sep =""
                    )),
                  #bar graph
                    column(12, align = "center",
                           plotOutput("bar"))
                    ),
            ),


       tabPanel("Trends",
                #page title
                h2("Livestock Antibiotic Usage by Country"),
                #instructions
                fluidRow(
                  column(12,
                         p("Use drop down menu to select country"))
                ),

                #Feature 2: Drop down menu - allows users to select country of intrest
                fluidRow(
                  column(3, align = "center",
                         selectInput("country", "Country",
                                     choices = unique(ab.use.ls.trend$Entity),
                                     selected = "Belgium") #default selection,

       ),
       #line graph showing country selected from drop down
       column(12,
              plotOutput("linegraph")),
       ),
      #note on the data
       fluidRow(
         column(12,
                p(strong("Note:"),
                "Only countries with data from more than 1 year are shown in the drop down menu, to visualize data from all countries please use the interactive table under the Table tab")
       ),
       #fixed graph showing average use of antibiotic over time
       fluidRow(
         column(12,
                h3("Avgerage Livestock Antibiotic Usage between 2010 and 2015"),
             plotOutput("line_year")))


)),

      tabPanel("Table",
               #instructions
               p("Use the search bar to search by year or country."),
               #Feature 3: Creating an interactive table allows app visitors to select the data they want to see presented.
               DT::dataTableOutput("ab_table"),
               #download button to download selected data from table
               downloadButton("downloadab.use.ls", "Download Selected Data")

)))

#server ---------------------------------------------------
server <- function(input, output) {


  # creates  bar graph
  output$bar = renderPlot ({
    ab.use.ls.year <- filter(ab.use.ls, Year == input$year_slider) #filter data by slider
    ggplot(ab.use.ls.year, aes(Entity, Antibiotic.use.in.livestock, fill = Entity)) + #create plot
      geom_col(aes(color = Entity))+ #column graph
      theme(legend.position="none")+ #remove country legend
      ylab("Antibiotic Use (mg/kg meat) ") + #adding labels
      xlab("Country")


  })
  #creates country line graph
  output$linegraph = renderPlot ({
   ab.use.ls.trend <- filter(ab.use.ls, Entity == input$country) #filter by drop down menu
   min <- as.numeric(min(ab.use.ls.trend$Year, na.rm=TRUE)) #sets x-axis limits
   max <- as.numeric(max(ab.use.ls.trend$Year, na.rm=TRUE))
     ggplot(ab.use.ls.trend, aes(Year, Antibiotic.use.in.livestock)) + #creates plot
      geom_line(size = 2) + #line size
       geom_point(size = 5) +#point size
      ggtitle(paste("Antibiotic Use in", input$country)) + #title
      scale_x_continuous(breaks = seq(min, max, by = 1)) + #sets x-axis increments
      labs(x = "Year", y = "Antibiotic Use (mg/kg meat)") #labels
  })

  #creates year line graph
  output$line_year = renderPlot ({
    ggplot(ab.use.ls.avg, aes(Year, year_avg)) + #creates plot
      geom_line(size = 2) + #line size
      geom_point(size = 5) + #point size
      ylab("Antibiotic Use (mg/kg meat)") #y-axis label


  })

  #creates interactive table
  output$ab_table <- DT::renderDataTable({ab.use.ls
  })

  #creates download button
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

