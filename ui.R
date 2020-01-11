library(shiny)
library(shinydashboard)
library(twitteR)
library(httr)
library(wordcloud)
library(wordcloud2)
library(tm)
library(shinyWidgets)
library(plotly)
library(ggplot2)
library(shinyjqui)

shinyUI(
  
  dashboardPage(skin="red", 
  dashboardHeader(title="Mona's up2: Twitter Sentiment Analysis of news from American profiles using R and ShinyDashboard",
titleWidth = 1000),
  
  dashboardSidebar(width=250,
    sidebarSearchForm(label="Search","searchText","searchButton"),
    sidebarMenu(
      menuItem(h5("Data Visualization"),tabName="wcl",icon=icon("bar-chart-o"))
    ),
    radioGroupButtons(inputId = "new", 
                      label = "Twitter Profiles", choices = c("thehill","Reuters", "SkyNews","BBCWorld","nytimes","cnni",
    "HuffPost","FoxNews","CNBC"),selected="thehill",status = "danger"),
    sliderInput("slider", label = h5("Number of tweets extracted"), min = 50, 
                max = 500, value = 100,step=10),
    h5(strong("This Shiny app is powered by Mouna Belaid")),
    h5(tags$a(href="https://twitter.com/mounaa_belaid", strong("Reach me (@mounaa_belaid)"),target="_blank"))
  ),
  
  dashboardBody(

    tabItems(
      tabItem(tabName = "wcl",
              box(title=h5(p(strong("In this application, the user would be able to extract data from Twitter. I focus the work on American twitter profiles:")), 
                      tags$ol(
                             tags$li("The Hill"), 
                             tags$li("Reuters Top News"), 
                             tags$li("Sky News"),
                             tags$li("BBC News (World)"),
                             tags$li("The New York Times"),
                             tags$li("CNN International"),
                             tags$li("HuffPost"),
                             tags$li("Fox News"),
                             tags$li("CNBC")
                           ),  
tags$div(
tags$p(strong("I resort to text mining in order to create a wordcloud which shows the most frequented words used in the last 100 tweets. The tweets would be cleaned before
    the display of the wordcloud. The user may change the number of tweets extracted using the radio button. 
Morever, I perform a sentiment analysis of textual contents of twitter posts by using the categories identified as 
  anger, anticipation, disgust, fear, joy, negative, positive, sadness, surprise and trust. It would be possible to download the barplot.")),
tags$p(strong("Enjoy this application and I'm extremely open to your feedbacks.")) )

),status="danger",solidHeader = F,collapsible = F,width=14),
              fluidRow(
                box(title="Wordcloud",status="danger",solidHeader=TRUE,collapsible=TRUE,wordcloud2Output("wordcloud")    ),
                box(title="Barplot",plotlyOutput("barplot"),status="danger",solidHeader=TRUE,collapsible=TRUE))
              )


    )
    
  )

)    
  ) 
  
