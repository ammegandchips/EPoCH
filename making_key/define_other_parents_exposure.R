# define other parent's exposure

select_other_parents_exposure <- function(expclass, exptime, expparent, exptype, expsource, expsubclass){
  
  adjustment_parent <- ifelse(expparent=="mother","partner","mother")
  
  #basic variable
  basic <- "active smoking"
  if(expclass=="alcohol consumption"){
    basic <- "any drinking"
  }
  if(expclass=="caffeine consumption"){
    basic <- "any source"
  }
  if(expclass=="physical activity"){
    basic <- "basic"
  }
  ##
  
  ## adjustment source
  adjustment_source <- ifelse(expparent=="mother","reported by self or study mother","self-reported")
  
  if(expsubclass=="snps"){
    res<-NA
  }else{
    if(expsubclass=="polygenic risk score"){
      res <- unique(key$exposure[key$exposure_subclass==expsubclass & key$person_exposed%in%adjustment_parent & key$exposure_class%in%expclass & key$exposure_time%in%exptime])
      res <- res[grep(res,pattern="zscore")]
    }else{

      # take the exposure where everything apart from the parent is the same:
      res <- unique(key$exposure[which(key$exposure_time %in% exptime & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      
      # if that doesn't exist because the exposure subclass doesn't exist for the other parent (e.g. passive smoking is only available for mothers), relax the requirement for the subclass to be the same by taking the basic exposure instead:
      if(length(res)==0 & expsubclass !=basic) {
        res <- unique(key$exposure[which(key$exposure_time%in% exptime & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # # if that doesn't exist because the exposure source doesn't exist for the other parent (e.g. maternal-report is only available for fathers), relax the requirement for the source to be the same:
      # if(length(res)==0 &expsource!="self-reported") {
      #   res <- unique(key$exposure[which(key$exposure_time%in% exptime & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass%in%expsubclass)])
      # }
      # # if that doesn't exist, relax the requirement for both the source and the subclass to be the same:
      # if(length(res)==0) {
      #   res <- unique(key$exposure[which(key$exposure_time%in% exptime & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      # }
      
      
      ## TAKE EVER DURING PREGNANCY
      # if that doesn't exist, specify that we need the same subclass, but relax the timing so that we take 'ever during pregnancy' (if the main exposure is during pregnancy)
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy"))  {
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # if that doesn't exist, take ever in pregnancy but relax the requirement for the subclass to be the same
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") &expsubclass!=basic)  {
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # if that doesn't exist, take 'ever during pregnancy' but relax the requirement for the same 'exposure type', so it can be binary, ordinal or numerical (keep the subclass the same):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy"))  {
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","ordinal","numerical") & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # if that doesn't exist, take 'ever during pregnancy' but relax the requirement for the source of the data (i.e. maternal-report or measured/self-reprt) to be the same, (keep the subclass and exposure type the same):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy")&expsource!="self-reported")  {
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # if that doesn't exist, take 'ever during pregnancy', but relax the requirement for the subclass to be the same AND the exposure type to be the same (keep exposure source the same):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") &expsubclass!=basic)  {
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","ordinal","numerical") & key$exposure_source %in% adjustment_source & key$exposure_subclass ==basic)])
      }
      # if that doesn't exist, take 'ever during pregnancy', but relax the requirement for the subclass to be the same AND the exposure type to be the same AND the exposure source to be the same:
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") &expsubclass!=basic&expsource!="self-reported")  {
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","ordinal","numerical") & key$exposure_source %in% adjustment_source & key$exposure_subclass ==basic)])
      }
      
      ## TAKE ANY TIMEPOINT DURING PREGNANCY
      # if that doesn't exist, take any timepoint during pregnancy (with the same exposure type and subclass):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy"))  {
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # if that doesn't exist, take any timepoint during pregnancy, but relax the requirement for the same subclass (but keep the same exposure type):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") &expsubclass!=basic)  {
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # if that doesn't exist, take any timepoint during pregnancy but relax the requirement for the same exposure type (but keep the subclass the same):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy"))  {
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","ordinal","numerical") & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # if that doesn't exist, take any timepoint during pregnancy but relax the requirement for the same exposure source (but keep the subclass and type the same):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy")&expsource!="self-reported")  {
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # if that doesn't exist, take any timepoint during pregnancy, but relax the requirement for the same subclass AND the same exposure type (keep exposure source the same):
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") &expsubclass!=basic)  {
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","ordinal","numerical") & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # if that doesn't exist, take any timepoint during pregnancy, but relax the requirement for the same subclass AND the same exposure type AND same exposure source:
      if(length(res)==0 & exptime %in% c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") &expsubclass!=basic&expsource!="self-reported")  {
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","ordinal","numerical") & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      
      ## TAKE EVER IN LIFE
      # if that doesn't exist, relax the requirement for the exposure to be in pregnancy (i.e. take ever in life). Ever in life is always binary. At this stage we can also apply to exposures occuring outside of pregnancy:
      if(length(res)==0 ){
        res <- unique(key$exposure[which(key$exposure_time=="ever in life" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type=="binary" & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax the requirement for the exposure subclass to be the same
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time=="ever in life" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type=="binary" & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # relax the requirement for the exposure source to be the same
      if(length(res)==0){
        res <- unique(key$exposure[which(key$exposure_time=="ever in life" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type=="binary" & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax both
      if(length(res)==0){
        res <- unique(key$exposure[which(key$exposure_time=="ever in life" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type=="binary" & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      
      ## IF EVER IN LIFE DOESN'T EXIST (e.g. for caffeine or physical activity) AND EXPOSURE HAPPENS OUTSIDE OF PREGNANCY, TAKE EVER IN PREGNANCY (doesn't have to be binary)
      if(length(res)==0 ){
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax the requirement for the exposure subclass to be the same
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # relax the requirement for the exposure source to be the same
      if(length(res)==0){
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax the requirement for the exposure type to be the same
      if(length(res)==0){
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","numerical","ordinal") & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax subclass and type
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","numerical","ordinal") & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # relax subclass and type and source
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time=="ever in pregnancy" & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","numerical","ordinal") & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      
      ## IF EVER IN LIFE DOESN'T EXIST (e.g. for caffeine or physical activity) AND EVER IN PREGNANCY DOESN'T EXIST AND EXPOSURE HAPPENS OUTSIDE OF PREGNANCY, TAKE A PREGNANCY TIMEPOINT (doesn't have to be binary)
      if(length(res)==0 ){
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax the requirement for the exposure subclass to be the same
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # relax the requirement for the exposure source to be the same
      if(length(res)==0){
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type==exptype & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax the requirement for the exposure type to be the same
      if(length(res)==0){
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","numerical","ordinal") & key$exposure_source %in% adjustment_source & key$exposure_subclass %in% expsubclass)])
      }
      # relax subclass and type
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","numerical","ordinal") & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
      # relax subclass and type and source
      if(length(res)==0&expsubclass!=basic){
        res <- unique(key$exposure[which(key$exposure_time%in%c("first trimester", "start of pregnancy","second trimester","third trimester","ever in pregnancy") & key$exposure_class%in%expclass & key$person_exposed%in%adjustment_parent & key$exposure_type%in%c("binary","numerical","ordinal") & key$exposure_source %in% adjustment_source & key$exposure_subclass==basic)])
      }
    }
  }
  res
}
