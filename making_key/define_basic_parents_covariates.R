## NEED TO UPDATE WITH MOBA VERSION BEFORE PUBLICATION ##
# Define basic parents' covariates 

mother_covariates1 <- colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_edu_mother","covs_occup_mother","covs_parity_mother_binary")]
father_covariates1 <- colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy","covs_edu_father_anyreport","covs_occup_father_anyreport")]

key$basic_covariates[key$person_exposed=="mother"]<-paste0(mother_covariates1,collapse=",")
key$basic_covariates[key$person_exposed=="partner"]<-paste0(father_covariates1,collapse=",")

key$other_parents_covariates[key$person_exposed=="mother"]<-paste0(father_covariates1,collapse=",")
key$other_parents_covariates[key$person_exposed=="partner"]<-paste0(mother_covariates1,collapse=",")
  
key$basic_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="mother"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_parity_mother_binary")],collapse=",")
key$basic_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="partner"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy")],collapse=",")
  
key$other_parents_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="mother"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy")],collapse=",")
key$other_parents_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="partner"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_parity_mother_binary")],collapse=",")

if( TRUE %in% grepl(key$exposure,pattern="prs_score_father")){
key$other_parents_covariates[key$exposure_class =="polygenic risk score" & key$person_exposed=="mother"] <- paste0(colnames(dat)[colnames(dat) %in% paste0("dadpc",1:10)],collapse=",")
}
key$other_parents_covariates[key$exposure_class =="polygenic risk score" & key$person_exposed=="partner"] <- paste0(colnames(dat)[colnames(dat) %in% paste0("mumpc",1:10)],collapse=",")

key$basic_covariates[which(key$exposure_subclass%in%c("polygenic risk score")&key$person_exposed=="mother")]<-
  paste0(key$covariates_model1a[which(key$exposure_subclass%in%c("polygenic risk score")&key$person_exposed=="mother")],
         ",",paste0(names(dat)[grep(names(dat),pattern="mumpc")],collapse=","))

key$basic_covariates[which(key$exposure_subclass%in%c("polygenic risk score")&key$person_exposed=="partner")]<-
  paste0(key$covariates_model1a[which(key$exposure_subclass%in%c("polygenic risk score")&key$person_exposed=="partner")],
         ",",paste0(names(dat)[grep(names(dat),pattern="dadpc")],collapse=","))

