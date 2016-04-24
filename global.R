library(qtlcharts)
library(qtl)
library(markdown)
library(ggplot2)
library(qtl)      
library(ASMap)
library(shinythemes)
library(ggthemes)
library(ggiraph)
library(gtools)
library(shinyIncubator)
library(dplyr)

source("src/plotMap.R")


mydata <- read.cross(format = "csv",
           file = "data/cross.csv" ,
           genotypes = c("a","h","b"),
           alleles = c("a","b"),
           estimate.map = FALSE,
           BC.gen = 0,
           F.gen = 6
)

