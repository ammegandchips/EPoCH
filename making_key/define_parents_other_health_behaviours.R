# function for selecting exposed parent's other health behaviours

select_other_health_behaviours <- function(expclass, exptime, expparent, exptype, expsource, expsubclass){
  if(expsubclass=="polygenic risk score"|expclass=="snps"|expclass=="socioeconomic position"|expclass=="diet"){
    res<-NA
  }else{
    if(expclass=="physical activity"){
      adjustment_classes <- c("smoking", "alcohol consumption")
    }else{
      if(expclass =="smoking"){
        adjustment_classes <- c("caffeine consumption", "alcohol consumption")
      }else{
        if(expclass =="alcohol consumption"){
          adjustment_classes <- c("caffeine consumption", "smoking")
        }else{      
          if(expclass=="caffeine consumption"){
            adjustment_classes <- c("alcohol consumption", "smoking")
          }}}}
    adjustment_classes
    if(is.na(adjustment_classes)==FALSE){
      
      if(exptime%in%c("first trimester","second trimester","third trimester","ever in pregnancy")){
        adjustment_timepoint <- "ever in pregnancy"
      }else{
        adjustment_timepoint <- "ever in life"
      }
      
      res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source %in% expsource & key$exposure_subclass=="basic")])
      #if ever in life doesn't exist, use preconception:
      if(length(res1)==0){
        adjustment_timepoint <- "preconception"
        res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source %in% expsource & key$exposure_subclass=="basic")])
      }
      #relax source
      if(length(res1)==0){
        res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      #relax source and use preconception
      if(length(res1)==0){
        adjustment_timepoint <- "preconception"
        res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      #or if preconception doesn't exist, use postnatal:
      if(length(res1)==0){
        adjustment_timepoint <- "first two postnatal years"
        res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source %in% expsource & key$exposure_subclass=="basic")])
      }
      #relax source and use postnatal
      if(length(res1)==0){
        adjustment_timepoint <- "first two postnatal years"
        res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      #if all else fails, use one timepoint from during pregnancy:
      if(length(res1)==0){
        adjustment_timepoint <- c("ever in pregnancy","first trimester","second trimester","third trimester")
        res1 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint[1] & key$exposure_class%in%adjustment_classes[1] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      
      if(exptime%in%c("first trimester","second trimester","third trimester","ever in pregnancy")){
        adjustment_timepoint <- "ever in pregnancy"
      }else{
        adjustment_timepoint <- "ever in life"
      }
      
      res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source %in% expsource & key$exposure_subclass=="basic")])
      #if ever in life doesn't exist, use preconception:
      if(length(res2)==0){
        adjustment_timepoint <- "preconception"
        res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source %in% expsource & key$exposure_subclass=="basic")])
      }
      #relax source
      if(length(res2)==0){
        res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      #relax source and use preconception
      if(length(res2)==0){
        adjustment_timepoint <- "preconception"
        res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      #or if preconception doesn't exist, use postnatal:
      if(length(res2)==0){
        adjustment_timepoint <- "first two postnatal years"
        res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source %in% expsource & key$exposure_subclass=="basic")])
      }
      #relax source and use postnatal
      if(length(res2)==0){
        adjustment_timepoint <- "first two postnatal years"
        res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])
      }
      #if all else fails, use one timepoint from during pregnancy:
      if(length(res2)==0){
        adjustment_timepoint <- c("ever in pregnancy","first trimester","second trimester","third trimester")
        res2 <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoint[1] & key$exposure_class%in%adjustment_classes[2] & key$person_exposed%in%expparent & key$exposure_type=="binary" & key$exposure_source=="self-report or measured" & key$exposure_subclass=="basic")])[1]
      }
      
      res<-c(res1,res2)
      
    }else{
      res<-NA
    }}
  res
}