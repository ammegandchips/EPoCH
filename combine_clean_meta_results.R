
require(tidyverse)
filenames <- list.files("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/")
filenames <- filenames[grep("extracted",filenames)]
filenames <- paste0("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/",filenames)

files <- lapply(filenames,readRDS)

combined <- bind_rows(files)

# remove results for model 3 if exposure is not time sensitive
combined_cleaned <- combined[-which(
    grepl(combined$model,pattern="3") 
    & combined$exposure_time %in% c("first trimester","second trimester","third trimester","first two postnatal years")
),]

# remove results for model 2 and 3 if exposure is a genetic risk score
combined_cleaned <- combined_cleaned[-which(
  grepl(combined_cleaned$model,pattern="2|3")
  & combined_cleaned$exposure_subclass=="polygenic risk score"
),]

# change terminology of prs to grs
combined_cleaned[] <- lapply(combined_cleaned, gsub, pattern = "polygenic risk score", replacement = "genetic risk score", fixed = TRUE)

  # remove those with any cohort n<20
KEEP <- rep(TRUE,nrow(combined_cleaned))
KEEP[as.numeric(combined_cleaned$n_ALSPAC)<20]<-FALSE
KEEP[as.numeric(combined_cleaned$n_BIB)<20]<-FALSE
KEEP[as.numeric(combined_cleaned$n_MCS)<20]<-FALSE
KEEP[as.numeric(combined_cleaned$n_MOBA)<20]<-FALSE

# or any exposed n <5
KEEP[as.numeric(combined_cleaned$exposure_n_ALSPAC)<5]<-FALSE
KEEP[as.numeric(combined_cleaned$exposure_n_BIB)<5]<-FALSE
KEEP[as.numeric(combined_cleaned$exposure_n_MCS)<5]<-FALSE
KEEP[as.numeric(combined_cleaned$exposure_n_MOBA)<5]<-FALSE

# or any unexposed n <5
KEEP[(as.numeric(combined_cleaned$n_ALSPAC) - as.numeric(combined_cleaned$exposure_n_ALSPAC))<5]<-FALSE
KEEP[(as.numeric(combined_cleaned$n_BIB) - as.numeric(combined_cleaned$exposure_n_BIB))<5]<-FALSE
KEEP[(as.numeric(combined_cleaned$n_MCS) - as.numeric(combined_cleaned$exposure_n_MCS))<5]<-FALSE
KEEP[(as.numeric(combined_cleaned$n_MOBA) - as.numeric(combined_cleaned$exposure_n_MOBA))<5]<-FALSE

# or those with outcome n <5
KEEP[as.numeric(combined_cleaned$outcome_n_ALSPAC)<5]<-FALSE
KEEP[as.numeric(combined_cleaned$outcome_n_BIB)<5]<-FALSE
KEEP[as.numeric(combined_cleaned$outcome_n_MCS)<5]<-FALSE
KEEP[as.numeric(combined_cleaned$outcome_n_MOBA)<5]<-FALSE

# or those without outcome n <5
KEEP[(as.numeric(combined_cleaned$n_ALSPAC) - as.numeric(combined_cleaned$outcome_n_ALSPAC))<5]<-FALSE
KEEP[(as.numeric(combined_cleaned$n_BIB) - as.numeric(combined_cleaned$outcome_n_BIB))<5]<-FALSE
KEEP[(as.numeric(combined_cleaned$n_MCS) - as.numeric(combined_cleaned$outcome_n_MCS))<5]<-FALSE
KEEP[(as.numeric(combined_cleaned$n_MOBA) - as.numeric(combined_cleaned$outcome_n_MOBA))<5]<-FALSE

combined_cleaned <- combined_cleaned[KEEP,]

# remove NA from end of exposure linker
combined_cleaned[] <- lapply(combined_cleaned, gsub, pattern = " NA", replacement = "", fixed = TRUE)

# change numeric columns to numeric
numeric_cols <-c(c("est","se","p","q","hetp","i2","h2"),
                 colnames(combined_cleaned)[grep(colnames(combined_cleaned),pattern="est_|se_|p_A|p_B|p_M|n_A|n_B|n_M|total_n|cohorts_n|outcome_n|exposure_n")]
)
combined_cleaned[,numeric_cols] <- apply(combined_cleaned[,numeric_cols],2,as.numeric)

# save
saveRDS(combined_cleaned,"University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/all_results.rds")


