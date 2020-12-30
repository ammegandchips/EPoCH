#### THINGS TO DO:
#### Make all PRS into zscores


#options(shiny.error = function() {
#  stop("")
#})


library(shiny)
library(shinyjs)
library(ggplot2)
library(plotly)
library(psych)
#devtools::install_github('cttobin/ggthemr')
#devtools::install_github("shinyTree/shinyTree",force=T)
library(ggthemr)
library(shinyTree)
library(ggstance)
library(plotly)
library(shinycssloaders)
library(egg)
library(dplyr)

key<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno_key.rds")
