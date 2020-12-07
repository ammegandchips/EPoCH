#################################
##      Run the data check     ##
#################################

# Arguments that need to be changed for each cohort

cohort <- "ALSPAC"
location_of_dat <- paste0("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/",tolower(cohort),"/",tolower(cohort),"_pheno.rds")
location_of_extra_functions <- "~/University of Bristol/grp-EPoCH - Documents/WP3_data/3.5 preparation/common_scripts/"
save_directory <- paste0("~/University of Bristol/grp-EPoCH - Documents/WP3_data/3.5 preparation/",tolower(cohort),"/data_checks")

################################################

# the following lines should run without changes

# Load packages
 
library(ggplot2)
library(gridExtra)
library(grid)

# Add extra functions

source(paste0(location_of_extra_functions,"summarise_data_functions.r"))

# Read data and summarise size

dat<-readRDS(location_of_dat)
print(paste0("There are ",nrow(dat)," observations and ",ncol(dat)," variables in the ",cohort," dataset"))

# Check all variables:

## covariates
pdf(paste0(save_directory,"/covariates.pdf"))
try(check.variables("covs_","categorical"),silent = T)
try(check.variables("covs_","numerical"),silent = T)
dev.off()

## exposures: smoking
pdf(paste0(save_directory,"/smoking.pdf"))
try(check.variables("smoking_","categorical"),silent = T)
try(check.variables("smoking_","numerical"),silent = T)
dev.off()

## exposures: alcohol
pdf(paste0(save_directory,"/alcohol.pdf"))
try(check.variables("alcohol_","categorical"),silent = T)
try(check.variables("alcohol_","numerical"),silent = T)
dev.off()

## exposures: caffeine
pdf(paste0(save_directory,"/caffeine.pdf"))
try(check.variables("caffeine_","categorical"),silent = T)
try(check.variables("caffeine_","numerical"),silent = T)
dev.off()

## exposures: physical activity
pdf(paste0(save_directory,"/physact.pdf"))
try(check.variables("physact_","categorical"),silent = T)
try(check.variables("physact_","numerical"),silent = T)
dev.off()

## exposures: polygenic risk scores
pdf(paste0(save_directory,"/prs.pdf"))
try(check.variables("prs_","categorical"),silent = T)
try(check.variables("prs_","numerical"),silent = T)
dev.off()

## outcomes: cardiometabolic
pdf(paste0(save_directory,"/cardiometabolic.pdf"))
try(check.variables("cardio_","categorical"),silent = T)
try(check.variables("cardio_","numerical"),silent = T)
dev.off()

## outcomes: anthropometric/adiposity
pdf(paste0(save_directory,"/anthropometric.pdf"))
try(check.variables("anthro_","categorical"),silent = T)
try(check.variables("anthro_","numerical"),silent = T)
dev.off()

## outcomes: immunological
pdf(paste0(save_directory,"/immunological.pdf"))
try(check.variables("immuno_","categorical"),silent = T)
try(check.variables("immuno_","numerical"),silent = T)
dev.off()

## outcomes: psychosocial
pdf(paste0(save_directory,"/psychosocial.pdf"))
try(check.variables("neuro_","categorical"),silent = T)
try(check.variables("neuro_","numerical"),silent = T)
dev.off()
