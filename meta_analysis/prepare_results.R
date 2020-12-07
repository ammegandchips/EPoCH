# prepare cohort data

prepare_cohort_data <- function(key,results,model){
  res <- merge(results,key[,-which(colnames(key)=="person_exposed")],by=c("exposure","outcome"),all.y=F)
  res <- res[order(res$est),]
  res$exposure_dose<-NA
  res$exposure_dose[grep(res$regression_term,pattern="Light")]<-"light"
  res$exposure_dose[grep(res$regression_term,pattern="Moderate")]<-"moderate"
  res$exposure_dose[grep(res$regression_term,pattern="Heavy")]<-"heavy"
  res$exposure_dose[grep(res$regression_term,pattern="Somewhat")]<-"somewhat active"
  res$exposure_dose[grep(res$regression_term,pattern="Active")]<-"active"
  res$model_number <- substr(res$model,6,6)
  res$mutual_adjustment <- ifelse(substr(res$model,7,7)=="a","a","b")
  res$outcome_term <- paste0(res$outcome_subclass2," - ",res$outcome_time)
  res
}