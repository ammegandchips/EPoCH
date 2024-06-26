###########################################
# Perform a meta-analysis for each pheWAS #
###########################################

# Read in arguments

args <- commandArgs(trailingOnly = TRUE)
model <- toString(args[1])

# Load packages

print("loading packages...")
library(tidyverse)
library(plyr)
library(dplyr)
library(stringr)
library(metafor)

# Set locations of scripts, data and save files

cohorts <- c("ALSPAC","BIB","MCS","MOBA")
key_cohorts <- cohorts
model_save <- model

if(grepl("_FEMALE",model)){
  cohorts <- c("ALSPAC_FEMALE","BIB_FEMALE","MCS_FEMALE","MOBA_FEMALE")
  model <-unlist(strsplit(model,split="_FEMALE"))
}
if(grepl("_MALE",model)){
  cohorts <- c("ALSPAC_MALE","BIB_MALE","MCS_MALE","MOBA_MALE")
  model <-unlist(strsplit(model,split="_MALE"))
}

location_of_key <- paste0("~/EPoCH/data/")
location_of_phewas_res <- paste0("~/EPoCH/for_metaanalysis/")
location_of_extra_functions <- "https://github.com/ammegandchips/EPoCH/blob/main/meta_analysis/"
save_directory <- paste0("~/EPoCH/results/")

# Read cohort results and prepare data

print("reading in cohort phewas results and merging with key...")

cohort_phewas <- lapply(1:length(cohorts),function(x){
  res <- readRDS(paste0(location_of_phewas_res,cohorts[x],"_",model,"_cleanedphewas.rds"))[[1]]
  res$cohort <- key_cohorts[x]
  res<-res[,-grep(colnames(res),pattern="covariate")]
  res
})

# combine results from all cohorts into long and wide format

print("combining cohort results in long format...")

all_cohort_phewas_long <- bind_rows(cohort_phewas)

print("combining cohort results in wide format...")

all_cohort_phewas_wide <- pivot_wider(all_cohort_phewas_long,
                                      id_cols = c("exposure_linker","outcome_linker","exposure_class","exposure_subclass","exposure_time","exposure_type","exposure_source","person_exposed","outcome_class","outcome_subclass1","outcome_subclass2","outcome_time","outcome_type","exposure_dose"),
                                      names_from = "cohort",
                                      values_from = c("est","se","p","n","exposure_n","outcome_n")
                                      
)

# add some extra information (total n, number of participating cohorts, which cohorts they are, and a combination of regression term and outcome for merging)

print("adding extra columns...")

all_cohort_phewas_wide$total_n <- rowSums(all_cohort_phewas_wide[,grep(colnames(all_cohort_phewas_wide),pattern="n_A|n_B|n_M")],na.rm = T)
all_cohort_phewas_wide$total_n_exposure <- rowSums(all_cohort_phewas_wide[,grep(colnames(all_cohort_phewas_wide),pattern="exposure_n_A|exposure_n_B|exposure_n_M")],na.rm = T)
all_cohort_phewas_wide$total_n_outcome <- rowSums(all_cohort_phewas_wide[,grep(colnames(all_cohort_phewas_wide),pattern="outcome_n_A|outcome_n_B|outcome_n_M")],na.rm = T)
cohort_missing <- is.na(all_cohort_phewas_wide[,paste0("est_",key_cohorts)])
cohorts_participating <- apply(cohort_missing,1,function(x)key_cohorts[x==F])
all_cohort_phewas_wide$cohorts_n <- sapply(cohorts_participating,length)
all_cohort_phewas_wide$cohorts <- unlist(lapply(cohorts_participating,function(x) paste(x,collapse=", ")))
all_cohort_phewas_wide$linker <- paste(all_cohort_phewas_wide$exposure_linker,all_cohort_phewas_wide$outcome_linker,sep=".")

# run the meta analysis

print("running meta-analysis...")

meta_res <- split(all_cohort_phewas_long, paste(all_cohort_phewas_long$exposure_linker,all_cohort_phewas_long$outcome_linker,sep="."),drop = FALSE)
meta_res <- lapply(meta_res, function(x) try(rma.uni(slab=x$cohort,yi=x$est,sei=x$se,method="FE",weighted=TRUE)))

# extract key information from the meta-analysis results

print("extracting key information...")

meta_res_extracted  = lapply(meta_res, function(x){
    if(class(x)=="try-error"){
      extracted_data <- rep(NA,7)
    }else{
    extracted_data <- unlist(c(x$b[[1]],x[c("se","pval","QE","QEp","I2","H2")]))
    }
    names(extracted_data) <- c("est","se","p","q","hetp","i2","h2")
    extracted_data
  })

meta_res_extracted <- bind_rows(meta_res_extracted,.id="linker")

# merging cohort-level results with meta-analysis results

print("merging cohort-level results with meta-analysis results...")

all_results <- full_join(all_cohort_phewas_wide,meta_res_extracted,by="linker")

# adding some extra information and tidying up results

all_results$model <- model_save
all_results <- all_results[order(all_results$est),]

# save results

print("saving results...")

saveRDS(all_results,file=paste0(save_directory,"metaphewas_",model_save,"_extracted.RDS"))
saveRDS(meta_res,file=paste0(save_directory,"metaphewas_",model_save,"_raw.RDS"))


print("done!")
