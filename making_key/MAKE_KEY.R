########################################
# Making the "key" for cohort analyses #
########################################

# The following code sets up a 'key' that can be used to work out what 
# covariates should be adjusted for in each exposure/outcome combination. 
# It can also be used to feed tidier variable names to plot functions.

########################################

# Arguments that need to be changed for each cohort

args <- commandArgs(trailingOnly = TRUE)
cohort <- toString(args[1])
location_of_dat <- paste0("~EPoCH/data/",tolower(cohort),"_pheno.rds")
location_of_extra_functions <-"https://github.com/ammegandchips/EPoCH/blob/main/making_key/"
#location_of_extra_functions <- "~/University of Bristol/grp-EPoCH - Documents/WP4_analysis/making_key/"
save_directory <- paste0("~EPoCH/results/",tolower(cohort),"_pheno.rds")

################################################

# the following lines should run without changes

# Load packages

library(dplyr)
library(devtools)

# Read data and summarise size

dat<-readRDS(location_of_dat)
print(paste0("There are ",nrow(dat)," observations and ",ncol(dat)," variables in the ",cohort," dataset"))

# create lists of all exposures and outcomes
source_url(paste0(location_of_extra_functions,"list_exposures_outcomes.R?raw=TRUE"))

# cross all exposure/outcome combinations
key <- bind_rows(lapply(all_exposures[all_exposures %in% colnames(dat)],function(x) tibble(x,all_outcomes[all_outcomes %in% colnames(dat)])))
names(key)<-c("exposure","outcome")

# add extra information about each exposure/outcome

key$exposure_class <- NA
key$exposure_subclass <- NA
key$exposure_time <- NA
key$person_exposed <- NA
key$exposure_source <- NA
key$exposure_type <- NA
key$outcome_class <- NA
key$outcome_subclass1 <- NA
key$outcome_subclass2<-NA
key$outcome_time <- NA
key$outcome_type <- NA

source_url(paste0(location_of_extra_functions,"specify_classes.R?raw=TRUE"))

# define model 1a covariates (age and sex of child, + genetic principal components if exposure is PRS)

## child age at outcome
### might be an important source of variation for some outcomes. 
### Not necessry for binary things like asthma and eczema since we're 
### already splitting outcomes into age stages, 
### but important for things where there's likely to be variation within stage, 
### like BMI, height, weight, waist circumference, head circumference, IQ, SDQ measures, SCDC and  MFQ.

key$child_age_covariates <- NA
source(paste0(location_of_extra_functions,"define_child_age.R?raw=TRUE"))

## add sex of child

key$covariates_model1a <- NA
key$covariates_model1a <- paste(key$child_age_covariates,"covs_sex",sep=",")

## if exposure is a PRS, add the genetic PCs
key$covariates_model1a[which(key$exposure_subclass%in%c("polygenic risk score","snps")&key$person_exposed=="child")]<-
  paste0(key$covariates_model1a[which(key$exposure_subclass%in%c("polygenic risk score","snps")&key$person_exposed=="child")],
         ",",paste0(names(dat)[grep(names(dat),pattern="childpc")],collapse=","))

key$covariates_model1a[which(key$exposure_subclass%in%c("polygenic risk score","snps")&key$person_exposed=="mother")]<-
  paste0(key$covariates_model1a[which(key$exposure_subclass%in%c("polygenic risk score","snps")&key$person_exposed=="mother")],
         ",",paste0(names(dat)[grep(names(dat),pattern="mumpc")],collapse=","))

# define model 2a covariates 
## most models: 1a + age, SEP, height, weight, parity if exposed parent = mother
## plus other health behaviours 
  ### (e.g. if exposure is smoking, adjust for alcohol and caffeine 
  ### at any point in pregnancy or postnatal) No need to adjust for physical activity now 
  ### (seems unlikely it would influence caffeine for example), 
  ### but if/when we add the dietary exposures, we should adjust for PA then. 
  ### However, it is necessary to adjust for alcohol and smoking when looking at physical activity as the main exposure.
## plus, where necessary, exposed parent's health/disease
  ### where the exposure is smoking and the outcome is asthma/wheeze, additional adjustment for exposed parent's asthma (to control for genetic inheritance of asthma)
  ### where the outcome is psychosocial, additional adjustment for exposed parent's mental health
## where the exposure is a PRS, model 1a and 1b will suffice

key$basic_covariates <- NA
source_url(paste0(location_of_extra_functions,"define_basic_parents_covariates.R?raw=TRUE"))

key$other_health_behaviours <- NA
source_url(paste0(location_of_extra_functions,"define_parents_other_health_behaviours.R?raw=TRUE"))
x<-apply(key[,c("exposure_class","exposure_time","person_exposed","exposure_type","exposure_source","exposure_subclass")],1,function(x) select_other_health_behaviours(expclass=x[1],exptime=x[2],expparent=x[3],exptype=x[4],expsource=x[5],expsubclass=x[6]))
key$other_health_behaviours<-unlist(lapply(x,paste,collapse=","))
rm(x)

key$extra_parent_covariates <-NA
source_url(paste0(location_of_extra_functions,"define_parents_disease_covariates.R?raw=TRUE"))

key$covariates_model2a <- NA
key$covariates_model2a <- apply(key[,c("covariates_model1a","basic_covariates","other_health_behaviours","extra_parent_covariates")],1,function(x) paste(na.omit(x),collapse=","))

key$covariates_model2a[key$exposure_subclass=="polygenic risk score"]<-NA

# define model 3a covariates (2a + exposure in previous timepoints where necessary)
## e.g. if the exposure is third trimester smoking, adjust for 1st and 2nd trimester smoking

key$previous_exposure_timepoints <- NA
source_url(paste0(location_of_extra_functions,"define_previous_timepoints.R?raw=TRUE"))

x<-apply(key[,c("exposure_class","exposure_time","person_exposed","exposure_type","exposure_source","exposure_subclass")],1,function(x) select_previous_timepoints(expclass=x[1],exptime=x[2],expparent=x[3],exptype="binary",expsource=x[5],expsubclass=x[6]))
key$previous_exposure_timepoints<-unlist(lapply(x,paste,collapse=","))
rm(x)

key$covariates_model3a <- NA
key$covariates_model3a <- apply(key[,c("covariates_model2a","previous_exposure_timepoints")],1,function(x) paste(na.omit(x),collapse=","))

key$covariates_model3a[key$exposure_subclass=="polygenic risk score"]<-NA

# define model 4a covariates (2a + possible mediators: gest age, birthweight, child passive smoke before 2, child caffeine before 2, child alcohol before 2)

key$potential_mediators<-NA
source_url(paste0(location_of_extra_functions,"define_potential_mediators.R?raw=TRUE"))

key$covariates_model4a <- NA
key$covariates_model4a <- apply(key[,c("covariates_model2a","potential_mediators")],1,function(x) paste(na.omit(x),collapse=","))

key$covariates_model4a[key$exposure_subclass=="polygenic risk score"]<-NA

# define model 1b/2b/3b/4b covariates (1a/2b/3b/4b + other parent's exposure)

key$other_parents_exposure <- NA
source_url(paste0(location_of_extra_functions,"define_other_parents_exposure.R?raw=TRUE"))

x<-apply(key[,c("exposure_class","exposure_time","person_exposed","exposure_type","exposure_source","exposure_subclass")],1,function(x) select_other_parents_exposure(expclass=x[1],exptime=x[2],expparent=x[3],exptype=x[4],expsource=x[5],expsubclass=x[6]))
key$other_parents_exposure<-unlist(lapply(x,paste,collapse=","))
rm(x)

key$covariates_model1b <- apply(key[,c("covariates_model1a","other_parents_exposure")],1,function(x) paste(na.omit(x),collapse=","))
key$covariates_model2b <- apply(key[,c("covariates_model2a","other_parents_exposure")],1,function(x) paste(na.omit(x),collapse=","))
key$covariates_model3b <- apply(key[,c("covariates_model3a","other_parents_exposure")],1,function(x) paste(na.omit(x),collapse=","))
key$covariates_model4b <- apply(key[,c("covariates_model4a","other_parents_exposure")],1,function(x) paste(na.omit(x),collapse=","))

key$covariates_model2b[key$exposure_subclass=="polygenic risk score"]<-NA
key$covariates_model3b[key$exposure_subclass=="polygenic risk score"]<-NA
key$covariates_model4b[key$exposure_subclass=="polygenic risk score"]<-NA

# remove NAs in all lists of covariates

key$covariates_model1a <- unlist(lapply(lapply(str_split(key$covariates_model1a,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model2a <- unlist(lapply(lapply(str_split(key$covariates_model2a,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model3a <- unlist(lapply(lapply(str_split(key$covariates_model3a,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model4a <- unlist(lapply(lapply(str_split(key$covariates_model4a,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model1b <- unlist(lapply(lapply(str_split(key$covariates_model1b,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model2b <- unlist(lapply(lapply(str_split(key$covariates_model2b,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model3b <- unlist(lapply(lapply(str_split(key$covariates_model3b,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))
key$covariates_model4b <- unlist(lapply(lapply(str_split(key$covariates_model4b,pattern=","),function(x) x[!x=="NA"]),paste,collapse=","))

# remove unnecessary columns

key <- key[,-which(colnames(key) %in% c("child_age_covariates","basic_covariates","other_health_behaviours","extra_parent_covariates","previous_exposure_timepoints","potential_mediators","other_parents_exposure"))]

# save key

saveRDS(key,paste0(save_directory,"/",tolower(cohort),"_key.rds"))

