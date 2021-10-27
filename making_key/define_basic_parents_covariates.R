# Define basic parents' covariates 

  mother_covariates1 <- colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_edu_mother","covs_occup_mother","covs_parity_mother_binary")]
  father_covariates1 <- colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy","covs_edu_father","covs_occup_father")]

  key$basic_covariates[key$person_exposed=="mother"]<-paste0(mother_covariates1,collapse=",")
  key$basic_covariates[key$person_exposed=="father"]<-paste0(father_covariates1,collapse=",")

  key$other_parents_covariates[key$person_exposed=="mother"]<-paste0(father_covariates1,collapse=",")
  key$other_parents_covariates[key$person_exposed=="father"]<-paste0(mother_covariates1,collapse=",")
  
  key$basic_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="mother"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_parity_mother_binary")],collapse=",")
  key$basic_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="father"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy")],collapse=",")
  
  key$other_parents_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="mother"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy")],collapse=",")
  key$other_parents_covariates[key$exposure_class =="socioeconomic position" & key$person_exposed=="father"] <- paste0(colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_parity_mother_binary")],collapse=",")



