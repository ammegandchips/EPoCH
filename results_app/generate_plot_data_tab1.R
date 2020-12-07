generate_plot_data_tab1 <- function(key_here,df,models,selected_exposure_type,selected_exposure_dose){

plot_data <- df[which(df$exposure %in% key_here$exposure & df$outcome %in% key_here$outcome & df$model %in% models),]
plot_data <- left_join(plot_data,key_here,by.x=c("exposure","outcome"))
plot_data <- plot_data[order(plot_data$est),]
plot_data$exposure_dose<-NA
plot_data$exposure_dose[grep(plot_data$regression_term,pattern="Light")]<-"light"
plot_data$exposure_dose[grep(plot_data$regression_term,pattern="Moderate")]<-"moderate"
plot_data$exposure_dose[grep(plot_data$regression_term,pattern="Heavy")]<-"heavy"
plot_data$exposure_dose[grep(plot_data$regression_term,pattern="Somewhat")]<-"somewhat active"
plot_data$exposure_dose[grep(plot_data$regression_term,pattern="Active")]<-"active"
plot_data$model_number <- substr(plot_data$model,6,6)
plot_data$model_number[plot_data$model_number=="1"]<-"model 1"
plot_data$model_number[plot_data$model_number=="2"]<-"model 2"
plot_data$model_number[plot_data$model_number=="3"]<-"model 3"
plot_data$mutual_adjustment <- ifelse(substr(plot_data$model,7,7)=="a","not adjusted for other parent's exposure","adjusted for other parent's exposure")
if(grepl(plot_data$exposure[1],pattern="prs")){
plot_data$mutual_adjustment <- ifelse(substr(plot_data$model,7,7)=="a","not adjusted for other mother/child PRS","adjusted for mother/child PRS")
}
plot_data$exposure_dose <-factor(plot_data$exposure_dose, levels=c("light","moderate","heavy","somewhat active","active"),ordered=T)
plot_data$model_number <-factor(plot_data$model_number, levels=c("model 1","model 2","model 3"),ordered=T)
if(grepl(plot_data$exposure[1],pattern="prs")){
  plot_data$mutual_adjustment <-factor(plot_data$mutual_adjustment, levels=c("not adjusted for other mother/child PRS","adjusted for mother/child PRS"),ordered=T)
}else{
plot_data$mutual_adjustment <-factor(plot_data$mutual_adjustment, levels=c("not adjusted for other parent's exposure","adjusted for other parent's exposure"),ordered=T)
}
plot_data$outcome_class <-factor(plot_data$outcome_class,levels=c("body size and composition","cardiometabolic outcomes", "immunological outcomes","psychosocial and cognitive outcomes","negative control outcomes"),ordered=T)
plot_data$outcome_time <- factor(plot_data$outcome_time,levels=c("at birth","age 1 or 2","age 3 or 4","age 5, 6 or 7","age 8, 9 or 10","any time in childhood"),ordered=T)
plot_data$exposure_dose <-droplevels(plot_data$exposure_dose)
plot_data$model_number <-droplevels(plot_data$model_number)
plot_data$mutual_adjustment <-droplevels(plot_data$mutual_adjustment)
plot_data$outcome_time <-droplevels(plot_data$outcome_time)
plot_data$outcome_class <-droplevels(plot_data$outcome_class)
plot_data$person_exposed <- factor(plot_data$person_exposed, ordered=T,levels=c("mother","father","child"))
plot_data$person_exposed<-droplevels(plot_data$person_exposed)
#plot_data<-plot_data[order(plot_data$model_number,plot_data$outcome_class,plot_data$outcome_subclass1,plot_data$outcome_time,plot_data$exposure_dose,plot_data$mutual_adjustment),]
plot_data$outcome_term <- paste0(plot_data$outcome_subclass2," - ",plot_data$outcome_time)
plot_data$outcome_term <-factor(plot_data$outcome_term,levels=unique(plot_data$outcome_term),ordered=T)
if(selected_exposure_type=="ordinal"){
  plot_data<-droplevels(plot_data[plot_data$exposure_dose==selected_exposure_dose,])
}
plot_data$mutual_adjustment <- as.character(plot_data$mutual_adjustment)
plot_data
}