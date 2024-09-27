library(shiny)
library(tidyverse)
library(plotly)
library(shinycssloaders)
library(shinyjs)
library(shinyTree)
library(RCurl)


format_loaded_data <- function(global_data, loaded_data){
  # a bit of tidying will happen (stick it all together, make lists of unique exposure and outcome classes, make a tibble of unique combinations, put everything in a list and name the objects)
  loaded_data <- bind_rows(loaded_data)
  global_data$exp_classes <- unique(loaded_data$exposure_class)
  global_data$out_classes <- unique(loaded_data$outcome_class)
  all_res_tib <- as_tibble(unique(loaded_data[,c("exposure_class", "exposure_subclass", "person_exposed", "exposure_time", "exposure_type", "exposure_source", "exposure_dose", "model")]))
  formatted_data <- list(loaded_data,global_data$exp_classes,global_data$out_classes,all_res_tib)
  names(formatted_data) <- c("all_res","exp_classes","out_classes","all_res_tib")

  formatted_data
}

import_data_dropbox <- function(global_data){
  dropbox_links <- c("https://www.dropbox.com/s/amagzojd4xmj66l/metaphewas_model1a_extracted.RDS?dl=1",
                     "https://www.dropbox.com/s/3ey11hxpqlo6i2h/metaphewas_model1b_extracted.RDS?dl=1"
  )
  all_res <- lapply(dropbox_links,function(x) readRDS(url(x)))
  imported_data <- format_loaded_data(global_data, all_res)

  return(imported_data)
}

import_data_local <- function(global_data){
  file_paths <- c("../data/rds/metaphewas_model1a_extracted.RDS",
                  "../data/rds/metaphewas_model1b_extracted.RDS"
  )
  all_res <- lapply(file_paths,function(x) readRDS(x))
  imported_data <- format_loaded_data(global_data, all_res)

  return(imported_data)
}

create_exposure_dfs <- function(exposureclass, dat){

  if (exposureclass == "all") {
    df <- dat[dat$person_exposed!="child",]
  } else {
    df <- dat[dat$exposure_class==exposureclass&dat$person_exposed!="child",]
  }

  df$exposure_dose_ordered <- factor(df$exposure_dose,ordered=T,levels=c("light","moderate","heavy"))
  df <- df[order(df$exposure_subclass,df$exposure_time,df$exposure_dose_ordered),]
  df$exposure_subclass_time_dose <- paste(df$exposure_subclass,df$exposure_time,df$exposure_dose)
  df$exposure_subclass_time_dose<-factor(df$exposure_subclass_time_dose,ordered=T,levels=unique(df$exposure_subclass_time_dose))
  # to convert ln(OR) to cohen's d (SDM), multiply ln(OR) by sqrt(3)/pi (which is 0.5513)
  # to convert SDM to ln(OR), multiply SDM by pi/sqrt(3) (which is 1.814)
  # https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
  # https://onlinelibrary.wiley.com/doi/abs/10.1002/1097-0258(20001130)19:22%3C3127::AID-SIM784%3E3.0.CO;2-M
  df$est_SDM <- df$est
  df$est_SDM[df$outcome_type=="binary"|df$outcome_type=="ordinal"]<-df$est[df$outcome_type=="binary"|df$outcome_type=="ordinal"]*0.5513
  df$se_SDM <- df$se
  df$se_SDM[df$outcome_type=="binary"|df$outcome_type=="ordinal"]<-df$se[df$outcome_type=="binary"|df$outcome_type=="ordinal"]*0.5513
  df
}

create_outcome_dfs <- function(outcomeclass, dat){

  if (outcomeclass == "all") {
    df <- dat[dat$person_exposed!="child",]
  } else {
    df <- dat[dat$outcome_class==outcomeclass&dat$person_exposed!="child",]
  }

  df$outcome_time_ordered <- factor(df$outcome_time,ordered=T,levels=c("pregnancy","delivery","first year", "age 1-2","age 3-4","age 5-7","age 8-11","anytime in childhood"))
  df <- df[order(df$outcome_subclass1,df$outcome_subclass2,df$outcome_time_ordered),]
  df$outcome_subclass_time <- paste(df$outcome_subclass1,df$outcome_subclass2,df$outcome_time)
  df$outcome_subclass_time<-factor(df$outcome_subclass_time,ordered=T,levels=unique(df$outcome_subclass_time))
  # to convert ln(OR) to cohen's d (SDM), multiply ln(OR) by sqrt(3)/pi (which is 0.5513)
  # to convert SDM to ln(OR), multiply SDM by pi/sqrt(3) (which is 1.814)
  # https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
  # https://onlinelibrary.wiley.com/doi/abs/10.1002/1097-0258(20001130)19:22%3C3127::AID-SIM784%3E3.0.CO;2-M
  df$est_SDM <- df$est
  df$est_SDM[df$outcome_type=="binary"|df$outcome_type=="ordinal"]<-df$est[df$outcome_type=="binary"|df$outcome_type=="ordinal"]*0.5513
  df$se_SDM <- df$se
  df$se_SDM[df$outcome_type=="binary"|df$outcome_type=="ordinal"]<-df$se[df$outcome_type=="binary"|df$outcome_type=="ordinal"]*0.5513
  df
}

create_exposure_dfs <- function(exposureclass, dat){

  if (exposureclass == "all") {
    df <- dat[dat$person_exposed!="child",]
  } else {
    df <- dat[dat$exposure_class==exposureclass&dat$person_exposed!="child",]
  }

  df$exposure_dose_ordered <- factor(df$exposure_dose,ordered=T,levels=c("light","moderate","heavy"))
  df <- df[order(df$exposure_subclass,df$exposure_time,df$exposure_dose_ordered),]
  df$exposure_subclass_time_dose <- paste(df$exposure_subclass,df$exposure_time,df$exposure_dose)
  df$exposure_subclass_time_dose<-factor(df$exposure_subclass_time_dose,ordered=T,levels=unique(df$exposure_subclass_time_dose))
  # to convert ln(OR) to cohen's d (SDM), multiply ln(OR) by sqrt(3)/pi (which is 0.5513)
  # to convert SDM to ln(OR), multiply SDM by pi/sqrt(3) (which is 1.814)
  # https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
  # https://onlinelibrary.wiley.com/doi/abs/10.1002/1097-0258(20001130)19:22%3C3127::AID-SIM784%3E3.0.CO;2-M
  df$est_SDM <- df$est
  df$est_SDM[df$outcome_type=="binary"|df$outcome_type=="ordinal"]<-df$est[df$outcome_type=="binary"|df$outcome_type=="ordinal"]*0.5513
  df$se_SDM <- df$se
  df$se_SDM[df$outcome_type=="binary"|df$outcome_type=="ordinal"]<-df$se[df$outcome_type=="binary"|df$outcome_type=="ordinal"]*0.5513
  df
}

create_forest_dfs <- function(dat, exp_linker, out_linker){
  extracted_res <- dat[which(dat$exposure_linker==exp_linker &
                             dat$outcome_linker==out_linker),]

  # which cohorts contributed to the meta-analysis 
  cohorts <- unlist(strsplit(extracted_res$cohorts,split=","))
  cohorts <-str_remove(cohorts," ")

  #prepare data:
  df <- data.frame(exposure=rep(extracted_res$exposure_linker, length(cohorts)+1),
                   outcome=rep(extracted_res$outcome_linker, length(cohorts)+1),
                   cohort=c("meta",cohorts),
                   binary=c(extracted_res$outcome_type=="binary"),
                   est=c(extracted_res$est,#meta-analysis estimate
                         unlist(extracted_res[,paste0("est_",cohorts)])), #estimates for each cohort
                   se=c(extracted_res$se,#meta-analysis standard errror
                         unlist(extracted_res[,paste0("se_",cohorts)])), #standard errors for each cohort
                   n=c(extracted_res$total_n,#meta-analysis sample size
                        unlist(extracted_res[,paste0("n_",cohorts)])), #sample size for each cohort
                   P=c(extracted_res$p,#meta-analysis P-value
                       unlist(extracted_res[,paste0("p_",cohorts)])) #P-value for each cohort
                   )
  df$lci <- df$est-(1.96*df$se) #lower 95% CI
  df$uci <- df$est+(1.96*df$se) #upper 95% CI

  df$cohort<-factor(df$cohort,ordered=T,levels=c("meta",sort(cohorts,decreasing = T))) #ordering so that meta-analysis statistic comes bottom
  df$point_size <- c(1, #size 1 for meta-analysis results
                     sqrt(sqrt(1/df$se[-1]/100)) #then all other cohorts will have points sized smaller than 1, but proportionate to their contribution to the meta-analysis (i.e. the inverse of the variance)
  
  )
  df
}
