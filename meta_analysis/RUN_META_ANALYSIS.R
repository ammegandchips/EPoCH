###########################################
# Perform a meta-analysis for each phewas #
###########################################

# NEED TO DO THIS FOR EACH MODEL AND CHANGE CODE BELOW TO APPLY TO ALL EXPOSURES

# Arguments that need to be changed for each model

model <- "model1a"
cohorts <- c("ALSPAC","BIB")
location_of_key <- paste0("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/",tolower(cohorts),"/",tolower(cohorts),"_key.rds")
location_of_phewas_res <- paste0("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/",tolower(cohorts),"/results/",cohorts)
location_of_extra_functions <- "~/University of Bristol/grp-EPoCH - Documents/WP4_analysis/meta_analysis/"
save_directory <- paste0("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis/results/")

# The following lines should run without changes

# Load packages

library(tidyverse)
library(dplyr)
library(metafor)

# load extra functions

source(paste0(location_of_extra_functions,"XX.R"))
source(paste0(location_of_extra_functions,"XX.R"))

# Read cohort results and prepare data

alspac_res <- readRDS(paste0(location_of_phewas_res[1],"_",model,"_phewas.rds"))
key <- readRDS(location_of_key[1])

bib_res <- readRDS(paste0(location_of_phewas_res[2],"_",model,"_phewas.rds"))
key <- readRDS(location_of_key[2])

cohort_results <- list(alspac_res[,c("regression_term","outcome","est","se")],bib_res[,c("regression_term","outcome","est","se")])
names(cohort_results) <- cohorts

res <- cohort_results %>% reduce(left_join, by = c("regression_term","outcome"), suffix=paste0(".",cohorts) )

ests <- res[,c("regression_term","outcome",paste0("est.",cohorts))]
names(ests)<-c("regression_term","outcome",cohorts)
ests <- melt(ests,id.vars = c("regression_term","outcome"))

ses <- res[,c("regression_term","outcome",paste0("se.",cohorts))]
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

