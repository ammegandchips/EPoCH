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

#######################
# Manhattan functions #
#######################

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

#####################
# Volcano functions #
#####################

# by exposure
create_exposure_volcano_dfs <- function(exposureclass,dat){
  df <- dat[dat$exposure_class==exposureclass&dat$person_exposed!="child",]
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

create_exposure_volcano_plot <- function(df){
  pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-0.05))]-1
  adj_pthreshold <- 0.05/nrow(df)
  adj_pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-adj_pthreshold))]-1
  Plot <- ggplot(df,
                 aes(Estimate=est,P=p,Outcome=outcome_linker,Cohorts=cohorts,N=total_n,
                     x=est_SDM,y=rank(-log10(p)),Exposure=exposure_linker
                 ))+
    geom_point(aes(colour=outcome_class),size=0.5,alpha=0.5)+
    geom_vline(xintercept = 0,colour="grey40")+
    theme_classic()+
    scale_colour_brewer(palette = "Dark2")+
    xlab("Standardised effect estimate")+
    ylab("Ranked -log10(P)")+
    facet_grid(.~person_exposed)+  
    coord_cartesian(xlim=c(-0.75,0.75))+
    geom_hline(yintercept = pthreshold_rank,linetype="dashed",colour="blue")+
    geom_hline(yintercept = adj_pthreshold_rank,linetype="dashed",colour="red")
  ggplotly(Plot,tooltip=c("P","Estimate","Outcome","Exposure","Cohorts","N"))
}

# by outcome

create_outcome_volcano_dfs <- function(outcomeclass,dat){
  df <- dat[dat$outcome_class==outcomeclass&dat$person_exposed!="child",]
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

create_outcome_volcano_plot <- function(df){
  pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-0.05))]-1
  adj_pthreshold <- 0.05/nrow(df)
  adj_pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-adj_pthreshold))]-1
  Plot <- ggplot(df,
                 aes(Estimate=est,P=p,Outcome=outcome_linker,Cohorts=cohorts,N=total_n,
                     x=est_SDM,y=rank(-log10(p)),Exposure=exposure_linker
                 ))+
    geom_point(aes(colour=exposure_class),size=0.5,alpha=0.5)+
    geom_vline(xintercept = 0,colour="grey40")+
    theme_classic()+
    scale_colour_brewer(palette = "Dark2")+
    xlab("Standardised effect estimate")+
    ylab("Ranked -log10(P)")+
    facet_grid(.~person_exposed)+  
    coord_cartesian(xlim=c(-0.75,0.75))+
    geom_hline(yintercept = pthreshold_rank,linetype="dashed",colour="blue")+
    geom_hline(yintercept = adj_pthreshold_rank,linetype="dashed",colour="red")
  ggplotly(Plot,tooltip=c("P","Estimate","Outcome","Exposure","Cohorts","N"))
}

#######################
# Coef plot functions #
#######################

# output$expCoefPlot <- renderPlotly({
#   exposures <- bind_rows(res_mod1(),
#                          res_mod2(),
#                          res_mod3(),
#                          res_mod4())
#   exposures <- exposures[,c(1,2,4,3,5,6,7,8)]
#   exposure_linkers <- apply(exposures[,1:6],1,paste0,collapse="-")
#   exposure_linkers <- sapply(1:4,function(i) paste(unlist(exposure_linkers)[i],unlist(exposures[i,7])))
#   df1 <- key[which(key$exposure_linker==exposure_linkers[1]&key$model==exposures$model[1]),]
#   df2 <- key[which(key$exposure_linker==exposure_linkers[2]&key$model==exposures$model[2]),]
#   df3 <- key[which(key$exposure_linker==exposure_linkers[3]&key$model==exposures$model[3]),]
#   df4 <- key[which(key$exposure_linker==exposure_linkers[4]&key$model==exposures$model[4]),]
#   df <- list(df1,df2,df3,df4)
#   names(df) <-c("var1","var2","var3","var4")
#   df <- bind_rows(df,.id="Variable")
#   df <- df[which(df$outcome_class==input$out_class_expcoef),]
#   ggplotly(ggplot(df,aes(x=est,y=outcome_linker))+geom_point()+facet_grid(.~Variable))
#   
# })
# 
