###############################################
# Run observational and PRS pheWAS  SUMMARIES #
###############################################

# The following script summarises all the multivariable regression analyses for EPoCH. It is actually a smaller version of the RUN_PHEWAS script
# I created it because ALSPAC sometimes doesn't run before the time limit of 6 hours on the short queue. 
# The issue is that the phewas runs but the job is killed before the summaries complete
# So this script JUST runs the summaries

########################################

# Read in arguments

args <- commandArgs(trailingOnly = TRUE)

# Set locations of scripts, data and save files

if(grepl("_FEMALE|_MALE",cohort)){
        cohortname <-unlist(strsplit(cohort,split="_"))[1]
}else{
        cohortname <- cohort
}

location_of_dat <- paste0("~/EPoCH/data/",tolower(cohortname),"_pheno.rds")
location_of_key <- paste0("~/EPoCH/data/",tolower(cohortname),"_key.rds")
location_of_extra_functions <-"https://github.com/ammegandchips/EPoCH/blob/main/phewas/"
save_directory <- paste0("~/EPoCH/results/")

# The following lines should run without changes

# Load packages

print("loading packages...")
library(tidyverse)
library(haven)
library(tableone)
library(devtools)

# load extra functions

print("loading extra functions...")

source_url(paste0(location_of_extra_functions,"summarise_reg_models.R?raw=TRUE"))
source_url(paste0(location_of_extra_functions,"run_regression_models.R?raw=TRUE"))

# Read key and data and summarise size

print("reading key...")
key<-readRDS(location_of_key)
print("reading data...")
dat<-readRDS(location_of_dat)
print(paste0("There are ",nrow(dat)," observations and ",ncol(dat)," variables in the ",cohort," dataset"))

# select sample

print("selecting sample...")
#dat <- dat[dat$covs_biological_father=="bio_dad",] ##Not totally sure we need to do this. The rationale was that all mums are genetically related to their children so we wanted all included dads to be genetically related too (else the maternal effect may appear larger than the paternal effect due to non-paternity). Also for prenatal exposures we would expect all direct paternal effects to go via the sperm, so would want biological dads. However, we're also interested in indirect effects (via the mother), in which case paternity wouldn't be important. Also we don't have a perfect measure of paternity (just maternal-report). May be better to do a sensitivity analysis restricting to biological dads (n=13036), but use all dads in the main analysis.
if("multiple_pregnancy" %in% colnames(dat)){
dat <- dat[-which(dat$multiple_pregnancy==1),] #select singleton pregnancies
}

if(grepl("_FEMALE",cohort)){
        dat <- dat[dat$covs_sex%in%c("female"),]
}
if(grepl("_MALE",cohort)){
        dat <- dat[dat$covs_sex%in%c("male"),]
}

print(paste0("There are now ",nrow(dat)," observations and ",ncol(dat)," variables in the ",cohort," dataset"))

# run phewas [MUCH OF THIS BIT IS REMOVED]

## select exposures and outcomes

###print("selecting exposures and outcomes for pheWAS...")
###exposures <- unique(key$exposure[grepl(key$exposure,pattern="_zscore|binary|ordinal|continuous")])
###outcomes <- unique(key$outcome[grepl(key$outcome,pattern="_zscore|_sds|binary")])

## run pheWAS for each model

models <- c(paste0("model",1:4,rep("a",4)),
            paste0("model",1:4,rep("b",4)),
            paste0("model",1:4,rep("c",4)))

### print("running pheWAS...")
###phewas_res <- lapply(models, 
###                     run_analysis, 
###                     exposures=exposures,
###                     outcomes=outcomes,
###                     df=dat)

# save full results

### print("saving all pheWAS results...")

###lapply(1:length(models),
###       function(i){
###       saveRDS(phewas_res[[i]],file=paste0(save_directory,cohort,"_",models[i],"_phewas.rds"))
###       })

# summarise the phewas inputs

## select exposures and outcomes

print("selecting exposures and outcomes for pheWAS data summaries...")
exposures <- unique(key$exposure)
outcomes <- unique(key$outcome[-grep(key$outcome,pattern="zscore")]) # note: different to above, here we are removing standardised variables

## summarise data input for each model

print("summarising pheWAS data...")

phewas_summary <- lapply(models, 
                     summarise_reg_models, 
                     exposures=exposures,
                     outcomes=outcomes,
                     df=dat)

# save summaries

print("saving pheWAS data summaries...")

lapply(1:length(models),
       function(i){
         saveRDS(phewas_summary[[i]],file=paste0(save_directory,cohort,"_",models[i],"_summaries.rds"))
       })

