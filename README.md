# Assignment B3 & B4 - ShinyApp Hannah Hauch :sparkles:

## Assignment B3: Gapminder Shiny App Discription :page_with_curl:

The [Gapminder Shiny App](https://hannahhauch.shinyapps.io/ShinyAppB3/) displays a plot that shows life expectancy and GPD per capita. The life expectancy 
presented in the plot can be adjusted using a slider tool. The slider tool also affects the data presented in the interactive table seen in the *Table* tab.  The app contains multiple features:
1. Slider Tool: allows user to select for life expectancy data
2. Download button: The selected data can be downloaded using the **download selected data** button.  
3. Interactive Table: The interactive table can be used to see data for specific years, continents, or countries.

And more features such as a theme and multiple tabs.  

:earth_americas: [Access Gapminder Shiny App Here](https://hannahhauch.shinyapps.io/ShinyAppB3/) :earth_americas:

The full written link for the app is: https://hannahhauch.shinyapps.io/ShinyAppB3/

The shinyapp was created with a data package with an excerpt from the [Gapminder](https://www.gapminder.org/data/) data. The data set used to make this shinyapp can be installed by 'install.packages("gapminder")' and the called through 'library(gapminder)'.

## Assignment B4: Antibiotic Use in Livestock Shiny App Discription :pill: 

For Assignment B4 I created a new Shiny App from **scratch**. The purpose of this app is to allow users to explore the Antibiotic Use in Livestock Data Set and to see antibiotic use in multiple countries and the trends in antibiotic use in livestock by year and country. The data set is from owid-datasets and is comprised of multiple sources: Primarly the European Commision and Van Boeckel et al.

The Shiny app can be accessed [here](https://hannahhauch.shinyapps.io/AssignmentB4/). 

Multiple features were included in this shiny app, three features also used in Assignment B3 are:
1. Slider Tool:  allows user to select for year
2. Interactive table: allows user to select for country or year and see that data
3. Download button: Allows user to download the selected data from interactive table

Three novel features for Assignment B4 are: 
1. Navigation bar: splits up the app into tabs which is more user friendly and aesthetic
2. Drop Down Menu: allows users to select country of interest for trend graphs
3. Image: provides visuals and context to user

Other features include: theme

:cow2: [Access Antibiotic Use in Livestock Shiny App Here](https://hannahhauch.shinyapps.io/AssignmentB4/) :pig2:

The shinyapp was created with a data package found in [owid datasets](https://github.com/owid/owid-datasets/tree/master/datasets/Antibiotic%20use%20in%20livestock%20-%20European%20Commission%20%26%20Van%20Boeckel%20et%20al.). The dataset is titled *Antibiotic use in livestock - European Commission & Van Boeckel et al*. The data set can be downloaded and installed through using read.csv() in R.

The data within the dataset comes from the [European Commission Report](http://www.ema.europa.eu/docs/en_GB/document_library/Report/2017/10/WC500236750.pdf.), [United Kingdom Report](https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/655403/_1274590_VARSS_2016_report.PDF), and data published by Van Boeckel et al. in 2010 available [here](http://www.pnas.org/content/112/18/5649.full.pdf ). 

The code in this repository is written in R and can be run in Rstudio. The files in this repository require Rstudio and R. To execute the files, the repository can be locally cloned or downloaded and the files can be opened in RStudio. The files use multiple packages (shiny, gapminder, tidyverse, DT, shinythemes). If needed install packages using: install.packages("package name"). To knit the files click knit in Rstudio and the files will be converted to markdown files.


:octocat:


