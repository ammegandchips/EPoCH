library(shiny)
library(tidyverse)
library(plotly)
library(shinycssloaders)
library(shinyjs)
library(shinyTree)

#Generate a dataframe matching the model names to their IDs (essentially "Model 1a" to "model1a" etc)
df_models <- data.frame(name=paste0("Model ",as.vector(outer(1:4, letters[1:3], paste0))),
                        shortname=paste0("model",as.vector(outer(1:4, letters[1:3], paste0)))
)

# Manhattan functions
## For X axis = exposures
create_exposure_manhattan_dfs <- function(exposureclass,dat){
  df <- dat[dat$exposure_class==exposureclass&dat$person_exposed!="child",]
  df$exposure_dose_ordered <- factor(df$exposure_dose,ordered=T,levels=c("light","moderate","heavy"))
  df <- df[order(df$exposure_subclass,df$exposure_time,df$exposure_dose_ordered),]
  df$exposure_subclass_time_dose <- paste(df$exposure_subclass,df$exposure_time,df$exposure_dose)
  df$exposure_subclass_time_dose<-factor(df$exposure_subclass_time_dose,ordered=T,levels=unique(df$exposure_subclass_time_dose))
  df
}

create_exposure_manhattan_plot <- function(df){
  adj_pthreshold <- 0.05/nrow(df)
  p <- ggplot(df,
              aes(Estimate=est,P=p,Outcome=outcome_linker,Cohorts=cohorts,N=total_n,
                  x=exposure_subclass_time_dose,y=-log10(p)
              ))+
    geom_jitter(aes(colour=outcome_class),alpha=0.5,size=0.5)+
    facet_grid(person_exposed~.)+
    xlab("")+
    theme_classic()+
    scale_colour_brewer(palette = "Dark2")+
    theme(axis.text.x = element_text(angle = 90,hjust=1))+
    geom_hline(yintercept = -log10(adj_pthreshold),linetype="dashed",colour="grey40")
  ggplotly(p)
}

## For X axis = outcomes
create_outcome_manhattan_dfs <- function(outcomeclass,dat){
  df <- dat[dat$outcome_class==outcomeclass&dat$person_exposed!="child",]
  df$outcome_time_ordered <- factor(df$outcome_time,ordered=T,levels=c("pregnancy","delivery","first year", "age 1-2","age 3-4","age 5-7","age 8-11","anytime in childhood"))
  df <- df[order(df$outcome_subclass1,df$outcome_subclass2,df$outcome_time_ordered),]
  df$outcome_subclass_time <- paste(df$outcome_subclass1,df$outcome_subclass2,df$outcome_time)
  df$outcome_subclass_time<-factor(df$outcome_subclass_time,ordered=T,levels=unique(df$outcome_subclass_time))
  df
}

create_outcome_manhattan_plot <- function(df){
  adj_pthreshold <- 0.05/nrow(df)
  p <- ggplot(df,
              aes(Estimate=est,P=p,Exposure=exposure_linker,Cohorts=cohorts,N=total_n,
                  x=outcome_subclass_time,y=-log10(p)
              ))+
    geom_jitter(aes(colour=exposure_class),alpha=0.5,size=0.5)+
    facet_grid(person_exposed~.)+
    xlab("")+
    theme_classic()+
    scale_colour_brewer(palette = "Dark2")+
    theme(axis.text.x = element_text(angle = 90,hjust=1))+
    geom_hline(yintercept = -log10(adj_pthreshold),linetype="dashed",colour="grey40")
  ggplotly(p)
}