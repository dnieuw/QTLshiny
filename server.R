library(qtlcharts)
library(qtl)
data(hyper)
library(markdown)
require(ggplot2)
require(qtl)      



shinyServer(function(input, output) {
  output$plot <- renderPlot({
    iplotMap(hyper)
      })
  
  output$summary <- renderPrint({
    summary(cars)
  })
  
})
