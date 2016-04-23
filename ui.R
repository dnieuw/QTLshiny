library(qtlcharts)
library(qtl)
data(hyper)
library(markdown)
require(ggplot2)
require(qtl)      


shinyUI(navbarPage("Map construction", inverse = TRUE,
                   tabPanel("Clean data",
                            sidebarLayout(
                              sidebarPanel(
                                selectizeInput('e1',
                                  label = 'Clean-up data',
                                  choices = c("Remove duplicates","Filter missing")
                                )
                              ),
                              mainPanel(
                                uiOutput("plot"))
                              )
                   )
                   ,
                   tabPanel("Quality plots",
                            renderDataTable("summary")
                   ),
                   tabPanel("MSTmap",
                            renderDataTable("summary")
                   ),
                   tabPanel("Estimate map",
                            renderDataTable("summary")
                   ),
                   tabPanel("KnitPDF",
                            renderDataTable("summary")
                   )
))

