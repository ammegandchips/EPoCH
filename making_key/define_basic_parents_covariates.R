# Define basic parents' covariates

mother_covariates1 <- colnames(dat)[colnames(dat) %in% c("covs_age_mother_conception","covs_ethnicity_mother_binary","covs_edu_mother","covs_occup_mother","covs_parity_mother_binary","covs_height_mother","covs_weight_mother")]
father_covariates1 <- colnames(dat)[colnames(dat) %in% c("covs_age_father_pregnancy","covs_ethnicity_father_binary","covs_edu_father","covs_occup_father","covs_height_father","covs_weight_father")]

key$basic_covariates[key$person_exposed=="mother"]<-paste0(mother_covariates1,collapse=",")
key$basic_covariates[key$person_exposed=="father"]<-paste0(father_covariates1,collapse=",")
