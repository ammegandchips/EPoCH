gen_genetic_data <- function(){

## Read in PRS data and clean

##nb I created the file labeled as 'mothers' but this holds both mums and child
prs_alcohol <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210303_scores_alcohol_mothers.profile",
                          header = T,
                          check.names = F)

#combine FID and IID columns
prs_alcohol$id<-paste(prs_alcohol$FID,prs_alcohol$IID,sep="_")
#rename score for each exposure
prs_alcohol$prs_score_alcohol<-prs_alcohol$SCORE
## keep only the columns we want
prs_alcohol<-prs_alcohol[, which(names(prs_alcohol) %in% c("prs_score_alcohol","id"))]

### Smoking
#Smoking age initiation
prs_smoking_age_init <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210324_scores_smoking_age_init.profile",
                                   header = T,
                                   check.names = F)

#combine FID and IID columns
prs_smoking_age_init$id<-paste(prs_smoking_age_init$FID,prs_smoking_age_init$IID,sep="_")
#rename score for each exposure
prs_smoking_age_init$prs_score_smoking_age_init<-prs_smoking_age_init$SCORE
## keep only the columns we want
prs_smoking_age_init<-prs_smoking_age_init[, which(names(prs_smoking_age_init) %in% c("prs_score_smoking_age_init","id"))]

#Smoking cessation
prs_smoking_cessation <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210325_scores_smoking_cessation.profile",
                                    header = T,
                                    check.names = F)

#combine FID and IID columns
prs_smoking_cessation$id<-paste(prs_smoking_cessation$FID,prs_smoking_cessation$IID,sep="_")
#rename score for each exposure
prs_smoking_cessation$prs_score_smoking_cessation<-prs_smoking_cessation$SCORE
## keep only the columns we want
prs_smoking_cessation<-prs_smoking_cessation[, which(names(prs_smoking_cessation) %in% c("prs_score_smoking_cessation","id"))]

#smoking cigs per day
prs_smoking_cigs_pd <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210325_scores_smoking_cigs_pd.profile",
                                  header = T,
                                  check.names = F)

#combine FID and IID columns
prs_smoking_cigs_pd$id<-paste(prs_smoking_cigs_pd$FID,prs_smoking_cigs_pd$IID,sep="_")
#rename score for each exposure
prs_smoking_cigs_pd$prs_score_smoking_cigs_pd<-prs_smoking_cigs_pd$SCORE
## keep only the columns we want
prs_smoking_cigs_pd<-prs_smoking_cigs_pd[, which(names(prs_smoking_cigs_pd) %in% c("prs_score_smoking_cigs_pd","id"))]

#Smoking initiation
prs_smoking_initiation <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210325_scores_smoking_initiation.profile",
                                     header = T,
                                     check.names = F)

#combine FID and IID columns
prs_smoking_initiation$id<-paste(prs_smoking_initiation$FID,prs_smoking_initiation$IID,sep="_")
#rename score for each exposure
prs_smoking_initiation$prs_score_smoking_initiation<-prs_smoking_initiation$SCORE
## keep only the columns we want
prs_smoking_initiation<-prs_smoking_initiation[, which(names(prs_smoking_initiation) %in% c("prs_score_smoking_initiation","id"))]

#Caffeine
prs_caffeine <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210325_scores_caffeine.profile",
                           header = T,
                           check.names = F)

#combine FID and IID columns
prs_caffeine$id<-paste(prs_caffeine$FID,prs_caffeine$IID,sep="_")
#rename score for each exposure
prs_caffeine$prs_score_caffeine<-prs_caffeine$SCORE
## keep only the columns we want
prs_caffeine<-prs_caffeine[, which(names(prs_caffeine) %in% c("prs_score_caffeine","id"))]

###Physical activity
## None for overall activity as too few variants to make PRS

#Sedentary

prs_sedentary <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/final_scores/20210326_scores_pa_sedentary.profile",
                            header = T,
                            check.names = F)
prs_sedentary$id<-paste(prs_sedentary$FID,prs_sedentary$IID,sep="_")
#rename score for each exposure
prs_sedentary$prs_score_sedentary<-prs_sedentary$SCORE
## keep only the columns we want
prs_sedentary<-prs_sedentary[, which(names(prs_sedentary) %in% c("prs_score_sedentary","id"))]

## Read in individual SNP data and clean

#! Potential for duplicate snps to present in final dataset, as come from different snp lists for exposures - an option round this, is to rename with 'alc' 'smok' etc before name of snp??

snps_alcohol<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/alcohol_mothers_excluded_numb.raw", header=T)
snps_smoking_initiation<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/smoking_initiation_excluded_numb.raw", header=T)
snps_smoking_cigs_pd<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/smoking_cigs_pd_excluded_numb.raw", header=T)
snps_smoking_cessation<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/smoking_cessation_excluded_numb.raw", header=T)
snps_smoking_age_init<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/smoking_age_init_excluded_numb.raw", header=T)
snps_sedentary<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/pa_sedentary_excluded_numb.raw", header=T)
snps_overall_activity<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/pa_overall_activity_excluded_numb.raw", header=T)
snps_caffeine<-read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/individual_snp_score/caffeine_excluded_numb.raw", header=T)


snps_alcohol$id<-paste(snps_alcohol$FID,snps_alcohol$IID,sep="_")
## keep only the columns we want
snps_alcohol<-snps_alcohol[, -which(colnames(snps_alcohol) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_smoking_initiation$id<-paste(snps_smoking_initiation$FID,snps_smoking_initiation$IID,sep="_")
snps_smoking_initiation<-snps_smoking_initiation[, -which(colnames(snps_smoking_initiation) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_smoking_cigs_pd$id<-paste(snps_smoking_cigs_pd$FID,snps_smoking_cigs_pd$IID,sep="_")
snps_smoking_cigs_pd<-snps_smoking_cigs_pd[, -which(colnames(snps_smoking_cigs_pd) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_smoking_cessation$id<-paste(snps_smoking_cessation$FID,snps_smoking_cessation$IID,sep="_")
snps_smoking_cessation<-snps_smoking_cessation[, -which(colnames(snps_smoking_cessation) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_smoking_age_init$id<-paste(snps_smoking_age_init$FID,snps_smoking_age_init$IID,sep="_")
snps_smoking_age_init<-snps_smoking_age_init[, -which(colnames(snps_smoking_age_init) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_sedentary$id<-paste(snps_sedentary$FID,snps_sedentary$IID,sep="_")
snps_sedentary<-snps_sedentary[, -which(colnames(snps_sedentary) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_overall_activity$id<-paste(snps_overall_activity$FID,snps_overall_activity$IID,sep="_")
snps_overall_activity<-snps_overall_activity[, -which(colnames(snps_overall_activity) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]

snps_caffeine$id<-paste(snps_caffeine$FID,snps_caffeine$IID,sep="_")
snps_caffeine<-snps_caffeine[, -which(colnames(snps_caffeine) %in% c("FID","IID","SEX","PAT","MAT","PHENOTYPE"))]


## Quality control

library(readstata13)

exclude <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/data_prep/cohorts/bib/pca_prep/directly_genotyped_released_ibd.genome.exclusions.uniq.txt")
exclude <- exclude$V1 #15628 to 14439
exclude_child <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/data_prep/cohorts/bib/pca_prep/child/directly_genotyped_released_ibd.genome.exclusions.uniq.txt")
exclude_child <- exclude_child$V1 #13859

# EXCLUDE those on exclusion list - 
#mothers
prs_alcohol <- prs_alcohol[ ! prs_alcohol$id %in% exclude, ]
dim(prs_alcohol) 
#child 
prs_alcohol <- prs_alcohol[ ! prs_alcohol$id %in% exclude_child, ]
dim(prs_alcohol) 

#mothers
prs_smoking_age_init <- prs_smoking_age_init[ ! prs_smoking_age_init$id %in% exclude, ]
dim(prs_smoking_age_init) 
#child 
prs_smoking_age_init <- prs_smoking_age_init[ ! prs_smoking_age_init$id %in% exclude_child, ]
dim(prs_smoking_age_init)

#mothers
prs_smoking_cessation <- prs_smoking_cessation[ ! prs_smoking_cessation$id %in% exclude, ]
dim(prs_smoking_cessation) 
#child 
prs_smoking_cessation <- prs_smoking_cessation[ ! prs_smoking_cessation$id %in% exclude_child, ]
dim(prs_smoking_cessation) 

#mothers
prs_smoking_cigs_pd <- prs_smoking_cigs_pd[ ! prs_smoking_cigs_pd$id %in% exclude, ]
dim(prs_smoking_cigs_pd) 
#child 
prs_smoking_cigs_pd <- prs_smoking_cigs_pd[ ! prs_smoking_cigs_pd$id %in% exclude_child, ]
dim(prs_smoking_cigs_pd) 

#mothers
prs_smoking_initiation <- prs_smoking_initiation[ ! prs_smoking_initiation$id %in% exclude, ]
dim(prs_smoking_initiation)
#child 
prs_smoking_initiation <- prs_smoking_initiation[ ! prs_smoking_initiation$id %in% exclude_child, ]
dim(prs_smoking_initiation) 

#mothers
prs_caffeine <- prs_caffeine[ ! prs_caffeine$id %in% exclude, ]
dim(prs_caffeine)
#child 
prs_caffeine <- prs_caffeine[ ! prs_caffeine$id %in% exclude_child, ]
dim(prs_caffeine)

#mothers
prs_sedentary <- prs_sedentary[ ! prs_sedentary$id %in% exclude, ]
dim(prs_sedentary) 
#child 
prs_sedentary <- prs_sedentary[ ! prs_sedentary$id %in% exclude_child, ]
dim(prs_sedentary) 

snps_alcohol <- snps_alcohol[ ! snps_alcohol$id %in% exclude, ]
dim(snps_alcohol) 
#child 
snps_alcohol <- snps_alcohol[ ! snps_alcohol$id %in% exclude_child, ]
dim(snps_alcohol) 

#mothers
snps_smoking_age_init <- snps_smoking_age_init[ ! snps_smoking_age_init$id %in% exclude, ]
dim(snps_smoking_age_init) 
#child 
snps_smoking_age_init <- snps_smoking_age_init[ ! snps_smoking_age_init$id %in% exclude_child, ]
dim(snps_smoking_age_init)

#mothers
snps_smoking_cessation <- snps_smoking_cessation[ ! snps_smoking_cessation$id %in% exclude, ]
dim(snps_smoking_cessation) 
#child 
snps_smoking_cessation <- snps_smoking_cessation[ ! snps_smoking_cessation$id %in% exclude_child, ]
dim(snps_smoking_cessation) 

#mothers
snps_smoking_cigs_pd <- snps_smoking_cigs_pd[ ! snps_smoking_cigs_pd$id %in% exclude, ]
dim(snps_smoking_cigs_pd) 
#child 
snps_smoking_cigs_pd <- snps_smoking_cigs_pd[ ! snps_smoking_cigs_pd$id %in% exclude_child, ]
dim(snps_smoking_cigs_pd) 

#mothers
snps_smoking_initiation <- snps_smoking_initiation[ ! snps_smoking_initiation$id %in% exclude, ]
dim(snps_smoking_initiation)
#child 
snps_smoking_initiation <- snps_smoking_initiation[ ! snps_smoking_initiation$id %in% exclude_child, ]
dim(snps_smoking_initiation) 

#mothers
snps_caffeine <- snps_caffeine[ ! snps_caffeine$id %in% exclude, ]
dim(snps_caffeine)
#child 
snps_caffeine <- snps_caffeine[ ! snps_caffeine$id %in% exclude_child, ]
dim(snps_caffeine)

#mothers
snps_sedentary <- snps_sedentary[ ! snps_sedentary$id %in% exclude, ]
dim(snps_sedentary) 
#child 
snps_sedentary <- snps_sedentary[ ! snps_sedentary$id %in% exclude_child, ]
dim(snps_sedentary) 

#mothers
snps_overall_activity <- snps_overall_activity[ ! snps_overall_activity$id %in% exclude, ]
dim(snps_overall_activity) 
#child 
snps_overall_activity <- snps_overall_activity[ ! snps_overall_activity$id %in% exclude_child, ]
dim(snps_overall_activity) 

## PCA
#PCs made using Plink. Run mapping.R script and then bib_pc.sh/bib_pc_child.sh in Plink

#Mum PCAs #7533
bib_pca <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/pca_prep/pcs/directly_genotyped_released_pca.eigenvec", header = TRUE)
bib_pca=subset(subset(bib_pca,select=-c(IID)))
bib_pca<-bib_pca%>%rename_with(tolower)
names(bib_pca)<-paste0("mum",names(bib_pca))
colnames(bib_pca)[1] <- "id"

## Child PCAs #6308
bib_pca_child <- read.table("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/pca_prep/pcs/child/directly_genotyped_released_pca.eigenvec", header = TRUE)
bib_pca_child=subset(subset(bib_pca_child,select=-c(IID)))

bib_pca_child<-bib_pca_child%>%rename_with(tolower)
names(bib_pca_child)<-paste0("child",names(bib_pca_child))
colnames(bib_pca_child)[1] <- "id"

## linking genetic data

##PCs
linkage <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_CohortInfo/p6_linkage_v1-14-1_BiB_CohortInfo.genotyping_info.dta")
link_maternal <- left_join(bib_pca,linkage,by=c("id"="lab_id"))
link_child <- left_join(bib_pca_child,linkage,by=c("id"="lab_id"))
link <- bind_rows(link_maternal,link_child)

##PRSs
link_genetic <- left_join(link, prs_alcohol, by="id")
link_genetic <- left_join(link_genetic, prs_caffeine, by = "id")
link_genetic <- left_join(link_genetic, prs_smoking_age_init, by = "id")
link_genetic <- left_join(link_genetic, prs_smoking_cessation, by = "id")
link_genetic <- left_join(link_genetic, prs_smoking_cigs_pd, by = "id")
link_genetic <- left_join(link_genetic, prs_smoking_initiation, by = "id")
link_genetic <- left_join(link_genetic, prs_sedentary, by = "id")
#7533

link_genetic <- left_join(link_genetic, snps_alcohol, by = "id")
link_genetic <- left_join(link_genetic, snps_caffeine, by = "id")
link_genetic <- left_join(link_genetic, snps_smoking_age_init, by = "id")
link_genetic <- left_join(link_genetic, snps_smoking_cessation, by = "id")
link_genetic <- left_join(link_genetic, snps_smoking_cigs_pd, by = "id")
link_genetic <- left_join(link_genetic, snps_smoking_initiation, by = "id")
link_genetic <- left_join(link_genetic, snps_sedentary, by = "id")
link_genetic <- left_join(link_genetic, snps_overall_activity, by = "id")

#split into mother and child dataframes and rename prs columns accordingly (leave snp columns for now - we might not use them)
link_genetic_child <- link_genetic[link_genetic$id %in% bib_pca_child$id,]
link_genetic_mother <- link_genetic[link_genetic$id %in% bib_pca$id,]

link_genetic_child <- rename(link_genetic_child,
prs_score_child_alcohol=prs_score_alcohol,
prs_score_child_caffeine=prs_score_caffeine,
prs_score_child_smoking_age_init=prs_score_smoking_age_init,
prs_score_child_smoking_cessation=prs_score_smoking_cessation,
prs_score_child_smoking_cigs_pd=prs_score_smoking_cigs_pd,
prs_score_child_smoking_initiation=prs_score_smoking_initiation,
prs_score_child_pa_sedentary=prs_score_sedentary)

link_genetic_mother <- rename(link_genetic_mother,
                             prs_score_mother_alcohol=prs_score_alcohol,
                             prs_score_mother_caffeine=prs_score_caffeine,
                             prs_score_mother_smoking_age_init=prs_score_smoking_age_init,
                             prs_score_mother_smoking_cessation=prs_score_smoking_cessation,
                             prs_score_mother_smoking_cigs_pd=prs_score_smoking_cigs_pd,
                             prs_score_mother_smoking_initiation=prs_score_smoking_initiation,
                             prs_score_mother_pa_sedentary=prs_score_sedentary)


# z scores for prs
prs_vars <- names(link_genetic_child)[grep(names(link_genetic_child),pattern="prs")]
scaled_prs <- as.data.frame(apply(link_genetic_child[,prs_vars],2,scale))
names(scaled_prs) <- paste0(prs_vars,"_zscore")
link_genetic_child <- bind_cols(link_genetic_child,scaled_prs)

prs_vars <- names(link_genetic_mother)[grep(names(link_genetic_mother),pattern="prs")]
scaled_prs <- as.data.frame(apply(link_genetic_mother[,prs_vars],2,scale))
names(scaled_prs) <- paste0(prs_vars,"_zscore")
link_genetic_mother <- bind_cols(link_genetic_mother,scaled_prs)

saveRDS(link_genetic_child,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_all_genetic_child.rds")
saveRDS(link_genetic_mother,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_all_genetic_mother.rds")

list(link_genetic_child,link_genetic_mother)

}
