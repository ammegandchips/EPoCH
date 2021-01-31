
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

key <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/master_key.RDS")


 df_model1a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
 df_model1b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1b_extracted.RDS")
 
 df_model2a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
 df_model2b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")
 
 df_model3a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model3a_extracted.RDS")
 df_model3b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model3b_extracted.RDS")
 
 df_model4a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model4a_extracted.RDS")
 df_model4b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model4b_extracted.RDS")
 

