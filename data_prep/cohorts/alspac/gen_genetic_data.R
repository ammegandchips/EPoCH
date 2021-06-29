###################################################################################
## Code to derive and add the genetic PRS and individual SNPs to the ALSPAC data ##
###################################################################################

gen_genetic_data <- function(){
## Read in data

#Full summary statistics from all cohorts available from GSCAN**

prs_alcohol_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200429_scores_alcohol_children.profile", header=TRUE,stringsAsFactors = F)
prs_alcohol_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200429_scores_alcohol_mothers.profile", header=TRUE,stringsAsFactors = F)

prs_caffeine_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200504_scores_caffeine_children.profile", header=TRUE,stringsAsFactors = F)
prs_caffeine_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200504_scores_caffeine_mothers.profile", header=TRUE,stringsAsFactors = F)

prs_smoking_age_init_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200502_scores_smoking_age_init_children.profile", header=TRUE,stringsAsFactors = F)
prs_smoking_age_init_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200502_scores_smoking_age_init_mothers.profile", header=TRUE,stringsAsFactors = F)

prs_smoking_cessation_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200501_scores_smoking_cessation_children.profile", header=TRUE,stringsAsFactors = F)
prs_smoking_cessation_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200501_scores_smoking_cessation_mothers.profile", header=TRUE,stringsAsFactors = F)

prs_smoking_cigs_pd_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200430_scores_smoking_cigs_pd_children.profile", header=TRUE,stringsAsFactors = F)
prs_smoking_cigs_pd_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200430_scores_smoking_cigs_pd_mothers.profile", header=TRUE,stringsAsFactors = F)

prs_smoking_initiation_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200501_scores_smoking_initiation_children.profile", header=TRUE,stringsAsFactors = F)
prs_smoking_initiation_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200501_scores_smoking_initiation_mothers.profile", header=TRUE,stringsAsFactors = F)

prs_pa_sedentary_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200507_scores_pa_sedentary_children.profile", header=TRUE,stringsAsFactors = F)
prs_pa_sedentary_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/20200506_scores_pa_sedentary_mothers.profile", header=TRUE,stringsAsFactors = F)

#Read in data for sensitivity analysis - PRS made using summary statistics excluding ALSPAC and 23andME**

sens_exc_alsp_prs_alcohol_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20201119_scores_alcohol_children.profile", header=TRUE,stringsAsFactors = F)
sens_exc_alsp_prs_alcohol_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20201118_scores_alcohol_mothers.profile", header=TRUE,stringsAsFactors = F)

sens_exc_alsp_prs_smoking_age_init_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_age_init_children.profile", header=TRUE,stringsAsFactors = F)
sens_exc_alsp_prs_smoking_age_init_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_age_init_mothers.profile", header=TRUE,stringsAsFactors = F)

sens_exc_alsp_prs_smoking_cessation_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_cessation_children.profile", header=TRUE,stringsAsFactors = F)
sens_exc_alsp_prs_smoking_cessation_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_cessation_mothers.profile", header=TRUE,stringsAsFactors = F)

sens_exc_alsp_prs_smoking_cigs_pd_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_cigs_pd_children.profile", header=TRUE,stringsAsFactors = F)
sens_exc_alsp_prs_smoking_cigs_pd_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_cigs_pd_mothers.profile", header=TRUE,stringsAsFactors = F)

sens_exc_alsp_prs_smoking_initiation_child<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_initiation_children.profile", header=TRUE,stringsAsFactors = F)
sens_exc_alsp_prs_smoking_initiation_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/PRS/excluding_alsp_23me/20210203_scores_smoking_initiation_mothers.profile", header=TRUE,stringsAsFactors = F)

## Clean variables

#Create aln, qlet and rename score column
prs_alcohol_child$aln <-as.numeric(substr(prs_alcohol_child$FID, 1, 5))
prs_alcohol_child$qlet<-substr(prs_alcohol_child$FID, 6, 6)
prs_alcohol_child$prs_score_child_alcohol<-prs_alcohol_child$SCORE

## keep only the columns we want
prs_alcohol_child<-prs_alcohol_child[, which(names(prs_alcohol_child) %in% c("aln", "qlet","prs_score_child_alcohol"))]

prs_alcohol_mother$aln <-as.numeric(substr(prs_alcohol_mother$FID, 1, 5))
prs_alcohol_mother$qlet<-substr(prs_alcohol_mother$FID, 6, 6)
prs_alcohol_mother$prs_score_mother_alcohol<-prs_alcohol_mother$SCORE
prs_alcohol_mother<-prs_alcohol_mother[, which(names(prs_alcohol_mother) %in% c("aln", "qlet","prs_score_mother_alcohol"))]

prs_caffeine_child$aln <-as.numeric(substr(prs_caffeine_child$FID, 1, 5))
prs_caffeine_child$qlet<-substr(prs_caffeine_child$FID, 6, 6)
prs_caffeine_child$prs_score_child_caffeine<-prs_caffeine_child$SCORE
prs_caffeine_child<-prs_caffeine_child[, which(names(prs_caffeine_child) %in% c("aln", "qlet","prs_score_child_caffeine"))]

prs_caffeine_mother$aln <-as.numeric(substr(prs_caffeine_mother$FID, 1, 5))
prs_caffeine_mother$qlet<-substr(prs_caffeine_mother$FID, 6, 6)
prs_caffeine_mother$prs_score_mother_caffeine<-prs_caffeine_mother$SCORE
prs_caffeine_mother<-prs_caffeine_mother[, which(names(prs_caffeine_mother) %in% c("aln", "qlet","prs_score_mother_caffeine"))]

prs_smoking_age_init_child$aln <-as.numeric(substr(prs_smoking_age_init_child$FID, 1, 5))
prs_smoking_age_init_child$qlet<-substr(prs_smoking_age_init_child$FID, 6, 6)
prs_smoking_age_init_child$prs_score_child_smoking_age_init<-prs_smoking_age_init_child$SCORE
prs_smoking_age_init_child<-prs_smoking_age_init_child[, which(names(prs_smoking_age_init_child) %in% c("aln", "qlet","prs_score_child_smoking_age_init"))]

prs_smoking_age_init_mother$aln <-as.numeric(substr(prs_smoking_age_init_mother$FID, 1, 5))
prs_smoking_age_init_mother$qlet<-substr(prs_smoking_age_init_mother$FID, 6, 6)
prs_smoking_age_init_mother$prs_score_mother_smoking_age_init<-prs_smoking_age_init_mother$SCORE
prs_smoking_age_init_mother<-prs_smoking_age_init_mother[, which(names(prs_smoking_age_init_mother) %in% c("aln", "qlet","prs_score_mother_smoking_age_init"))]

prs_smoking_cessation_child$aln <-as.numeric(substr(prs_smoking_cessation_child$FID, 1, 5))
prs_smoking_cessation_child$qlet<-substr(prs_smoking_cessation_child$FID, 6, 6)
prs_smoking_cessation_child$prs_score_child_smoking_cessation<-prs_smoking_cessation_child$SCORE
prs_smoking_cessation_child<-prs_smoking_cessation_child[, which(names(prs_smoking_cessation_child) %in% c("aln", "qlet","prs_score_child_smoking_cessation"))]

prs_smoking_cessation_mother$aln <-as.numeric(substr(prs_smoking_cessation_mother$FID, 1, 5))
prs_smoking_cessation_mother$qlet<-substr(prs_smoking_cessation_mother$FID, 6, 6)
prs_smoking_cessation_mother$prs_score_mother_smoking_cessation<-prs_smoking_cessation_mother$SCORE
prs_smoking_cessation_mother<-prs_smoking_cessation_mother[, which(names(prs_smoking_cessation_mother) %in% c("aln", "qlet","prs_score_mother_smoking_cessation"))]

prs_smoking_cigs_pd_child$aln <-as.numeric(substr(prs_smoking_cigs_pd_child$FID, 1, 5))
prs_smoking_cigs_pd_child$qlet<-substr(prs_smoking_cigs_pd_child$FID, 6, 6)
prs_smoking_cigs_pd_child$prs_score_child_smoking_cigs_pd<-prs_smoking_cigs_pd_child$SCORE
prs_smoking_cigs_pd_child<-prs_smoking_cigs_pd_child[, which(names(prs_smoking_cigs_pd_child) %in% c("aln", "qlet","prs_score_child_smoking_cigs_pd"))]

prs_smoking_cigs_pd_mother$aln <-as.numeric(substr(prs_smoking_cigs_pd_mother$FID, 1, 5))
prs_smoking_cigs_pd_mother$qlet<-substr(prs_smoking_cigs_pd_mother$FID, 6, 6)
prs_smoking_cigs_pd_mother$prs_score_mother_smoking_cigs_pd<-prs_smoking_cigs_pd_mother$SCORE
prs_smoking_cigs_pd_mother<-prs_smoking_cigs_pd_mother[, which(names(prs_smoking_cigs_pd_mother) %in% c("aln", "qlet","prs_score_mother_smoking_cigs_pd"))]

prs_smoking_initiation_child$aln <-as.numeric(substr(prs_smoking_initiation_child$FID, 1, 5))
prs_smoking_initiation_child$qlet<-substr(prs_smoking_initiation_child$FID, 6, 6)
prs_smoking_initiation_child$prs_score_child_smoking_initiation<-prs_smoking_initiation_child$SCORE
prs_smoking_initiation_child<-prs_smoking_initiation_child[, which(names(prs_smoking_initiation_child) %in% c("aln", "qlet","prs_score_child_smoking_initiation"))]

prs_smoking_initiation_mother$aln <-as.numeric(substr(prs_smoking_initiation_mother$FID, 1, 5))
prs_smoking_initiation_mother$qlet<-substr(prs_smoking_initiation_mother$FID, 6, 6)
prs_smoking_initiation_mother$prs_score_mother_smoking_initiation<-prs_smoking_initiation_mother$SCORE
prs_smoking_initiation_mother<-prs_smoking_initiation_mother[, which(names(prs_smoking_initiation_mother) %in% c("aln", "qlet","prs_score_mother_smoking_initiation"))]

prs_pa_sedentary_child$aln <-as.numeric(substr(prs_pa_sedentary_child$FID, 1, 5))
prs_pa_sedentary_child$qlet<-substr(prs_pa_sedentary_child$FID, 6, 6)
prs_pa_sedentary_child$prs_score_child_pa_sedentary<-prs_pa_sedentary_child$SCORE
prs_pa_sedentary_child<-prs_pa_sedentary_child[, which(names(prs_pa_sedentary_child) %in% c("aln", "qlet","prs_score_child_pa_sedentary"))]

prs_pa_sedentary_mother$aln <-as.numeric(substr(prs_pa_sedentary_mother$FID, 1, 5))
prs_pa_sedentary_mother$qlet<-substr(prs_pa_sedentary_mother$FID, 6, 6)
prs_pa_sedentary_mother$prs_score_mother_pa_sedentary<-prs_pa_sedentary_mother$SCORE
prs_pa_sedentary_mother<-prs_pa_sedentary_mother[, which(names(prs_pa_sedentary_mother) %in% c("aln", "qlet","prs_score_mother_pa_sedentary"))]

#Clean PRS for sesnitivity analyses - sum stats excluding ALSPAC and 23andMe**
  
sens_exc_alsp_prs_alcohol_child$aln <-as.numeric(substr(sens_exc_alsp_prs_alcohol_child$FID, 1, 5))
sens_exc_alsp_prs_alcohol_child$qlet<-substr(sens_exc_alsp_prs_alcohol_child$FID, 6, 6)
sens_exc_alsp_prs_alcohol_child$sens_exc_alsp_prs_score_child_alcohol<-sens_exc_alsp_prs_alcohol_child$SCORE
## keep only the columns we want
sens_exc_alsp_prs_alcohol_child<-sens_exc_alsp_prs_alcohol_child[, which(names(sens_exc_alsp_prs_alcohol_child) %in% c("aln", "qlet","sens_exc_alsp_prs_score_child_alcohol"))]

sens_exc_alsp_prs_alcohol_mother$aln <-as.numeric(substr(sens_exc_alsp_prs_alcohol_mother$FID, 1, 5))
sens_exc_alsp_prs_alcohol_mother$qlet<-substr(sens_exc_alsp_prs_alcohol_mother$FID, 6, 6)
sens_exc_alsp_prs_alcohol_mother$sens_exc_alsp_prs_score_mother_alcohol<-sens_exc_alsp_prs_alcohol_mother$SCORE
sens_exc_alsp_prs_alcohol_mother<-sens_exc_alsp_prs_alcohol_mother[, which(names(sens_exc_alsp_prs_alcohol_mother) %in% c("aln", "qlet","sens_exc_alsp_prs_score_mother_alcohol"))]

sens_exc_alsp_prs_smoking_age_init_child$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_age_init_child$FID, 1, 5))
sens_exc_alsp_prs_smoking_age_init_child$qlet<-substr(sens_exc_alsp_prs_smoking_age_init_child$FID, 6, 6)
sens_exc_alsp_prs_smoking_age_init_child$sens_exc_alsp_prs_score_child_smoking_age_init<-sens_exc_alsp_prs_smoking_age_init_child$SCORE
sens_exc_alsp_prs_smoking_age_init_child<-sens_exc_alsp_prs_smoking_age_init_child[, which(names(sens_exc_alsp_prs_smoking_age_init_child) %in% c("aln", "qlet","sens_exc_alsp_prs_score_child_smoking_age_init"))]

sens_exc_alsp_prs_smoking_age_init_mother$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_age_init_mother$FID, 1, 5))
sens_exc_alsp_prs_smoking_age_init_mother$qlet<-substr(sens_exc_alsp_prs_smoking_age_init_mother$FID, 6, 6)
sens_exc_alsp_prs_smoking_age_init_mother$sens_exc_alsp_prs_score_mother_smoking_age_init<-sens_exc_alsp_prs_smoking_age_init_mother$SCORE
sens_exc_alsp_prs_smoking_age_init_mother<-sens_exc_alsp_prs_smoking_age_init_mother[, which(names(sens_exc_alsp_prs_smoking_age_init_mother) %in% c("aln", "qlet","sens_exc_alsp_prs_score_mother_smoking_age_init"))]

sens_exc_alsp_prs_smoking_cessation_child$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_cessation_child$FID, 1, 5))
sens_exc_alsp_prs_smoking_cessation_child$qlet<-substr(sens_exc_alsp_prs_smoking_cessation_child$FID, 6, 6)
sens_exc_alsp_prs_smoking_cessation_child$sens_exc_alsp_prs_score_child_smoking_cessation<-sens_exc_alsp_prs_smoking_cessation_child$SCORE
sens_exc_alsp_prs_smoking_cessation_child<-sens_exc_alsp_prs_smoking_cessation_child[, which(names(sens_exc_alsp_prs_smoking_cessation_child) %in% c("aln", "qlet","sens_exc_alsp_prs_score_child_smoking_cessation"))]

sens_exc_alsp_prs_smoking_cessation_mother$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_cessation_mother$FID, 1, 5))
sens_exc_alsp_prs_smoking_cessation_mother$qlet<-substr(sens_exc_alsp_prs_smoking_cessation_mother$FID, 6, 6)
sens_exc_alsp_prs_smoking_cessation_mother$sens_exc_alsp_prs_score_mother_smoking_cessation<-sens_exc_alsp_prs_smoking_cessation_mother$SCORE
sens_exc_alsp_prs_smoking_cessation_mother<-sens_exc_alsp_prs_smoking_cessation_mother[, which(names(sens_exc_alsp_prs_smoking_cessation_mother) %in% c("aln", "qlet","sens_exc_alsp_prs_score_mother_smoking_cessation"))]

sens_exc_alsp_prs_smoking_cigs_pd_child$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_cigs_pd_child$FID, 1, 5))
sens_exc_alsp_prs_smoking_cigs_pd_child$qlet<-substr(sens_exc_alsp_prs_smoking_cigs_pd_child$FID, 6, 6)
sens_exc_alsp_prs_smoking_cigs_pd_child$sens_exc_alsp_prs_score_child_smoking_cigs_pd<-sens_exc_alsp_prs_smoking_cigs_pd_child$SCORE
sens_exc_alsp_prs_smoking_cigs_pd_child<-sens_exc_alsp_prs_smoking_cigs_pd_child[, which(names(sens_exc_alsp_prs_smoking_cigs_pd_child) %in% c("aln", "qlet","sens_exc_alsp_prs_score_child_smoking_cigs_pd"))]

sens_exc_alsp_prs_smoking_cigs_pd_mother$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_cigs_pd_mother$FID, 1, 5))
sens_exc_alsp_prs_smoking_cigs_pd_mother$qlet<-substr(sens_exc_alsp_prs_smoking_cigs_pd_mother$FID, 6, 6)
sens_exc_alsp_prs_smoking_cigs_pd_mother$sens_exc_alsp_prs_score_mother_smoking_cigs_pd<-sens_exc_alsp_prs_smoking_cigs_pd_mother$SCORE
sens_exc_alsp_prs_smoking_cigs_pd_mother<-sens_exc_alsp_prs_smoking_cigs_pd_mother[, which(names(sens_exc_alsp_prs_smoking_cigs_pd_mother) %in% c("aln", "qlet","sens_exc_alsp_prs_score_mother_smoking_cigs_pd"))]

sens_exc_alsp_prs_smoking_initiation_child$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_initiation_child$FID, 1, 5))
sens_exc_alsp_prs_smoking_initiation_child$qlet<-substr(sens_exc_alsp_prs_smoking_initiation_child$FID, 6, 6)
sens_exc_alsp_prs_smoking_initiation_child$sens_exc_alsp_prs_score_child_smoking_initiation<-sens_exc_alsp_prs_smoking_initiation_child$SCORE
sens_exc_alsp_prs_smoking_initiation_child<-sens_exc_alsp_prs_smoking_initiation_child[, which(names(sens_exc_alsp_prs_smoking_initiation_child) %in% c("aln", "qlet","sens_exc_alsp_prs_score_child_smoking_initiation"))]

sens_exc_alsp_prs_smoking_initiation_mother$aln <-as.numeric(substr(sens_exc_alsp_prs_smoking_initiation_mother$FID, 1, 5))
sens_exc_alsp_prs_smoking_initiation_mother$qlet<-substr(sens_exc_alsp_prs_smoking_initiation_mother$FID, 6, 6)
sens_exc_alsp_prs_smoking_initiation_mother$sens_exc_alsp_prs_score_mother_smoking_initiation<-sens_exc_alsp_prs_smoking_initiation_mother$SCORE
sens_exc_alsp_prs_smoking_initiation_mother<-sens_exc_alsp_prs_smoking_initiation_mother[, which(names(sens_exc_alsp_prs_smoking_initiation_mother) %in% c("aln", "qlet","sens_exc_alsp_prs_score_mother_smoking_initiation"))]

## Merge
dat<-left_join(dat[,c("aln","qlet")],prs_alcohol_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_alcohol_mother[,-2], by =c("aln"))

dat<-left_join(dat,prs_caffeine_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_caffeine_mother[,-2], by =c("aln"))

dat<-left_join(dat,prs_smoking_age_init_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_smoking_age_init_mother[,-2], by =c("aln"))

dat<-left_join(dat,prs_smoking_cessation_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_smoking_cessation_mother[,-2], by =c("aln"))

dat<-left_join(dat,prs_smoking_cigs_pd_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_smoking_cigs_pd_mother[,-2], by =c("aln"))

dat<-left_join(dat,prs_smoking_initiation_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_smoking_initiation_mother[,-2], by =c("aln"))

dat<-left_join(dat,prs_pa_sedentary_child, by =c("aln","qlet"))
dat<-left_join(dat,prs_pa_sedentary_mother[,-2], by =c("aln"))

dat<-left_join(dat,sens_exc_alsp_prs_alcohol_child, by =c("aln","qlet"))
dat<-left_join(dat,sens_exc_alsp_prs_alcohol_mother[,-2], by =c("aln"))

dat<-left_join(dat,sens_exc_alsp_prs_smoking_age_init_child, by =c("aln","qlet"))
dat<-left_join(dat,sens_exc_alsp_prs_smoking_age_init_mother[,-2], by =c("aln"))

dat<-left_join(dat,sens_exc_alsp_prs_smoking_cessation_child, by =c("aln","qlet"))
dat<-left_join(dat,sens_exc_alsp_prs_smoking_cessation_mother[,-2], by =c("aln"))

dat<-left_join(dat,sens_exc_alsp_prs_smoking_cigs_pd_child, by =c("aln","qlet"))
dat<-left_join(dat,sens_exc_alsp_prs_smoking_cigs_pd_mother[,-2], by =c("aln"))

dat<-left_join(dat,sens_exc_alsp_prs_smoking_initiation_child, by =c("aln","qlet"))
dat<-left_join(dat,sens_exc_alsp_prs_smoking_initiation_mother[,-2], by =c("aln"))

## Z scores

prs_vars <- names(dat)[grep(names(dat),pattern="prs")]
scaled_prs <- as.data.frame(apply(dat[,prs_vars],2,scale))
names(scaled_prs) <- paste0(prs_vars,"_zscore")
library(dplyr)
dat <- bind_cols(dat,scaled_prs)

# Individual SNP (bestguess) {.tabset}

## Read in data
snps_alcohol_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/alcohol_mothers_excluded_numb.raw", header=T)
snps_alcohol_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/alcohol_children_excluded_numb.raw", header=T)

snps_caffeine_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/caffeine_mothers_excluded_numb.raw", header=T)
snps_caffeine_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/caffeine_children_excluded_numb.raw", header=T)

snps_smoking_age_init_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_age_init_mothers_excluded_numb.raw", header=T)
snps_smoking_age_init_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_age_init_children_excluded_numb.raw", header=T)

snps_smoking_cessation_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cessation_mothers_excluded_numb.raw", header=T)
snps_smoking_cessation_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cessation_children_excluded_numb.raw", header=T)

snps_smoking_cigs_pd_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cigs_pd_mothers_excluded_numb.raw", header=T)
snps_smoking_cigs_pd_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cigs_pd_children_excluded_numb.raw", header=T)

snps_smoking_initiation_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_initiation_mothers_excluded_numb.raw", header=T)
snps_smoking_initiation_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_initiation_children_excluded_numb.raw", header=T)

snps_pa_sedentary_bestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_sedentary_mothers_excluded_numb.raw", header=T)
snps_pa_sedentary_bestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_sedentary_children_excluded_numb.raw", header=T)

snps_pa_overall_activity_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_overall_activity_mothers_excluded_numb.raw", header=T)
snps_pa_overall_activity_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_overall_activity_children_excluded_numb.raw", header=T)

## Clean variables

# (rename) add mother_snp to start of all snp columns
names(snps_alcohol_bestguess_mother)<-paste("mother_snp_alc_",names(snps_alcohol_bestguess_mother),sep="")
names(snps_alcohol_bestguess_children)<-paste("children_snp_alc_",names(snps_alcohol_bestguess_children),sep="")

names(snps_caffeine_bestguess_mother)<-paste("mother_snp_caff_",names(snps_caffeine_bestguess_mother),sep="")
names(snps_caffeine_bestguess_children)<-paste("children_snp_caff_",names(snps_caffeine_bestguess_children),sep="")

names(snps_smoking_age_init_bestguess_mother)<-paste("mother_snp_age_init_",names(snps_smoking_age_init_bestguess_mother),sep="")
names(snps_smoking_age_init_bestguess_children)<-paste("children_snp_age_init_",names(snps_smoking_age_init_bestguess_children),sep="")

names(snps_smoking_cessation_bestguess_mother)<-paste("mother_snp_cessation_",names(snps_smoking_cessation_bestguess_mother),sep="")
names(snps_smoking_cessation_bestguess_children)<-paste("children_snp_cessation_",names(snps_smoking_cessation_bestguess_children),sep="")

names(snps_smoking_cigs_pd_bestguess_mother)<-paste("mother_snp_cigspd_",names(snps_smoking_cigs_pd_bestguess_mother),sep="")
names(snps_smoking_cigs_pd_bestguess_children)<-paste("children_snp_cigspd_",names(snps_smoking_cigs_pd_bestguess_children),sep="")

names(snps_smoking_initiation_bestguess_mother)<-paste("mother_snp_initiation_",names(snps_smoking_initiation_bestguess_mother),sep="")
names(snps_smoking_initiation_bestguess_children)<-paste("children_snp_initiation_",names(snps_smoking_initiation_bestguess_children),sep="")

names(snps_pa_sedentary_bestguess_mother)<-paste("mother_snp_sedentary_",names(snps_pa_sedentary_bestguess_mother),sep="")
names(snps_pa_sedentary_bestguess_children)<-paste("children_snp_sedentary_",names(snps_pa_sedentary_bestguess_children),sep="")

names(snps_pa_overall_activity_mother)<-paste("mother_snp_overallact_",names(snps_pa_overall_activity_mother),sep="")
names(snps_pa_overall_activity_children)<-paste("children_snp_overallact_",names(snps_pa_overall_activity_children),sep="")

###  Create aln and qlet and delete columns dont need

#Maternal**

snps_alcohol_bestguess_mother$aln <-as.numeric(substr(snps_alcohol_bestguess_mother$mother_snp_alc_FID, 1, 5))
snps_alcohol_bestguess_mother$qlet<-substr(snps_alcohol_bestguess_mother$mother_snp_alc_FID, 6, 6)
snps_alcohol_bestguess_mother<-snps_alcohol_bestguess_mother[-c(1:6)] 

snps_caffeine_bestguess_mother$aln <-as.numeric(substr(snps_caffeine_bestguess_mother$mother_snp_caff_FID, 1, 5))
snps_caffeine_bestguess_mother$qlet<-substr(snps_caffeine_bestguess_mother$mother_snp_caff_FID, 6, 6)
snps_caffeine_bestguess_mother<-snps_caffeine_bestguess_mother[-c(1:6)]

snps_smoking_age_init_bestguess_mother$aln <-as.numeric(substr(snps_smoking_age_init_bestguess_mother$mother_snp_age_init_FID, 1, 5))
snps_smoking_age_init_bestguess_mother$qlet<-substr(snps_smoking_age_init_bestguess_mother$mother_snp_age_init_FID, 6, 6)
snps_smoking_age_init_bestguess_mother<-snps_smoking_age_init_bestguess_mother[-c(1:6)]

snps_smoking_cessation_bestguess_mother$aln <-as.numeric(substr(snps_smoking_cessation_bestguess_mother$mother_snp_cessation_FID, 1, 5))
snps_smoking_cessation_bestguess_mother$qlet<-substr(snps_smoking_cessation_bestguess_mother$mother_snp_cessation_FID, 6, 6)
snps_smoking_cessation_bestguess_mother<-snps_smoking_cessation_bestguess_mother[-c(1:6)]

snps_smoking_cigs_pd_bestguess_mother$aln <-as.numeric(substr(snps_smoking_cigs_pd_bestguess_mother$mother_snp_cigspd_FID, 1, 5))
snps_smoking_cigs_pd_bestguess_mother$qlet<-substr(snps_smoking_cigs_pd_bestguess_mother$mother_snp_cigspd_FID, 6, 6)
snps_smoking_cigs_pd_bestguess_mother<-snps_smoking_cigs_pd_bestguess_mother[-c(1:6)]

snps_smoking_initiation_bestguess_mother$aln <-as.numeric(substr(snps_smoking_initiation_bestguess_mother$mother_snp_initiation_FID, 1, 5))
snps_smoking_initiation_bestguess_mother$qlet<-substr(snps_smoking_initiation_bestguess_mother$mother_snp_initiation_FID, 6, 6)
snps_smoking_initiation_bestguess_mother<-snps_smoking_initiation_bestguess_mother[-c(1:6)]

snps_pa_sedentary_bestguess_mother$aln <-as.numeric(substr(snps_pa_sedentary_bestguess_mother$mother_snp_sedentary_FID, 1, 5))
snps_pa_sedentary_bestguess_mother$qlet<-substr(snps_pa_sedentary_bestguess_mother$mother_snp_sedentary_FID, 6, 6)
snps_pa_sedentary_bestguess_mother<-snps_pa_sedentary_bestguess_mother[-c(1:6)]

snps_pa_overall_activity_mother$aln <-as.numeric(substr(snps_pa_overall_activity_mother$mother_snp_overallact_FID, 1, 5))
snps_pa_overall_activity_mother$qlet<-substr(snps_pa_overall_activity_mother$mother_snp_overallact_FID, 6, 6)
snps_pa_overall_activity_mother<-snps_pa_overall_activity_mother[-c(1:6)]

##Child**

snps_alcohol_bestguess_children$aln <-as.numeric(substr(snps_alcohol_bestguess_children$children_snp_alc_FID, 1, 5))
snps_alcohol_bestguess_children$qlet<-substr(snps_alcohol_bestguess_children$children_snp_alc_FID, 6, 6)
snps_alcohol_bestguess_children<-snps_alcohol_bestguess_children[-c(1:6)]

snps_caffeine_bestguess_children$aln <-as.numeric(substr(snps_caffeine_bestguess_children$children_snp_caff_FID, 1, 5))
snps_caffeine_bestguess_children$qlet<-substr(snps_caffeine_bestguess_children$children_snp_caff_FID, 6, 6)
snps_caffeine_bestguess_children<-snps_caffeine_bestguess_children[-c(1:6)]

snps_smoking_age_init_bestguess_children$aln <-as.numeric(substr(snps_smoking_age_init_bestguess_children$children_snp_age_init_FID, 1, 5))
snps_smoking_age_init_bestguess_children$qlet<-substr(snps_smoking_age_init_bestguess_children$children_snp_age_init_FID, 6, 6)
snps_smoking_age_init_bestguess_children<-snps_smoking_age_init_bestguess_children[-c(1:6)]

snps_smoking_cessation_bestguess_children$aln <-as.numeric(substr(snps_smoking_cessation_bestguess_children$children_snp_cessation_FID, 1, 5))
snps_smoking_cessation_bestguess_children$qlet<-substr(snps_smoking_cessation_bestguess_children$children_snp_cessation_FID, 6, 6)
snps_smoking_cessation_bestguess_children<-snps_smoking_cessation_bestguess_children[-c(1:6)]

snps_smoking_cigs_pd_bestguess_children$aln <-as.numeric(substr(snps_smoking_cigs_pd_bestguess_children$children_snp_cigspd_FID, 1, 5))
snps_smoking_cigs_pd_bestguess_children$qlet<-substr(snps_smoking_cigs_pd_bestguess_children$children_snp_cigspd_FID, 6, 6)
snps_smoking_cigs_pd_bestguess_children<-snps_smoking_cigs_pd_bestguess_children[-c(1:6)]

snps_smoking_initiation_bestguess_children$aln <-as.numeric(substr(snps_smoking_initiation_bestguess_children$children_snp_initiation_FID, 1, 5))
snps_smoking_initiation_bestguess_children$qlet<-substr(snps_smoking_initiation_bestguess_children$children_snp_initiation_FID, 6, 6)
snps_smoking_initiation_bestguess_children<-snps_smoking_initiation_bestguess_children[-c(1:6)]

snps_pa_sedentary_bestguess_children$aln <-as.numeric(substr(snps_pa_sedentary_bestguess_children$children_snp_sedentary_FID, 1, 5))
snps_pa_sedentary_bestguess_children$qlet<-substr(snps_pa_sedentary_bestguess_children$children_snp_sedentary_FID, 6, 6)
snps_pa_sedentary_bestguess_children<-snps_pa_sedentary_bestguess_children[-c(1:6)]

snps_pa_overall_activity_children$aln <-as.numeric(substr(snps_pa_overall_activity_children$children_snp_overallact_FID, 1, 5))
snps_pa_overall_activity_children$qlet<-substr(snps_pa_overall_activity_children$children_snp_overallact_FID, 6, 6)
snps_pa_overall_activity_children<-snps_pa_overall_activity_children[-c(1:6)]

## Merge
dat<-left_join(dat,snps_alcohol_bestguess_mother[,-which(colnames(snps_alcohol_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_alcohol_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_caffeine_bestguess_mother[,-which(colnames(snps_caffeine_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_caffeine_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_age_init_bestguess_mother[,-which(colnames(snps_smoking_age_init_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_age_init_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_cessation_bestguess_mother[,-which(colnames(snps_smoking_cessation_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_cessation_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_cigs_pd_bestguess_mother[,-which(colnames(snps_smoking_cigs_pd_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_cigs_pd_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_initiation_bestguess_mother[,-which(colnames(snps_smoking_initiation_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_initiation_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_pa_sedentary_bestguess_mother[,-which(colnames(snps_pa_sedentary_bestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_pa_sedentary_bestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_pa_overall_activity_mother[,-which(colnames(snps_pa_overall_activity_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_pa_overall_activity_children, by =c("aln", "qlet"))

# Principal components

principal_components_mother<-read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/principal_components/final_pcs/mums_pcs.dta")
principal_components_child<-read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/principal_components/final_pcs/children_pcs.dta")


dat<-left_join(dat,principal_components_mother[,-which(colnames(principal_components_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,principal_components_child, by =c("aln", "qlet"))

dat

}