######################################################################
## Code to create mcs_pheno_raw.rds                                 ##
######################################################################

library(knitr)
library(haven)
family_file <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-8172-stata11/UKDA-8172-stata11/stata11/mcs_longitudinal_family_file.dta")
names(family_file)<-tolower(names(family_file))

hhg1 <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-4683-stata11/stata11/mcs1_hhgrid.dta")

mcs1_parent_interview <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-4683-stata11/UKDA-4683-stata11/stata11/mcs1_parent_interview.dta")
mcs1_derived <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-4683-stata11/UKDA-4683-stata11/stata11/mcs1_derived_variables.dta")

names(mcs1_derived)<-tolower(names(mcs1_derived))

mcs2_parent_interview <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5350-stata11_se/stata11_se/mcs2_parent_interview.dta")
mcs2_child_assessment <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5350-stata11_se/stata11_se/mcs2_child_assessment_data.dta")
mcs2_child_measurement <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5350-stata11_se/stata11_se/mcs2_child_measurement_data.dta")
mcs2_derived <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5350-stata11_se/stata11_se/mcs2_derived_variables.dta")

mcs3_parent_interview <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5795-stata11_se/UKDA-5795-stata11_se/stata11_se/mcs3_parent_interview.dta")
mcs3_child_assessment <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5795-stata11_se/UKDA-5795-stata11_se/stata11_se/mcs3_child_assessment_data.dta")
mcs3_derived <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-5795-stata11_se/UKDA-5795-stata11_se/stata11_se/mcs3_derived_variables.dta")

mcs4_parent_interview <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-6411-stata11_se/UKDA-6411-stata11_se/stata11_se/mcs4_parent_interview.dta")
mcs4_child_assessment <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-6411-stata11_se/UKDA-6411-stata11_se/stata11_se/mcs4_cm_assessment.dta")
mcs4_derived <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-6411-stata11_se/UKDA-6411-stata11_se/stata11_se/mcs4_derived_variables.dta")

mcs5_parent_interview <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-7464-stata11/UKDA-7464-stata11/stata11/mcs5_parent_interview.dta")
mcs5_parent_derived <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-7464-stata11/UKDA-7464-stata11/stata11/mcs5_parent_derived.dta")
mcs5_child_assessment <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-7464-stata11/UKDA-7464-stata11/stata11/mcs5_cm_assessment.dta")
mcs5_cm_derived <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-7464-stata11/UKDA-7464-stata11/stata11/mcs5_cm_derived.dta")
mcs5_child_measurement <- read_dta("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/UKDA-7464-stata11/UKDA-7464-stata11/stata11/mcs5_cm_measurement.dta")

mcs1_parent_interview <- zap_labels(mcs1_parent_interview)

# merge parent level datasets (sweeps 1-4 are in wide format, sweep 5 is in long format)

raw_dat <- merge(family_file,mcs1_parent_interview,by="mcsid",all=T)# family file contains one row per family, includes data on weights, mcsid is family id, pnum is adult id, cnum is child id
raw_dat <- merge(raw_dat,mcs2_parent_interview,by="mcsid",all.x=T)
raw_dat <- merge(raw_dat,mcs3_parent_interview,by="mcsid",all.x=T)
raw_dat <- merge(raw_dat,mcs4_parent_interview[,-which(colnames(mcs4_parent_interview) %in% "daoutc00")],by="mcsid",all.x=T)
names(mcs5_parent_interview)<-tolower(names(mcs5_parent_interview))
raw_dat <- merge(raw_dat,mcs5_parent_interview[mcs5_parent_interview$eelig00==1,],by="mcsid",all=T) # by selecting eelig==1, we're selecting data from just one respondent, the one that has been eligible for the role of main respondent - this is fine as we're not actually selecting any parent data by this point, we just want to get the dataset at the family level

names(mcs1_derived)<-tolower(names(mcs1_derived))
names(mcs2_derived)<-tolower(names(mcs2_derived))
names(mcs3_derived)<-tolower(names(mcs3_derived))
names(mcs4_derived)<-tolower(names(mcs4_derived))
names(mcs5_cm_derived)<-tolower(names(mcs5_cm_derived))
names(mcs5_parent_derived)<-tolower(names(mcs5_parent_derived))

duplicated_variables <- intersect(colnames(raw_dat),c(colnames(mcs1_derived),colnames(mcs2_derived),colnames(mcs3_derived),colnames(mcs4_derived),colnames(mcs5_parent_derived)))[-1]

raw_dat <- merge(raw_dat,mcs1_derived,by="mcsid",all.x=T)
raw_dat <- merge(raw_dat,mcs2_derived[,-which(colnames(mcs2_derived)%in%duplicated_variables)],by="mcsid",all.x=T)
raw_dat <- merge(raw_dat,mcs3_derived,by="mcsid",all.x=T)
raw_dat <- merge(raw_dat,mcs4_derived[,-which(colnames(mcs4_derived)%in%duplicated_variables)],by="mcsid",all.x=T)
mcs5_parent_derived2 <- mcs5_parent_derived[mcs5_parent_derived$eelig00==1,]
raw_dat <- merge(raw_dat,mcs5_parent_derived2[,-which(colnames(mcs5_parent_derived2)%in%duplicated_variables)],by="mcsid",all.x=T)

# add child-level data (select just cohort member 1)

names(mcs4_child_assessment)<-tolower(names(mcs4_child_assessment))
names(mcs5_child_assessment)<-tolower(names(mcs5_child_assessment))
names(mcs5_child_measurement)<-tolower(names(mcs5_child_measurement))
names(mcs5_cm_derived)<-tolower(names(mcs5_cm_derived))

mcs2_child_assessment <- mcs2_child_assessment[mcs2_child_assessment$bhcnum00==1,]
mcs2_child_measurement <- mcs2_child_measurement[mcs2_child_measurement$bhcnum00==1,]
mcs3_child_assessment <- mcs3_child_assessment[mcs3_child_assessment$chcnum00==1,]
mcs4_child_assessment <- mcs4_child_assessment[mcs4_child_assessment$dccnum00==1,]
mcs5_child_measurement <- mcs5_child_measurement[mcs5_child_measurement$ecnum00==1,]
mcs5_child_assessment <- mcs5_child_assessment[mcs5_child_assessment$ecnum00==1,]
mcs5_cm_derived <- mcs5_cm_derived[mcs5_cm_derived$ecnum00==1,]

duplicated_variables <- c("cddatrel","bhcnum00","chcnum00","dccnum00","ecnum00")

raw_dat <- merge(raw_dat,mcs2_child_measurement[-which(colnames(mcs2_child_measurement)%in%duplicated_variables)],by="mcsid",all.x=T)
duplicated_variables2 <- c(duplicated_variables,intersect(colnames(raw_dat),colnames(mcs2_child_assessment)))
duplicated_variables2 <-duplicated_variables2[-which(duplicated_variables2=="mcsid")]
raw_dat <- merge(raw_dat,mcs2_child_assessment[-which(colnames(mcs2_child_assessment)%in%duplicated_variables2)],by="mcsid",all.x=T)
duplicated_variables2 <- c(duplicated_variables,intersect(colnames(raw_dat),colnames(mcs3_child_assessment)))
duplicated_variables2 <-duplicated_variables2[-which(duplicated_variables2=="mcsid")]
raw_dat <- merge(raw_dat,mcs3_child_assessment[-which(colnames(mcs3_child_assessment)%in%duplicated_variables2)],by="mcsid",all.x=T)
duplicated_variables2 <- c(duplicated_variables,intersect(colnames(raw_dat),colnames(mcs4_child_assessment)))
duplicated_variables2 <-duplicated_variables2[-which(duplicated_variables2=="mcsid")]
raw_dat <- merge(raw_dat,mcs4_child_assessment[-which(colnames(mcs4_child_assessment)%in%duplicated_variables2)],by="mcsid",all.x=T)
duplicated_variables2 <- c(duplicated_variables,intersect(colnames(raw_dat),colnames(mcs5_child_assessment)))
duplicated_variables2 <-duplicated_variables2[-which(duplicated_variables2=="mcsid")]
raw_dat <- merge(raw_dat,mcs5_child_assessment[-which(colnames(mcs5_child_assessment)%in%duplicated_variables2)],by="mcsid",all.x=T)
duplicated_variables2 <- c(duplicated_variables,intersect(colnames(raw_dat),colnames(mcs5_child_measurement)))
duplicated_variables2 <-duplicated_variables2[-which(duplicated_variables2=="mcsid")]
raw_dat <- merge(raw_dat,mcs5_child_measurement[-which(colnames(mcs5_child_measurement)%in%duplicated_variables2)],by="mcsid",all.x=T)
duplicated_variables2 <- c(duplicated_variables,intersect(colnames(raw_dat),colnames(mcs5_cm_derived)))
duplicated_variables2 <-duplicated_variables2[-which(duplicated_variables2=="mcsid")]
raw_dat <- merge(raw_dat,mcs5_cm_derived[-which(colnames(mcs5_cm_derived)%in%duplicated_variables2)],by="mcsid",all.x=T)

raw_dat <- zap_labels(raw_dat)

raw_dat <- raw_dat[which(raw_dat$amdres00==1&is.na(raw_dat$amdres00)==FALSE),] # select only those where the natural mother is the main respondent (vast majority of cases, lose 55 non-mothers, 691 missing status)

raw_dat <- raw_dat[raw_dat$nocmhh==1,]#select singletons/first borns in cohort (lose 251 children of a twin pair + 10 children of a triplet trio)

raw_dat$covs_biological_father<-"not_bio_dad"
raw_dat$covs_biological_father[raw_dat$apdres00%in%c(2,12,16,24)]<-"bio_dad"
raw_dat$covs_biological_father[raw_dat$apdres00==(-1)]<-"no_partner"
raw_dat$covs_biological_father[is.na(raw_dat$apdres00)]<-"missing"

# Paternal participation is defined as a partner (bio dad, foster/adoptive/step, male/female partner) completing the interview themselves (i.e. not by proxy)
raw_dat$paternal_participation <- NA
raw_dat$paternal_participation[raw_dat$apdres00%in%c(2,4,6,8,26,25,31)]<-1
raw_dat$paternal_participation[raw_dat$apdres00%in%c(-1,7,21,22,16,12,24,22,28,30)]<-0

saveRDS(raw_dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno_raw.rds")