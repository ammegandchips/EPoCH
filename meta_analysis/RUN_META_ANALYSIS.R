###########################################
# Perform a meta-analysis for each pheWAS #
###########################################

# NEED TO DO THIS FOR EACH MODEL AND CHANGE CODE BELOW TO APPLY TO ALL EXPOSURES
# NEED TO CREATE A COPY OF THIS FILE FOR WHEN BIB IS STRATIFIED

# Read in arguments

args <- commandArgs(trailingOnly = TRUE)
model <- toString(args[1])

# Load packages

print("loading packages...")
library(tidyverse)
library(dplyr)
library(stringr)
library(metafor)

# Set locations of scripts, data and save files

cohorts <- c("ALSPAC","BIB_ALL","MCS")
location_of_key <- paste0("~/EPoCH/data/",str_replace(tolower(cohorts),"bib_all|bib_sa|bib_we","bib"),"/",tolower(cohorts),"_key.rds")
location_of_phewas_res <- paste0("~/EPoCH/data/",str_replace(tolower(cohorts),"bib_all|bib_sa|bib_we","bib"),"/results/",cohorts)
location_of_extra_functions <- "https://github.com/ammegandchips/EPoCH/blob/main/meta_analysis/"
save_directory <- paste0("~/EPoCH/results/")

# load extra functions

source(paste0(location_of_extra_functions,"prepare_results.R"))

# Read cohort results and prepare data

cohort_results <- lapply(1:length(location_of_phewas_res),function(x){
  res <- readRDS(paste0(location_of_phewas_res[x],"_",model,"_phewas.rds"))
  res <- res[,c("regression_term","outcome","est","se")]
  key <- readRDS(location_of_key[x])
  list(res,key)
})

cohort_phewas <- lapply(cohort_results,function(x)x[[1]])
cohort_keys <- lapply(cohort_results,function(x)x[[2]])

all_cohort_phewas <- cohort_phewas %>% reduce(left_join, by = c("regression_term","outcome"), suffix=paste0(".",cohorts) )

ests <- all_cohort_phewas[,c("regression_term","outcome",paste0("est.",cohorts))]
names(ests)<-c("regression_term","outcome",cohorts)
ests <- melt(ests,id.vars = c("regression_term","outcome"))

ses <- all_cohort_phewas[,c("regression_term","outcome",paste0("se.",cohorts))]
names(ses)<-c("regression_term","outcome",cohorts)
ses <- melt(ses,id.vars = c("regression_term","outcome"))

data.long <- cbind(ests,ses[,"value"]) 
names(data.long)<-c("regression_term","outcome","cohort","est","se")
  meta_res = split(data.long[data.long$regression_term==unique(data.long$regression_term)[2],], f=unique(data.long$outcome))
  meta_res = lapply(meta_res, function(x) try(rma.uni(slab=x$cohort,yi=x$est,sei=x$se,method="FE",weighted=TRUE)))
  meta_res

  extract.and.merge.meta.analysis <-function(meta_res,res){
    require(plyr)
    data_meta = ldply(lapply(meta_res, function(x) 
      unlist(c(x$b[[1]],x[c("se","pval","QE","QEp","I2","H2")]))))
    colnames(data_meta)<-c("outcome","coef.fe","se.fe","p.fe","q.fe","het.p.fe","i2.fe","h2.fe")
    merged_res = merge(res[res$regression_term==unique(res$regression_term)[2],],data_meta,by="outcome",all=T)
    merged_res$cohorts <- unlist(apply(is.na(merged_res[,grep(colnames(merged_res),pattern="est.")])==F,1,function(x) paste(cohorts[x],collapse="_")))
    merged_res
  }

  key <- readRDS(location_of_key[1]) # ADD EXPOSURE SO CAN MERGE WITH KEY
  merged_res <- prepare_cohort_data(key=key,results=merged_res)

