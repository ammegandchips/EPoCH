# define extra covariates regarding parent's health problems
### where the exposure is smoking and the outcome is asthma/wheeze, additional adjustment for exposed parent's asthma (to control for genetic inheritance of asthma)
### where the outcome is psychosocial, additional adjustment for exposed parent's mental health

## mother
key$extra_parent_covariates[key$exposure_class=="smoking"&key$outcome_subclass1=="asthma"&key$person_exposed=="mother"]<-paste(names(dat)[grep(names(dat),pattern="covs_asthma_mother")],collapse=",")
key$extra_parent_covariates[key$exposure_class=="smoking"&key$outcome_subclass1=="wheezing"&key$person_exposed=="mother"]<-paste(names(dat)[grep(names(dat),pattern="covs_asthma_mother")],collapse=",")
key$extra_parent_covariates[key$outcome%in%c(depression_outcomes,sdq_outcomes,social_outcomes)&key$person_exposed=="mother"]<-paste(names(dat)[grep(names(dat),pattern="covs_mentalhealth_mother|covs_mother_depression")],collapse=",")

## father
key$extra_parent_covariates[key$exposure_class=="smoking"&key$outcome_subclass1=="asthma"&key$person_exposed=="father"]<-paste(names(dat)[grep(names(dat),pattern="covs_asthma_father")],collapse=",")
key$extra_parent_covariates[key$exposure_class=="smoking"&key$outcome_subclass1=="wheezing"&key$person_exposed=="father"]<-paste(names(dat)[grep(names(dat),pattern="covs_asthma_father")],collapse=",")
key$extra_parent_covariates[key$outcome%in%c(depression_outcomes,sdq_outcomes,social_outcomes)&key$person_exposed=="father"]<-paste(names(dat)[grep(names(dat),pattern="covs_mentalhealth_father|covs_father_depression")],collapse=",")

