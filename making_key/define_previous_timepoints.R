# define exposures at previous timepoints in pregnancy or before

select_previous_timepoints <- function(expclass, exptime, expparent, exptype, expsource, expsubclass){
  if(exptime =="first two postnatal years"){
    adjustment_timepoints <- c("preconception","first trimester","start of pregnancy","second trimester","third trimester")
  }else{
    if(exptime =="third trimester"){
      adjustment_timepoints <- c("preconception","first trimester","start of pregnancy","second trimester")
    }else{
      if(exptime=="second trimester"){
        adjustment_timepoints <- c("preconception","first trimester","start of pregnancy")
      }else{
        if(exptime=="first trimester|start of pregnancy"){
          adjustment_timepoints <- c("preconception")
        }else{
        adjustment_timepoints <- "none"
      }}}}
  
  if(adjustment_timepoints == "none"){
    res <- NA
  }else{
    res <- unique(key$exposure[which(key$exposure_time %in% adjustment_timepoints & key$exposure_class%in%expclass & key$person_exposed%in%expparent & key$exposure_type%in%exptype & key$exposure_source %in% expsource & key$exposure_subclass %in% expsubclass)])
  }
  res
}
