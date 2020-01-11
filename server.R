library(shiny)
library(twitteR)
library(httr)
library(wordcloud)
library(wordcloud2)
library(tm)
library(shinyWidgets)
library(plotly)
library(ggplot2)
library(syuzhet)
library(lubridate)
library(scales)
library(reshape2)
library(dplyr)

api_key <- "660MFtiE7EV1yWm0oy9yirQom"
api_secret <- "mljqG0EvUaJzjKPhehvAQAVWZKOVQOs108Mz9vjNHdOvmnnSBb"
access_token <- "1710165894-IwLhzXcJh7kYCQ4OEWqafJeucEgPh17VtRsgz32"
access_token_secret <- "x8NsVG64rQioZNbPEZvFQgoLP1UaLJpl4wBqfJq5pJG3L"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)


shinyServer(function(input, output) {
  
 
  tweet<-reactive({
    t<-getUser(input$new)
    tweets<-userTimeline(t,n=input$slider,includeRts = FALSE,excludeReplies = TRUE)
    data <- twListToDF(tweets)
    data$text <- sapply(data$text,function(row) iconv(row,"latin1","ASCII",sub=""))
    corpus<-data$text
    corpus<-Corpus(VectorSource(corpus))
    corpus<-tm_map(corpus,tolower)
    corpus<-tm_map(corpus,removeNumbers)
    clean.corpus<-tm_map(corpus,removeWords,stopwords('en'))
    corpus<-tm_map(corpus,removePunctuation)
    remove.Url<-function(x) gsub('http[[:alnum:]]*','',x)
    clean.corpus<-tm_map(clean.corpus,content_transformer(remove.Url))
    clean.corpus<-tm_map(clean.corpus,stripWhitespace)
    tdm<-TermDocumentMatrix(clean.corpus)
    tdm<-as.matrix(tdm)
    w<-rowSums(tdm)
    tab<-data.frame(names(w),w)
    colnames(tab)<-c('word','freq')
    return(tab)
    })
  
  
output$wordcloud<-renderWordcloud2({
  wordcloud2(tweet(),size=0.7,shape='triangle',rotateRatio = 0.5,minSize=1) 
  })
  
      
 output$barplot<-renderPlotly({
   t<-getUser(input$new)
   tweets<-userTimeline(t,n=input$slider,includeRts = FALSE,excludeReplies = TRUE)
   data <- twListToDF(tweets)
   data$text <- sapply(data$text,function(row) iconv(row,"latin1","ASCII", sub=""))
   vector<-data$text
   s <- get_nrc_sentiment(vector)
   sentiment<-c("anger","anticipation","disgust","fear","joy","sadness","surprise","trust","negative","positive")
   BD<-data.frame(sentiment,colSums(s))
   colnames(BD)<-c("Sentiment","Score")
   ggplot(data=BD, aes(x=Sentiment,y=Score)) +
     geom_bar(stat="identity",fill=rainbow(10))+ylab("Scores")+xlab("Sentiment")+
     labs(title="Sentiment Scores for Tweets extracted")+
     theme_minimal()+
     theme(axis.text.x=element_text(angle=20))
   
 })
  
  
  
  
  
  }
)