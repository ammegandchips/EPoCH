#################################
##      Run the data check     ##
#################################

# Read in arguments

args <- commandArgs(trailingOnly = TRUE)
cohort <- toString(args[1])

# Set locations of scripts, data and save files

location_of_dat <- paste0("~/EPoCH/data/",tolower(cohort),"_pheno.rds")
location_of_extra_functions <-"https://github.com/ammegandchips/EPoCH/blob/main/data_prep/check_prepared_data/"
#location_of_extra_functions <- "~/University of Bristol/grp-EPoCH - Documents/WP4_analysis/making_key/"
save_directory <- paste0("~/EPoCH/results/")

# Load packages

print("loading packages...")
 
library(ggplot2)
library(gridExtra)
library(grid)
library(devtools)

# Add extra functions

print("loading extra functions...")

source_url(paste0(location_of_extra_functions,"summarise_data_functions.R?raw=TRUE"))

# Read data and summarise size

print("loading dat...")

dat<-readRDS(location_of_dat)
print(paste0("There are ",nrow(dat)," observations and ",ncol(dat)," variables in the ",cohort," dataset"))

# Check all variables:

## covariates
print("checking covariates...")
pdf(paste0(save_directory,tolower(cohort),"_checks_covariates.pdf"))
try(check.variables("covs_","categorical"),silent = T)
try(check.variables("covs_","continuous"),silent = T)
dev.off()

## exposures: smoking
print("checking smoking exposures...")
pdf(paste0(save_directory,tolower(cohort),"_checks_smoking.pdf"))
try(check.variables("smoking_","categorical"),silent = T)
try(check.variables("smoking_","continuous"),silent = T)
dev.off()

## exposures: alcohol
print("checking alcohol exposures...")
pdf(paste0(save_directory,tolower(cohort),"_checks_alcohol.pdf"))
try(check.variables("alcohol_","categorical"),silent = T)
try(check.variables("alcohol_","continuous"),silent = T)
dev.off()

## exposures: caffeine
print("checking caffeine exposures...")
pdf(paste0(save_directory,tolower(cohort),"_checks_caffeine.pdf"))
try(check.variables("caffeine_","categorical"),silent = T)
try(check.variables("caffeine_","continuous"),silent = T)
dev.off()

## exposures: physical activity
print("checking physical activity exposures...")
pdf(paste0(save_directory,tolower(cohort),"_checks_physact.pdf"))
try(check.variables("physact_","categorical"),silent = T)
try(check.variables("physact_","continuous"),silent = T)
dev.off()

## exposures: polygenic risk scores
print("checking PRSs...")
pdf(paste0(save_directory,tolower(cohort),"_checks_prs.pdf"))
try(check.variables("prs_","categorical"),silent = T)
try(check.variables("prs_","continuous"),silent = T)
dev.off()

## outcomes: cardiometabolic
print("checking cardiometabolic outcomes...")
pdf(paste0(save_directory,tolower(cohort),"_checks_cardiometabolic.pdf"))
try(check.variables("cardio_","categorical"),silent = T)
try(check.variables("cardio_","continuous"),silent = T)
dev.off()

## outcomes: anthropometric/adiposity
print("checking body size outcomes...")
pdf(paste0(save_directory,tolower(cohort),"_checks_anthropometric.pdf"))
try(check.variables("anthro_","categorical"),silent = T)
try(check.variables("anthro_","continuous"),silent = T)
dev.off()

## outcomes: immunological
print("checking immunological outcomes...")
pdf(paste0(save_directory,tolower(cohort),"_checks_immunological.pdf"))
try(check.variables("immuno_","categorical"),silent = T)
try(check.variables("immuno_","continuous"),silent = T)
dev.off()

## outcomes: psychosocial
print("checking psychosocial outcomes...")
pdf(paste0(save_directory,tolower(cohort),"_checks_psychosocial.pdf"))
try(check.variables("neuro_","categorical"),silent = T)
try(check.variables("neuro_","continuous"),silent = T)
dev.off()
