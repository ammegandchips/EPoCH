#################################################
#           QC before meta-analysis             #
#################################################

## Remove models where results are duplicated
## Remove anything with N<5 in any exposed/unexposed/total/withoutcome/wituoutoutcome group
## Remove anything with evidence that the model did not converge

# Read in arguments

args <- commandArgs(trailingOnly = TRUE)
cohort <- toString(args[1])

# Load packages

print("loading packages...")
library(tidyverse)
library(plyr)
library(dplyr)
library(stringr)

# Set locations of scripts, data and save files

models <- c(paste0("model",as.vector(outer(1:4, letters[1:3], paste0))))

cohort_name <- cohort

if(grepl("_FEMALE",cohort)){
  cohort_name <-unlist(strsplit(cohort,split="_FEMALE"))
}
if(grepl("_MALE",cohort)){
  cohort_name <-unlist(strsplit(cohort,split="_MALE"))
}

location_of_key <- paste0("~/EPoCH/data/")
location_of_phewas_res <- paste0("~/EPoCH/for_metaanalysis/")
location_of_extra_functions <- "https://github.com/ammegandchips/EPoCH/blob/main/meta_analysis/"
save_directory <- paste0("~/EPoCH/results/")

# Read cohort results and prepare data

print("reading in cohort phewas results and merging with key...")

cohort_phewas <- lapply(1:length(models),function(x){
  res <- readRDS(paste0(location_of_phewas_res,cohort,"_",models[x],"_phewas.rds"))
  res <- res[,c("exposure","regression_term","outcome","est","se","p","n","exposure_n","outcome_n","model")]
  res <- res[which(res$regression_term!="error"),] # can remove this once we have sorted the issue with MCS
  res$cohort <- cohort
  key <- readRDS(paste0(location_of_key,tolower(cohort_name),"_key.rds"))
  #just tidying up a bit due to (accidental) differences in the make_key process for MoBa and the other cohorts - but actually this column isn't needed for the meta-analysis
  key$exposure_source <-"reported by self or study mother"
  key$exposure_linker<-str_replace(key$exposure_linker,pattern="self-reported|reported by self or study mother|self-reported or measured","reported by self or study mother")
  res <- merge(res,key,by=c("exposure","outcome"),all.y=F)
  res$exposure_dose <-NA
  res$exposure_dose[grep("Heavy",res$regression_term)]<-"heavy"
  res$exposure_dose[grep("Light",res$regression_term)]<-"light"
  res$exposure_dose[grep("Moderate",res$regression_term)]<-"moderate"
  res$exposure_linker <- paste(res$exposure_linker,res$exposure_dose)
  res$exposure <-NULL
  res$regression_term <-NULL
  res
})

# combine results from all models into long format

print("combining all model results in long format...")

all_models_phewas_long <- bind_rows(cohort_phewas)

# remove model c
all_models_phewas_long <- all_models_phewas_long[-grep("1c|2c|3c|4c",all_models_phewas_long$model),]

print("initial number of results (without model c):")
print(nrow(all_models_phewas_long))

## remove all duplicate models (where exposure is the same and estimate is the same)

all_models_phewas_long$dup <- F
all_models_phewas_long$dup1 <- all_models_phewas_long$covariates_model1a==all_models_phewas_long$covariates_model1b
all_models_phewas_long$dup[all_models_phewas_long$dup1==T&all_models_phewas_long$model=="model1b"]<-T
all_models_phewas_long$dup2 <- all_models_phewas_long$covariates_model2a==all_models_phewas_long$covariates_model2b
all_models_phewas_long$dup[all_models_phewas_long$dup2==T&all_models_phewas_long$model=="model2b"]<-T
all_models_phewas_long$dup3 <- all_models_phewas_long$covariates_model3a==all_models_phewas_long$covariates_model3b
all_models_phewas_long$dup[all_models_phewas_long$dup3==T&all_models_phewas_long$model=="model3b"]<-T
all_models_phewas_long$dup4 <- all_models_phewas_long$covariates_model4a==all_models_phewas_long$covariates_model4b
all_models_phewas_long$dup[all_models_phewas_long$dup4==T&all_models_phewas_long$model=="model4b"]<-T
all_models_phewas_long$dup12a <- all_models_phewas_long$covariates_model1a==all_models_phewas_long$covariates_model2a
all_models_phewas_long$dup[all_models_phewas_long$dup12a==T&all_models_phewas_long$model=="model2a"]<-T
all_models_phewas_long$dup23a <- all_models_phewas_long$covariates_model2a==all_models_phewas_long$covariates_model3a
all_models_phewas_long$dup[all_models_phewas_long$dup23a==T&all_models_phewas_long$model=="model3a"]<-T
all_models_phewas_long$dup24a <- all_models_phewas_long$covariates_model2a==all_models_phewas_long$covariates_model4a
all_models_phewas_long$dup[all_models_phewas_long$dup24a==T&all_models_phewas_long$model=="model4a"]<-T
all_models_phewas_long$dup12b <- all_models_phewas_long$covariates_model1b==all_models_phewas_long$covariates_model2b
all_models_phewas_long$dup[all_models_phewas_long$dup12b==T&all_models_phewas_long$model=="model2b"]<-T
all_models_phewas_long$dup23b <- all_models_phewas_long$covariates_model2b==all_models_phewas_long$covariates_model3b
all_models_phewas_long$dup[all_models_phewas_long$dup23b==T&all_models_phewas_long$model=="model3b"]<-T
all_models_phewas_long$dup24b <- all_models_phewas_long$covariates_model2b==all_models_phewas_long$covariates_model4b
all_models_phewas_long$dup[all_models_phewas_long$dup24b==T&all_models_phewas_long$model=="model4b"]<-T

print(summary(all_models_phewas_long$dup))
all_models_phewas_long <- all_models_phewas_long[-which(all_models_phewas_long$dup==TRUE),]

print("after removal of duplicates:")
print(nrow(all_models_phewas_long))

## remove small N models
KEEP <- rep(TRUE,nrow(all_models_phewas_long))
KEEP[as.numeric(all_models_phewas_long$n)<20]<-FALSE
KEEP[as.numeric(all_models_phewas_long$exposure_n)<5]<-FALSE
KEEP[(as.numeric(all_models_phewas_long$n) - as.numeric(all_models_phewas_long$exposure_n))<5]<-FALSE
KEEP[as.numeric(all_models_phewas_long$outcome_n)<5]<-FALSE
KEEP[(as.numeric(all_models_phewas_long$n) - as.numeric(all_models_phewas_long$outcome_n))<5]<-FALSE
all_models_phewas_long <- all_models_phewas_long[KEEP,]

print("after removal of small N:")
print(nrow(all_models_phewas_long))

# QC of cohort results while in long format (remove anything where there's evidence of the model not converging, probably because a single explanatory variable (exposure or covariate), uniquely identifies the outcome, i.e. perfect prediction/complete separation.)
## evidence predicted by a very high effect estimate combined with a large P-value
## only an issue for binary outcomes - continuous estimates are within plausible range

summary(all_models_phewas_long$est[all_models_phewas_long$outcome_type=="continuous"])
summary(exp(all_models_phewas_long$est[all_models_phewas_long$outcome_type=="binary"]))
cut_off_cont <- 10
summary(abs(all_models_phewas_long$est[all_models_phewas_long$outcome_type=="continuous"])>cut_off_cont)
cut_off_bin <- 4
summary(abs(all_models_phewas_long$est[all_models_phewas_long$outcome_type=="binary"])>cut_off_bin)
df <- all_models_phewas_long
df_cleaned <- df[which((df$outcome_type=="binary"& abs(df$est)<=cut_off_bin)|
                         df$outcome_type=="continuous"), ]
lost_exposures <- unique(df$exposure_linker[(df$exposure_linker %in% df_cleaned$exposure_linker)==F])
lost_outcomes <- unique(df$outcome_linker[(df$outcome_linker %in% df_cleaned$outcome_linker)==F])
original_associations <-paste(df$exposure_linker,df$outcome_linker)
cleaned_associations <-paste(df_cleaned$exposure_linker,df_cleaned$outcome_linker)
lost_associations <- unique(original_associations[(original_associations %in% cleaned_associations)==F])
print(length(lost_exposures))
print(length(lost_outcomes))
print(length(lost_associations))
all_models_phewas_long <- df_cleaned

print("after removal of models that didn't converge:")
print(nrow(all_models_phewas_long))

# split by model again
split_data <- split(all_models_phewas_long, f = all_models_phewas_long$model) 

# save results

print("saving results...")

models <- names(split_data)

save_split_results <- function(modelindex){
  saveRDS(split_data[modelindex],file=paste0(save_directory,cohort,"_",models[modelindex],"_cleanedphewas.rds"))
}

for(i in 1:length(models)){
  save_split_results(i)
}

print("done!")
