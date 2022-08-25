# function to summarise the regression models

summarise_reg_models <- function(exposures,outcomes,model_number,df){
  key_here <- key[which(key$exposure%in%exposures & key$outcome%in%outcomes),c("exposure","outcome","exposure_type","outcome_type",paste0("covariates_",model_number),"person_exposed")]
  list_of_summaries <- apply(key_here,1,function(x){
    exposure <- as.character(x[1])
    outcome <- as.character(x[2])
    exposure_type <- as.character(x[3])
    outcome_type <- as.character(x[4])
    adjustment_vars <- na.omit(unlist(strsplit(as.character(x[5]),split=",")))
    adjustment_vars <- str_remove_all(adjustment_vars,"_zscore")
    adjustment_vars <- adjustment_vars[adjustment_vars %in% colnames(df)]
    df_here <- zap_labels(df[,c(exposure,outcome,adjustment_vars)])
    df_here <- na.omit(df_here)
    if(exposure_type%in%c("binary","ordinal")){
      try(kableone(CreateTableOne(vars=c(outcome,adjustment_vars),strata=exposure,data=df_here,factorVars=c(outcome,adjustment_vars)[grep("sex|ethnicity|edu|occup|binary",c(outcome,adjustment_vars))],test=F,smd=F,addOverall=T))) 
    }else{
      try(kableone(CreateTableOne(vars=c(exposure,outcome,adjustment_vars),data=df_here,factorVars=c(exposure,outcome,adjustment_vars)[grep("sex|ethnicity|edu|occup|binary",c(exposure,outcome,adjustment_vars))],test=F,smd=F)))
    }
  })
  names(list_of_summaries)<-apply(key_here,1,function(x){
    paste0(as.character(x[1]),".",as.character(x[2]),".",model_number)
  })
  list_of_summaries
}