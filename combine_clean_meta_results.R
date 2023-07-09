
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


#tidying up
combined_cleaned$total_n_exposure[combined_cleaned$total_n_exposure==0]<-NA
combined_cleaned$total_n_outcome[combined_cleaned$total_n_outcome==0]<-NA

# save
saveRDS(combined_cleaned,"University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/all_results.rds")

# remove results related to physical activity or diet (for app)
combined_cleaned <- combined_cleaned[-which(combined_cleaned$exposure_class %in% c("physical activity","diet")),]
# and results for perinatal survival outcomes
combined_cleaned <- combined_cleaned[-which(combined_cleaned$outcome_class %in% c("perinatal survival")),]

# QC of cohort results (remove anything where there's evidence of the model not converging, probably because a single explanatory variable (exposure or covariate), uniquely identifies the outcome, i.e. perfect prediction/complete separation.)
## evidence predicted by a very high effect estimate combined with a large P-value

  df <- combined_cleaned
  df_bin <- df[df$outcome_type=="binary",]
  cutoff_bin <- quantile(abs(df_bin$est),probs = 0.99,na.rm = T)
  df_cont <- df[df$outcome_type=="continuous",]
  cutoff_cont <- quantile(abs(df_cont$est),probs = 0.99,na.rm = T)
  df_cleaned <- df[which((df$outcome_type=="binary"& abs(df$est)<=cutoff_bin)|
                     (df$outcome_type=="continuous"& abs(df$est)<=cutoff_cont)), ]
  lost_exposures <- unique(df$exposure_linker[(df$exposure_linker %in% df_cleaned$exposure_linker)==F])
  lost_outcomes <- unique(df$outcome_linker[(df$outcome_linker %in% df_cleaned$outcome_linker)==F])
  
  original_associations <-paste(df$exposure_linker,df$outcome_linker)
  cleaned_associations <-paste(df_cleaned$exposure_linker,df_cleaned$outcome_linker)
  lost_associations <- unique(original_associations[(original_associations %in% cleaned_associations)==F])

#drop dustmite, autism, and insect allergy because very small Ns leading to implausible effect estimates and SEs:
combined_cleaned <- combined_cleaned[-which(combined_cleaned$outcome_subclass2 %in% c("dustmite allergy","insect allergy","autism")),]
#drop associations where very large SEs mean result is unreliable
cutoff <- quantile(combined_cleaned$se,probs = 0.999)
print(cutoff)
combined_cleaned2 <- combined_cleaned[combined_cleaned$se<cutoff,]

saveRDS(combined_cleaned,"~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/all_results_reduced.rds")
saveRDS(combined_cleaned,"/Users/gs8094/Library/CloudStorage/OneDrive-UniversityofExeter/Projects/EPoCH/EPoCH results app/data/rds/all_results_reduced.rds")



