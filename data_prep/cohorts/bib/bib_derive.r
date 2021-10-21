######################################################################
## Code to create bib_pheno.rds                                     ##
## This code cleans and derives variables from bib_pheno_raw.rds   ##
######################################################################

library(tidyverse)
library(haven)
raw_dat <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_raw_pheno.rds")
raw_dat <- haven::zap_labels(raw_dat)

#set up new dat object:
dat<-raw_dat[,c("BiBMotherID","BiBFatherID","BiBPregNumber","epoch_child_id")]

# creating paternal participation var in BiB
dat$paternal_participation<-NA
dat$paternal_participation<-ifelse(dat$BiBFatherID=="",0,1)

##### COVARIATES
#glycosuria, existing diabetes or gestational diabetes vs no glycosuria or diabetes
dat$covs_glycosuria_binary<-NA
dat$covs_glycosuria_binary[raw_dat$drvgesdiab==1&raw_dat$bkfdiabete==1]<-0
dat$covs_glycosuria_binary[raw_dat$drvgesdiab==2|raw_dat$bkfdiabete==2]<-1
dat$covs_glycosuria_binary[raw_dat$prnprexcont1dm==2]<-1
dat$covs_glycosuria_binary[raw_dat$prnprexcont2dm==2]<-1
# preeclampsia or pregnancy induced HT
dat$covs_hdp_binary<-NA
dat$covs_hdp_binary[raw_dat$bkfhyperpi==1&raw_dat$bkfpreeclm==1]<-0
dat$covs_hdp_binary[raw_dat$bkfhyperpi==2|raw_dat$bkfhyperpi==3|raw_dat$bkfhyperpi==4|raw_dat$bkfpreeclm==2]<-1
# gender
dat$covs_sex<-NA
dat$covs_sex[raw_dat$Gender=="Male"]<-"male"
dat$covs_sex[raw_dat$Gender=="Female"]<-"female"
# Maternal age 
# this was measured during pregnancy. I've used in years, but months is also available (agemm_mbagtt) 
dat$covs_age_mother_conception<-raw_dat$agemy_mbqall
# Paternal age
dat$covs_age_father_pregnancy<-raw_dat$agefy_fbqall
#Parity
dat$covs_parity_mother_binary<-NA
dat$covs_parity_mother_binary[raw_dat$eclregpart==0]<-0
dat$covs_parity_mother_binary[raw_dat$eclregpart>0]<-1
#Maternal ethnicity
dat$covs_ethnicity_mother<-NA
dat$covs_ethnicity_mother[raw_dat$eth0eth9gp%in%c(1,2)]<-"white"
dat$covs_ethnicity_mother[raw_dat$eth0eth9gp%in%c(3,4,9)]<-"mixed or other"
dat$covs_ethnicity_mother[raw_dat$eth0eth9gp%in%c(6,7,8)]<-"asian"
dat$covs_ethnicity_mother[raw_dat$eth0eth9gp%in%c(5)]<-"black"
dat$covs_ethnicityBIB_mother <-NA
dat$covs_ethnicityBIB_mother[raw_dat$eth0eth9gp%in%c(1,2)]<-"white european"
dat$covs_ethnicityBIB_mother[raw_dat$eth0eth9gp%in%c(6,7,8)]<-"south asian"
dat$covs_ethnicityBIB_mother[raw_dat$eth0eth9gp%in%c(3,4,9,5)]<-"other"
dat$covs_ethnicity_mother_binary <- NA
dat$covs_ethnicity_mother_binary[dat$covs_ethnicityBIB_mother == "white european"] <- "white"
dat$covs_ethnicity_mother_binary[dat$covs_ethnicityBIB_mother %in% c("other","south asian")] <- "not white"
# Paternal ethnicity
dat$covs_ethnicity_father<-NA
dat$covs_ethnicity_father[raw_dat$fbqethnicgrp%in%c(1)]<-"white"
dat$covs_ethnicity_father[raw_dat$fbqethnicgrp%in%c(2,6)]<-"mixed or other"
dat$covs_ethnicity_father[raw_dat$fbqethnicgrp%in%c(4,5)]<-"asian"
dat$covs_ethnicity_father[raw_dat$fbqethnicgrp%in%c(3)]<-"black"
dat$covs_ethnicityBIB_father <-NA
dat$covs_ethnicityBIB_father[raw_dat$fbqethnicgrp%in%c(1)]<-"white european"
dat$covs_ethnicityBIB_father[raw_dat$fbqethnicgrp%in%c(4)]<-"south asian"
dat$covs_ethnicityBIB_father[raw_dat$fbqethnicgrp%in%c(2,3,5,6)]<-"other"
dat$covs_ethnicity_father_binary <- NA
dat$covs_ethnicity_father_binary[dat$covs_ethnicityBIB_father == "white european"] <- "white"
dat$covs_ethnicity_father_binary[dat$covs_ethnicityBIB_father %in% c("other","south asian")] <- "not white"
# Maternal education (other/don't know/foreign unknown all coded as 0 as in https://www.sciencedirect.com/science/article/pii/S2542519618301190)
dat$covs_edu_mother<-NA
dat$covs_edu_mother[raw_dat$edu0mumede%in%c(1,5,6,7)] <-0 #"<5 GCSE equivalent"
dat$covs_edu_mother[raw_dat$edu0mumede==2] <-1 #"5 GCSE equivalent"
dat$covs_edu_mother[raw_dat$edu0mumede==3] <-2 #"A-level equivalent"
dat$covs_edu_mother[raw_dat$edu0mumede==4] <-3 #"Higher than A-level"
# Paternal education
dat$covs_edu_father<-NA
dat$covs_edu_father[raw_dat$edu0fthede%in%c(1,5,6,7)] <-0
dat$covs_edu_father[raw_dat$edu0fthede==2] <-1
dat$covs_edu_father[raw_dat$edu0fthede==3] <-2
dat$covs_edu_father[raw_dat$edu0fthede==4] <-3
# Maternal occupation
# mother's occupation not recorded in the data currently in Bristol. Lifecycle have used variables 	bib6f06 (etc) from the BiB1000 sub study and all24e7 etc (from ALL-IN sub study). We have employment status, but this isn't the same as occupation and can't be used in its place.
# Paternal occupation (note the typos in raw_dat variables are real, not mistakes in the EPoCH code)
dat$covs_occup_father <- NA
dat$covs_occup_father[raw_dat$job0fthwrk %in% c(1,3,8)] <- 3 #professional or managerial
dat$covs_occup_father[raw_dat$job0fthwrk %in% c(2,7)] <- 2 #skilled non-manual
dat$covs_occup_father[raw_dat$job0fthwrk %in% c(4,5)] <- 1 #skilled manual
dat$covs_occup_father[raw_dat$job0fthwrk %in% c(6,11,12)] <- 0 #semi-skilled or unskilled or LT unemployed/sick or don't know
dat$covs_edu_father_highestlowest_binary <- NA
dat$covs_edu_father_highestlowest_binary[dat$covs_edu_father==0] <- 0
dat$covs_edu_father_highestlowest_binary[dat$covs_edu_father==3] <- 1
dat$covs_edu_mother_highestlowest_binary <- NA
dat$covs_edu_mother_highestlowest_binary[dat$covs_edu_mother==0] <- 0
dat$covs_edu_mother_highestlowest_binary[dat$covs_edu_mother==3] <- 1
dat$covs_occup_father_highestlowest_binary <- NA
dat$covs_occup_father_highestlowest_binary[dat$covs_occup_father==0] <- 0
dat$covs_occup_father_highestlowest_binary[dat$covs_occup_father==3] <- 1
# Living with partner
dat$covs_partner_lives_with_mother_prenatal<-NA
dat$covs_partner_lives_with_mother_prenatal[raw_dat$hhd0cohabt%in%c(1,2)]<- 1
dat$covs_partner_lives_with_mother_prenatal[raw_dat$hhd0cohabt==3]<- 0
# mum married (or not separated)
dat$covs_married_mother_binary<-NA
dat$covs_married_mother_binary[raw_dat$hhd0martst%in%c(1,2)]<-1
dat$covs_married_mother_binary[raw_dat$hhd0martst%in%c(3,4,5,6)]<-0
#Mother's asthma (lots of missingness)
dat$covs_asthma_mother <- NA
dat$covs_asthma_mother[raw_dat$prnprexconasthma==1]<-0
dat$covs_asthma_mother[raw_dat$guadtIllnessList_6_mum==1]<-1
dat$covs_asthma_mother[raw_dat$prnprexconasthma==2]<-1
#Mother's mental illness (lots of missingness)
dat$covs_mentalhealthdisorder_mother <- NA
dat$covs_mentalhealthdisorder_mother[raw_dat$prnprexconmentheal==1]<-0
dat$covs_mentalhealthdisorder_mother[raw_dat$guadtIllnessList_8_mum==1]<-1 #anxiety
dat$covs_mentalhealthdisorder_mother[raw_dat$guadtIllnessList_9_mum==1]<-1 #depression
dat$covs_mentalhealthdisorder_mother[raw_dat$guadtIllnessList_10_mum==1]<-1 #other
dat$covs_mentalhealthdisorder_mother[raw_dat$prnprexconmentheal==2]<-1
#Drugs in pregnancy
dat$covs_drugs_mother_binary <-NA
dat$covs_drugs_mother_binary[raw_dat$drg0drguse==1]<-1
dat$covs_drugs_mother_binary[raw_dat$drg0drguse==2]<-0
# Maternal height
dat$covs_height_mother<-raw_dat$mms0height
# Paternal height
dat$covs_height_father<-raw_dat$fbqheight
dat$covs_height_father[dat$covs_height_father<30|dat$covs_height_father>250]<-NA
# Maternal weight
dat$covs_weight_mother<-raw_dat$mms0weight
# Paternal weight
dat$covs_weight_father<-raw_dat$fbqweight
dat$covs_weight_father[dat$covs_weight_father<20|dat$covs_weight_father>200]<-NA
# Maternal bmi
dat$covs_bmi_mother<-raw_dat$mms0mbkbmi
# Paternal bmi
dat$covs_bmi_father <- dat$covs_weight_father/(dat$covs_height_father/100)^2
#gestage
dat$covs_gestage <- raw_dat$eclgestday/7
dat$covs_preterm_binary <- NA
dat$covs_preterm_binary[dat$covs_gestage<37]<-1
dat$covs_preterm_binary[dat$covs_gestage>=37]<-0

## PERINATAL OUTCOMES
dat$peri_live_birth_binary<-NA
dat$peri_live_birth_binary[raw_dat$prnbibirthoutc%in%c(1)]<-1
dat$peri_live_birth_binary[raw_dat$prnbibirthoutc%in%c(2,3)]<-0

## ANTHRO OUTCOMES

# At birth:
# Birthweight
dat$anthro_birthweight <-raw_dat$eclbirthwt
dat$anthro_birthweight_zscore <- scale(dat$anthro_birthweight)
# High BW > 4500g vs >=2500g & <=4500g 
dat$anthro_birthweight_high_binary <- NA
dat$anthro_birthweight_high_binary[dat$anthro_birthweight>4500]<-1
dat$anthro_birthweight_high_binary[dat$anthro_birthweight>=2500&dat$anthro_birthweight<=4500]<-0
#Low BW <2500g vs >=2500g & <=4500g
dat$anthro_birthweight_low_binary <- NA
dat$anthro_birthweight_low_binary[dat$anthro_birthweight<2500]<-1
dat$anthro_birthweight_low_binary[dat$anthro_birthweight>=2500&dat$anthro_birthweight<=4500]<-0
#	SGA
dat$anthro_birthweight_sga_binary <- NA
dat$anthro_birthweight_sga_binary[raw_dat$eclsgaukwho==1]<-0
dat$anthro_birthweight_sga_binary[raw_dat$eclsgaukwho==2]<-1
#	LGA
dat$anthro_birthweight_lga_binary <- NA
dat$anthro_birthweight_lga_binary[raw_dat$ecllgaukwho==1]<-0
dat$anthro_birthweight_lga_binary[raw_dat$ecllgaukwho==2]<-1
#Head circumference at birth (cm)
dat$anthro_head_circ_birth<-raw_dat$eclheadcir
dat$anthro_head_circ_birth_zscore <- scale(dat$anthro_head_circ_birth)
#birth length (crown-heel) taken as height at birth
dat$anthro_crown_heel_birth <- raw_dat$cheight_0
# setting the month range for each stage
stagebirth_mintime <- 0
stagebirth_maxtime <- 11
stage1_mintime <- 12
stage1_maxtime <- 35
stage2_mintime <- 36
stage2_maxtime <-59
stage3_mintime <- 60
stage3_maxtime <- 95
stage4_mintime <- 96
stage4_maxtime <- 143

select_oldest_measure <- function(prefix,stage_min,stage_max){
  col_names <- paste0(prefix,stage_min:stage_max)
  df <- raw_dat[,which(colnames(raw_dat) %in% col_names)]
  oldest_measure <- apply(df,1,function(x) ifelse(all(is.na(x)),NA,tail(na.omit(x),1)))
  timepoint <- apply(df,1,function(x) ifelse(all(is.na(x)),NA,names(tail(na.omit(x),1))))
  timepoint<-as.numeric(str_remove(timepoint,prefix))
  list(oldest_measure,timepoint)
}

dat$anthro_height_stage0 <- select_oldest_measure("cheight_",stagebirth_mintime,stagebirth_maxtime)[[1]]
dat$covs_stage0_growthtimepoint <- select_oldest_measure("cheight_",stagebirth_mintime,stagebirth_maxtime)[[2]]
dat$anthro_height_stage1 <- select_oldest_measure("cheight_",stage1_mintime,stage1_maxtime)[[1]]
dat$covs_stage1_growthtimepoint <- select_oldest_measure("cheight_",stage1_mintime,stage1_maxtime)[[2]]
dat$anthro_height_stage2 <- select_oldest_measure("cheight_",stage2_mintime,stage2_maxtime)[[1]]
dat$covs_stage2_growthtimepoint <- select_oldest_measure("cheight_",stage2_mintime,stage2_maxtime)[[2]]
dat$anthro_height_stage3 <- select_oldest_measure("cheight_",stage3_mintime,stage3_maxtime)[[1]]
dat$covs_stage3_growthtimepoint <- select_oldest_measure("cheight_",stage3_mintime,stage3_maxtime)[[2]]
dat$anthro_height_stage4 <- select_oldest_measure("cheight_",stage4_mintime,stage4_maxtime)[[1]]
dat$covs_stage4_growthtimepoint <- select_oldest_measure("cheight_",stage4_mintime,stage4_maxtime)[[2]]
dat$anthro_waist_stage0 <- select_oldest_measure("cabdo_",stagebirth_mintime,stagebirth_maxtime)[[1]]
dat$anthro_waist_stage1 <- select_oldest_measure("cabdo_",stage1_mintime,stage1_maxtime)[[1]]
dat$anthro_waist_stage2 <- select_oldest_measure("cabdo_",stage2_mintime,stage2_maxtime)[[1]]
dat$anthro_waist_stage3 <- select_oldest_measure("cabdo_",stage3_mintime,stage3_maxtime)[[1]]
dat$anthro_waist_stage4 <- select_oldest_measure("cabdo_",stage4_mintime,stage4_maxtime)[[1]]
dat$anthro_weight_stage0 <- select_oldest_measure("cweight_",stagebirth_mintime,stagebirth_maxtime)[[1]]
dat$anthro_weight_stage1 <- select_oldest_measure("cweight_",stage1_mintime,stage1_maxtime)[[1]]
dat$anthro_weight_stage2 <- select_oldest_measure("cweight_",stage2_mintime,stage2_maxtime)[[1]]
dat$anthro_weight_stage3 <- select_oldest_measure("cweight_",stage3_mintime,stage3_maxtime)[[1]]
dat$anthro_weight_stage4 <- select_oldest_measure("cweight_",stage4_mintime,stage4_maxtime)[[1]]
dat$anthro_bmi_stage0_sds <- select_oldest_measure("czbmiuk90_",stagebirth_mintime,stagebirth_maxtime)[[1]]
dat$anthro_bmi_stage1_sds <- select_oldest_measure("czbmiuk90_",stage1_mintime,stage1_maxtime)[[1]]
dat$anthro_bmi_stage2_sds <- select_oldest_measure("czbmiuk90_",stage2_mintime,stage2_maxtime)[[1]]
dat$anthro_bmi_stage3_sds <- select_oldest_measure("czbmiuk90_",stage3_mintime,stage3_maxtime)[[1]]
dat$anthro_bmi_stage4_sds <- select_oldest_measure("czbmiuk90_",stage4_mintime,stage4_maxtime)[[1]]
#who categories of overweight and obesity
dat$anthro_overweightobese_stage0_binary <- NA
dat$anthro_overweightobese_stage0_binary[dat$anthro_bmi_stage0_sds>1] <-1
dat$anthro_overweightobese_stage0_binary[which(dat$anthro_bmi_stage0_sds>=(-2) &dat$anthro_bmi_stage0_sds<=1)] <-0
dat$anthro_obese_stage0_binary <- NA
dat$anthro_obese_stage0_binary[which(dat$anthro_bmi_stage0_sds>2)] <-1
dat$anthro_obese_stage0_binary[which(dat$anthro_bmi_stage0_sds<=1 &dat$anthro_bmi_stage0_sds>=(-2))] <-0
dat$anthro_overweightobese_stage1_binary <- NA
dat$anthro_overweightobese_stage1_binary[dat$anthro_bmi_stage1_sds>1] <-1
dat$anthro_overweightobese_stage1_binary[which(dat$anthro_bmi_stage1_sds>=(-2) &dat$anthro_bmi_stage1_sds<=1)] <-0
dat$anthro_obese_stage1_binary <- NA
dat$anthro_obese_stage1_binary[which(dat$anthro_bmi_stage1_sds>2)] <-1
dat$anthro_obese_stage1_binary[which(dat$anthro_bmi_stage1_sds<=1 &dat$anthro_bmi_stage1_sds>=(-2))] <-0
dat$anthro_overweightobese_stage2_binary <- NA
dat$anthro_overweightobese_stage2_binary[dat$anthro_bmi_stage2_sds>1] <-1
dat$anthro_overweightobese_stage2_binary[which(dat$anthro_bmi_stage2_sds>=(-2) &dat$anthro_bmi_stage2_sds<=1)] <-0
dat$anthro_obese_stage2_binary <- NA
dat$anthro_obese_stage2_binary[which(dat$anthro_bmi_stage2_sds>2)] <-1
dat$anthro_obese_stage2_binary[which(dat$anthro_bmi_stage2_sds<=1 &dat$anthro_bmi_stage2_sds>=(-2))] <-0
dat$anthro_overweightobese_stage3_binary <- NA
dat$anthro_overweightobese_stage3_binary[dat$anthro_bmi_stage3_sds>1] <-1
dat$anthro_overweightobese_stage3_binary[which(dat$anthro_bmi_stage3_sds>=(-2) &dat$anthro_bmi_stage3_sds<=1)] <-0
dat$anthro_obese_stage3_binary <- NA
dat$anthro_obese_stage3_binary[which(dat$anthro_bmi_stage3_sds>2)] <-1
dat$anthro_obese_stage3_binary[which(dat$anthro_bmi_stage3_sds<=1 &dat$anthro_bmi_stage3_sds>=(-2))] <-0
dat$anthro_overweightobese_stage4_binary <- NA
dat$anthro_overweightobese_stage4_binary[dat$anthro_bmi_stage4_sds>1] <-1
dat$anthro_overweightobese_stage4_binary[which(dat$anthro_bmi_stage4_sds>=(-2) &dat$anthro_bmi_stage4_sds<=1)] <-0
dat$anthro_obese_stage4_binary <- NA
dat$anthro_obese_stage4_binary[which(dat$anthro_bmi_stage4_sds>2)] <-1
dat$anthro_obese_stage4_binary[which(dat$anthro_bmi_stage4_sds<=1 &dat$anthro_bmi_stage4_sds>=(-2))] <-0
#fatmass index and fat mass %
dat$anthro_fmi_stage3 <- select_oldest_measure("fatm_",stage3_mintime,stage3_maxtime)[[1]]
dat$anthro_fmi_stage3 <- dat$anthro_fmi_stage3 / ((dat$anthro_height_stage3/100)^2)
dat$anthro_fmi_stage4 <- select_oldest_measure("fatm_",stage4_mintime,stage4_maxtime)[[1]]
dat$anthro_fmi_stage4 <- dat$anthro_fmi_stage4 / ((dat$anthro_height_stage4/100)^2)
dat$anthro_fatpc_stage3 <- select_oldest_measure("fatp_",stage3_mintime,stage3_maxtime)[[1]]
dat$anthro_fatpc_stage4 <- select_oldest_measure("fatp_",stage4_mintime,stage4_maxtime)[[1]]
#zscores
dat$anthro_waist_stage0_zscore <- scale(dat$anthro_waist_stage0)
dat$anthro_weight_stage0_zscore <- scale(dat$anthro_weight_stage0)
dat$anthro_height_stage0_zscore <- scale(dat$anthro_height_stage0)
dat$anthro_waist_stage1_zscore <- scale(dat$anthro_waist_stage1)
dat$anthro_weight_stage1_zscore <- scale(dat$anthro_weight_stage1)
dat$anthro_height_stage1_zscore <- scale(dat$anthro_height_stage1)
dat$anthro_waist_stage2_zscore <- scale(dat$anthro_waist_stage2)
dat$anthro_weight_stage2_zscore <- scale(dat$anthro_weight_stage2)
dat$anthro_height_stage2_zscore <- scale(dat$anthro_height_stage2)
dat$anthro_waist_stage3_zscore <- scale(dat$anthro_waist_stage3)
dat$anthro_weight_stage3_zscore <- scale(dat$anthro_weight_stage3)
dat$anthro_height_stage3_zscore <- scale(dat$anthro_height_stage3)
dat$anthro_waist_stage4_zscore <- scale(dat$anthro_waist_stage4)
dat$anthro_weight_stage4_zscore <- scale(dat$anthro_weight_stage4)
dat$anthro_height_stage4_zscore <- scale(dat$anthro_height_stage4)
dat$anthro_fmi_stage3_zscore <- scale(dat$anthro_fmi_stage3)
dat$anthro_fmi_stage4_zscore <- scale(dat$anthro_fmi_stage4)
dat$anthro_fatpc_stage3_zscore <- scale(dat$anthro_fatpc_stage3)
dat$anthro_fatpc_stage4_zscore <- scale(dat$anthro_fatpc_stage4)

# Immuno outcomes
dat$immuno_allergy_food_allstages_binary <- NA
dat$immuno_allergy_food_allstages_binary[raw_dat$guadtChildGenHealth%in%(1:5)] <-0
dat$immuno_allergy_food_allstages_binary[raw_dat$guadtChildConditions_4==1] <-1

dat$immuno_allergy_pollen_allstages_binary <- NA
dat$immuno_allergy_pollen_allstages_binary[raw_dat$guadtHayfeverEver==1] <-0
dat$immuno_allergy_pollen_allstages_binary[raw_dat$guadtHayfeverEver==2] <-1

dat$immuno_eczema_allstages_binary <- NA
dat$immuno_eczema_allstages_binary[raw_dat$guadtEczemaEver==1] <-0
dat$immuno_eczema_allstages_binary[raw_dat$guadtEczemaEver==2] <-1

dat$immuno_asthma_allstages_binary <- NA
dat$immuno_asthma_allstages_binary[raw_dat$guadtEverHadAsthma==1] <-0
dat$immuno_asthma_allstages_binary[raw_dat$guadtEverHadAsthma==2] <-1

dat$immuno_wheeze_allstages_binary <- NA
dat$immuno_wheeze_allstages_binary[raw_dat$guadtChildWheezing==1] <-0
dat$immuno_wheeze_allstages_binary[raw_dat$guadtChildWheezing==2] <-1

# cardiometabolic
dat$cardiomet_trig_stage0 <- raw_dat$cbldtrig
dat$cardiomet_trig_stage3 <- select_oldest_measure("triglycerides_",stage3_mintime,stage3_maxtime)[[1]]
dat$cardiomet_stage3_bloodtesttimepoint <- select_oldest_measure("triglycerides_",stage3_mintime,stage3_maxtime)[[2]]
dat$cardiomet_trig_stage4 <- select_oldest_measure("triglycerides_",stage4_mintime,stage4_maxtime)[[1]]
dat$cardiomet_stage4_bloodtesttimepoint <- select_oldest_measure("triglycerides_",stage4_mintime,stage4_maxtime)[[2]]
dat$cardiomet_trig_stage0_zscore <- scale(dat$cardiomet_trig_stage0)
dat$cardiomet_trig_stage3_zscore <- scale(dat$cardiomet_trig_stage3)
dat$cardiomet_trig_stage4_zscore <- scale(dat$cardiomet_trig_stage4)

dat$cardiomet_chol_stage0 <- raw_dat$cbldchol
dat$cardiomet_CRP_stage0 <- raw_dat$cbldcrp
dat$cardiomet_HDL_stage0 <- raw_dat$cbldhdl
dat$cardiomet_LDL_stage0 <- raw_dat$cbldldl
dat$cardiomet_insulin_stage0 <- raw_dat$cbldinsulin

dat$cardiomet_chol_stage0_zscore <- scale(dat$cardiomet_chol_stage0)
dat$cardiomet_CRP_stage0_zscore <- scale(dat$cardiomet_CRP_stage0)
dat$cardiomet_HDL_stage0_zscore <- scale(dat$cardiomet_HDL_stage0)
dat$cardiomet_LDL_stage0_zscore <- scale(dat$cardiomet_LDL_stage0)
dat$cardiomet_insulin_stage0_zscore <- scale(dat$cardiomet_insulin_stage0)

dat$cardiomet_chol_stage3 <- select_oldest_measure("cholesterol_",stage3_mintime,stage3_maxtime)[[1]]
dat$cardiomet_chol_stage4 <- select_oldest_measure("cholesterol_",stage4_mintime,stage4_maxtime)[[1]]
dat$cardiomet_chol_stage3_zscore <- scale(dat$cardiomet_chol_stage3)
dat$cardiomet_chol_stage4_zscore <- scale(dat$cardiomet_chol_stage4)

dat$cardiomet_HDL_stage3 <- select_oldest_measure("hdl_",stage3_mintime,stage3_maxtime)[[1]]
dat$cardiomet_HDL_stage4 <- select_oldest_measure("hdl_",stage4_mintime,stage4_maxtime)[[1]]
dat$cardiomet_HDL_stage3_zscore <- scale(dat$cardiomet_HDL_stage3)
dat$cardiomet_HDL_stage4_zscore <- scale(dat$cardiomet_HDL_stage4)

dat$cardiomet_LDL_stage3 <- select_oldest_measure("ldl_",stage3_mintime,stage3_maxtime)[[1]]
dat$cardiomet_LDL_stage4 <- select_oldest_measure("ldl_",stage4_mintime,stage4_maxtime)[[1]]
dat$cardiomet_LDL_stage3_zscore <- scale(dat$cardiomet_LDL_stage3)
dat$cardiomet_LDL_stage4_zscore <- scale(dat$cardiomet_LDL_stage4)

dat$cardiomet_sbp_stage3 <- select_oldest_measure("systolic_",stage3_mintime,stage3_maxtime)[[1]]
dat$cardiomet_stage3_bptimepoint <- select_oldest_measure("systolic_",stage3_mintime,stage3_maxtime)[[2]]
dat$cardiomet_sbp_stage4 <- select_oldest_measure("systolic_",stage4_mintime,stage4_maxtime)[[1]]
dat$cardiomet_stage4_bptimepoint <- select_oldest_measure("systolic_",stage4_mintime,stage4_maxtime)[[2]]
dat$cardiomet_dbp_stage3 <- select_oldest_measure("diastolic_",stage3_mintime,stage3_maxtime)[[1]]
dat$cardiomet_dbp_stage4 <- select_oldest_measure("diastolic_",stage4_mintime,stage4_maxtime)[[1]]
dat$cardiomet_sbp_stage3_zscore <- scale(dat$cardiomet_sbp_stage3)
dat$cardiomet_sbp_stage4_zscore <- scale(dat$cardiomet_sbp_stage4)
dat$cardiomet_dbp_stage3_zscore <- scale(dat$cardiomet_dbp_stage3)
dat$cardiomet_dbp_stage4_zscore <- scale(dat$cardiomet_dbp_stage4)

# SMOKING #
#Any time up to birth: ever vs never smoker: binary variable 
dat$smoking_mother_ever_life_binary<-NA
dat$smoking_mother_ever_life_binary[which(raw_dat$smk0nowsmk==2 | raw_dat$smk0regsmk==4)]<-0
dat$smoking_mother_ever_life_binary[which(raw_dat$smk0nowsmk==1 | raw_dat$smk0regsmk%in%c(1,2,3))]<-1
#Early-onset: Smoking before age 11 vs no smoking before age 11
dat$smoking_mother_before11_binary<-NA
dat$smoking_mother_before11_binary[raw_dat$smk0agestr<=11]<-1
dat$smoking_mother_before11_binary[raw_dat$smk0agestr>11]<-0
#Pre-conception: Any vs no smoking in the three months prior to pregnancy
dat$smoking_mother_preconception_binary<-NA
dat$smoking_mother_preconception_binary[raw_dat$smk03mthb4==1 | raw_dat$smk0regsmk==4]<-0
dat$smoking_mother_preconception_binary[raw_dat$smk03mthb4%in%c(2,3,4,5)]<-1
#Pre-conception: Number of cigarettes per day in the three months prior to pregnancy (ordered categorical)
dat$smoking_mother_preconception_ordinal<-NA
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4==1| raw_dat$smk0regsmk==4]<-"None"
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4%in%c(2,3)]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4==4]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4==5]<-"Heavy" #i.e. >20
dat$smoking_mother_preconception_ordinal<-factor(dat$smoking_mother_preconception_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of cigarettes per day in the first trimester (ordered categorical)
dat$smoking_mother_firsttrim_ordinal<-NA
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth==1| raw_dat$smk0regsmk==4]<-"None"
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth%in%c(2,3)]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth==4]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth==5]<-"Heavy" #i.e. >20
dat$smoking_mother_firsttrim_ordinal<-factor(dat$smoking_mother_firsttrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking in the first trimester (up to end of 12 weeks)
dat$smoking_mother_firsttrim_binary <- NA
dat$smoking_mother_firsttrim_binary[raw_dat$smk0fr3mth==1| raw_dat$smk0regsmk==4]<-0
dat$smoking_mother_firsttrim_binary[raw_dat$smk0fr3mth%in%c(2,3,4,5)]<-1
#Pregnancy: Any smoking vs no smoking in the second trimester
#(The second are third timester variables are identical, due to how the question was asked "since 4th month of pregnancy")
dat$smoking_mother_secondtrim_binary<-NA
dat$smoking_mother_secondtrim_binary[raw_dat$smk04thmth==1| raw_dat$smk0regsmk==4]<-0
dat$smoking_mother_secondtrim_binary[raw_dat$smk04thmth%in%c(2,3,4,5)]<-1
#Pregnancy: Any smoking vs no smoking in the third trimester
#(The second are third timester variables are identical, due to how the question was asked "since 4th month of pregnancy")
dat$smoking_mother_thirdtrim_binary<-NA
dat$smoking_mother_thirdtrim_binary[raw_dat$smk04thmth==1| raw_dat$smk0regsmk==4]<-0
dat$smoking_mother_thirdtrim_binary[raw_dat$smk04thmth%in%c(2,3,4,5)]<-1
#Pregnancy: Number of cigarettes per day in second trimester (ordered categorical)
#(The second are third timester variables are identical, due to how th equestion was asked "since 4th month of pregnancy")
dat$smoking_mother_secondtrim_ordinal<-NA
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth==1| raw_dat$smk0regsmk==4]<-"None"
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth%in%c(2,3)]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth==4]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth==5]<-"Heavy" #i.e. >20
dat$smoking_mother_secondtrim_ordinal<-factor(dat$smoking_mother_secondtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of cigarettes per day since in third trimester (ordered categorical)
#(The second are third timester variables are identical, due to how th equestion was asked "since 4th month of pregnancy")
dat$smoking_mother_thirdtrim_ordinal<-NA
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth==1| raw_dat$smk0regsmk==4]<-"None"
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth%in%c(2,3)]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth==4]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth==5]<-"Heavy" #i.e. >20
dat$smoking_mother_thirdtrim_ordinal<-factor(dat$smoking_mother_thirdtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking at any time during pregnancy
dat$smoking_mother_ever_pregnancy_binary<-NA
dat$smoking_mother_ever_pregnancy_binary[raw_dat$smk0smkprg==1]<-1
dat$smoking_mother_ever_pregnancy_binary[raw_dat$smk0smkprg==2]<-0
#Passive smoke during pregnancy: binary variable
dat$smoking_mother_passive_binary<-NA
dat$smoking_mother_passive_binary[raw_dat$smk0expcig%in%c(1,3)]<-1
dat$smoking_mother_passive_binary[raw_dat$smk0expcig==2]<-0
#PATERNAL SMOKING
#Any smoking vs no smoking in the third trimester 
dat$smoking_father_thirdtrim_binary<-NA
dat$smoking_father_thirdtrim_binary[raw_dat$fbqsmokes==2]<-0
dat$smoking_father_thirdtrim_binary[raw_dat$fbqsmokes==1]<-1
#Pregnancy: Number of cigarettes per day in third trimester (ordered categorical)
dat$smoking_father_thirdtrim_ordinal<-NA
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokes==2]<-"None"
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokesamt%in%c(1,2,3)]<-"Light" #i.e. <=10 but not 0
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokesamt==4]<-"Moderate" #i.e. >10, <=20
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokesamt==5]<- "Heavy" #i.e. >20
dat$smoking_father_thirdtrim_ordinal<-factor(dat$smoking_father_thirdtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking at any time during pregnancy
#(This is identical to the smoking_father_thirdtrim_binary question)
dat$smoking_father_ever_pregnancy_binary<-NA
dat$smoking_father_ever_pregnancy_binary[raw_dat$fbqsmokes==2]<-0
dat$smoking_father_ever_pregnancy_binary[raw_dat$fbqsmokes==1]<-1

# ALCOHOL
# Maternal
#Drank alcohol 3 months before pregnancy (binary)
dat$alcohol_mother_preconception_binary<-NA
dat$alcohol_mother_preconception_binary[raw_dat$alc0dr3mb4==4]<-0
dat$alcohol_mother_preconception_binary[raw_dat$alc0dr3mb4%in%c(1,2,3)]<-1

#average units beer per week 3 months before pregnancy
raw_dat$alcohol_mother_beer_pw_preconception_cont<-raw_dat$alc0brav3b 
#average units other per week 3 months before pregnancy
raw_dat$alcohol_mother_other_pw_preconception_cont<-raw_dat$alc0oaav3b
#average units spirits per week 3 months before pregnancy
raw_dat$alcohol_mother_spirit_pw_preconception_cont<-raw_dat$alc0spav3b
#average units wine per week 3 months before pregnancy
raw_dat$alcohol_mother_wine_pw_preconception_cont<-raw_dat$alc0wnav3b
#total average units per week 3 months before pregnancy
raw_dat$alcohol_mother_preconception_continuous<-rowSums(raw_dat[,c("alcohol_mother_beer_pw_preconception_cont","alcohol_mother_other_pw_preconception_cont","alcohol_mother_spirit_pw_preconception_cont","alcohol_mother_wine_pw_preconception_cont")],na.rm=TRUE)
raw_dat$alcohol_mother_preconception_continuous[apply(raw_dat[,c("alcohol_mother_beer_pw_preconception_cont","alcohol_mother_other_pw_preconception_cont","alcohol_mother_spirit_pw_preconception_cont","alcohol_mother_wine_pw_preconception_cont")],1,function(x)all(is.na(x)))]<-NA

## To align with ALSPAC's coding, 1 glass of drink taken as 2 units (average)   
# Number of units per day in preconception (ordered categorical)
dat$alcohol_mother_preconception_ordinal <-NA
dat$alcohol_mother_preconception_ordinal[raw_dat$alcohol_mother_preconception_continuous==0|dat$alcohol_mother_preconception_binary==0]<-"None"
dat$alcohol_mother_preconception_ordinal[raw_dat$alcohol_mother_preconception_continuous>0 & raw_dat$alcohol_mother_preconception_continuous <=2]<-"Light" #<1 glass per week (<2 units)
dat$alcohol_mother_preconception_ordinal[raw_dat$alcohol_mother_preconception_continuous >2 & raw_dat$alcohol_mother_preconception_continuous <=13]<-"Moderate" #1+glasses pwk, but not daily (<13 units)
dat$alcohol_mother_preconception_ordinal[raw_dat$alcohol_mother_preconception_continuous >13]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd (>13 units)
dat$alcohol_mother_preconception_ordinal<-factor(dat$alcohol_mother_preconception_ordinal, levels=c("None", "Light","Moderate","Heavy"), ordered=T)
#Drank alcohol in first trimester (binary)
# Asked as first three months of pregnancy 
dat$alcohol_mother_firsttrim_binary<-NA
dat$alcohol_mother_firsttrim_binary[raw_dat$alc0drfr3m==4]<-0
dat$alcohol_mother_firsttrim_binary[raw_dat$alc0drfr3m%in%c(1,2,3)]<-1
#average units beer first trimester
raw_dat$alcohol_mother_beer_firsttrim<-raw_dat$alc0bravf3
#average units other first trimester
raw_dat$alcohol_mother_other_firsttrim<-raw_dat$alc0oaavf3
#average units spirits first  trimester
raw_dat$alcohol_mother_spirits_firsttrim<-raw_dat$alc0spavf3
#average units wine first 3  trimester
raw_dat$alcohol_mother_wine_firsttrim<-raw_dat$alc0wnavf3
#total average units per week/day in first trimester
raw_dat$alcohol_mother_firsttrim_continuous<-rowSums(raw_dat[,c("alcohol_mother_beer_firsttrim","alcohol_mother_other_firsttrim","alcohol_mother_spirits_firsttrim","alcohol_mother_wine_firsttrim")],na.rm=TRUE)
raw_dat$alcohol_mother_firsttrim_continuous[apply(raw_dat[,c("alcohol_mother_beer_firsttrim","alcohol_mother_other_firsttrim","alcohol_mother_spirits_firsttrim","alcohol_mother_wine_firsttrim")],1,function(x)all(is.na(x)))]<-NA
# Number of units per week in the first trimester (ordered categorical)
## To align with ALSPAC's coding, 1 glass of drink taken as 2 units (average)   
dat$alcohol_mother_firsttrim_ordinal <-NA
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous==0|dat$alcohol_mother_firsttrim_binary==0]<-"None"
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous>0 & raw_dat$alcohol_mother_firsttrim_continuous <=2]<-"Light" #<1 glass per week
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous >2 & raw_dat$alcohol_mother_firsttrim_continuous <=13]<-"Moderate" #1+glasses pwk, but not daily (12 units)
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous >13]<-"Heavy" #daily drinking
dat$alcohol_mother_firsttrim_ordinal<-factor(dat$alcohol_mother_firsttrim_ordinal, levels=c("None", "Light","Moderate","Heavy"), ordered=T)
#drank alcohol in second trimester (binary)
#(The second are third timester variables are identical, due to how the question was asked "since 4th month of pregnancy")
dat$alcohol_mother_secondtrim_binary<-NA
dat$alcohol_mother_secondtrim_binary[raw_dat$alc0dr4thm==4]<-0
dat$alcohol_mother_secondtrim_binary[raw_dat$alc0dr4thm%in%c(1,2,3)]<-1
#average units beer since 4th month of pregnancy
raw_dat$alcohol_mother_beer_pw_since4thmonth_cont<-raw_dat$alc0brav4m
#average units other since 4th m
raw_dat$alcohol_mother_other_pw_since4thmonth_cont<-raw_dat$alc0oaav4m
#average units spirits since 4th m
raw_dat$alcohol_mother_spirits_pw_since4thmonth_cont<-raw_dat$alc0spav4m
#average units wine since 4th m
raw_dat$alcohol_mother_wine_pw_since4thmonth_cont<-raw_dat$alc0wnav4m
#total average units per week/day since fourth month of pregnancy
raw_dat$alcohol_mother_pw_since4thmonth_cont<-rowSums(raw_dat[,c("alcohol_mother_beer_pw_since4thmonth_cont","alcohol_mother_other_pw_since4thmonth_cont","alcohol_mother_spirits_pw_since4thmonth_cont","alcohol_mother_wine_pw_since4thmonth_cont")],na.rm=TRUE)
raw_dat$alcohol_mother_pw_since4thmonth_cont[apply(raw_dat[,c("alcohol_mother_beer_pw_since4thmonth_cont","alcohol_mother_other_pw_since4thmonth_cont","alcohol_mother_spirits_pw_since4thmonth_cont","alcohol_mother_wine_pw_since4thmonth_cont")],1,function(x)all(is.na(x)))]<-NA
# Number of units per day in second trimester (ordered categorical)
## To align with ALSPAC's coding, 1 glass of drink taken as 2 units (average)   
dat$alcohol_mother_secondtrim_ordinal <-NA
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont==0|dat$alcohol_mother_secondtrim_binary==0]<-"None"
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont>0 & raw_dat$alcohol_mother_pw_since4thmonth_cont <=2]<-"Light" #<1 glass per week
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont >2 & raw_dat$alcohol_mother_pw_since4thmonth_cont <=13]<-"Moderate" #1+glasses pwk, but not daily (12 units)
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont >13]<-"Heavy" #daily drinking
dat$alcohol_mother_secondtrim_ordinal<-factor(dat$alcohol_mother_secondtrim_ordinal, levels=c("None", "Light","Moderate","Heavy"), ordered=T)
#NOTE: The second and third trimester variables are identical, due to how the question was asked "since 4th month of pregnancy"
dat$alcohol_mother_thirdtrim_ordinal <- dat$alcohol_mother_secondtrim_ordinal
dat$alcohol_mother_thirdtrim_binary <- dat$alcohol_mother_secondtrim_binary
#Binge drinking (5 or more on any one occasion) - 2nd and 3rd trim are the same
dat$alcohol_mother_binge1_binary <-NA
dat$alcohol_mother_binge1_binary[raw_dat$alc05ufr3m%in%c(1,2,3,4,5)]<-1
dat$alcohol_mother_binge1_binary[raw_dat$alc05ufr3m%in%c(6)|raw_dat$alc0drfr3m==4]<-0
dat$alcohol_mother_binge2_binary <-NA
dat$alcohol_mother_binge2_binary[raw_dat$alc05u4thm%in%c(1,2,3,4,5)]<-1
dat$alcohol_mother_binge2_binary[raw_dat$alc05u4thm%in%c(6)|raw_dat$alc0dr4thm==4]<-0
dat$alcohol_mother_binge3_binary <- dat$alcohol_mother_binge2_binary
dat$alcohol_mother_bingepreg_binary <- NA
dat$alcohol_mother_bingepreg_binary[dat$alcohol_mother_binge1_binary==0 & dat$alcohol_mother_binge2_binary==0] <-0
dat$alcohol_mother_bingepreg_binary[dat$alcohol_mother_binge1_binary==1 | dat$alcohol_mother_binge2_binary==1] <-1
#Any time in pregnancy
dat$alcohol_mother_ever_pregnancy_binary<-NA
dat$alcohol_mother_ever_pregnancy_binary[dat$alcohol_mother_firsttrim_binary==0 &dat$alcohol_mother_secondtrim_binary==0 & dat$alcohol_mother_thirdtrim_binary == 0] <-0
dat$alcohol_mother_ever_pregnancy_binary[dat$alcohol_mother_firsttrim_binary==1 |dat$alcohol_mother_secondtrim_binary ==1 |dat$alcohol_mother_thirdtrim_binary ==1] <-1
#PATERNAL DRINKING
#Any drinking vs no drinking at any time during pregnancy
#To note, the question asked was 'do you drink alcohol', this therefore could have been answered for pre-pregnancy drinking.
dat$alcohol_father_ever_pregnancy_binary<-NA
dat$alcohol_father_ever_pregnancy_binary[raw_dat$fbqalcohol==2]<-0
dat$alcohol_father_ever_pregnancy_binary[raw_dat$fbqalcohol==1]<-1
#Number of units in third trimester per week (continuous)
raw_dat$alcohol_father_amt_preg_cont<-raw_dat$fbqalcoholamt
#Number of units per day in the third trimester (ordered categorical)
dat$alcohol_father_thirdtrim_ordinal <-NA
dat$alcohol_father_thirdtrim_ordinal[raw_dat$alcohol_father_amt_preg_cont==0|raw_dat$fbqalcohol=="No"]<-"None"
dat$alcohol_father_thirdtrim_ordinal[raw_dat$alcohol_father_amt_preg_cont>0 & raw_dat$alcohol_father_amt_preg_cont <=2]<-"Light" #<1 glass per week
dat$alcohol_father_thirdtrim_ordinal[raw_dat$alcohol_father_amt_preg_cont >2 & raw_dat$alcohol_father_amt_preg_cont <=13]<-"Moderate" #1+glasses pwk, but not daily (12 units)
dat$alcohol_father_thirdtrim_ordinal[raw_dat$alcohol_father_amt_preg_cont >13]<-"Heavy" #daily drinking
dat$alcohol_father_thirdtrim_ordinal<-factor(dat$alcohol_father_thirdtrim_ordinal, levels=c("None", "Light","Moderate","Heavy"), ordered=T)
#Any alcohol Vs none in third trimester
dat$alcohol_father_thirdtrim_binary<-dat$alcohol_father_ever_pregnancy_binary

# CAFFEINE
# filter
raw_dat$caffeine_mother_coffee_filter_thirdtrim_continuous<-raw_dat$cdr0dccfpd
# cups of coffee multiplied by 57 (mg caffeine in 1 cup of cofee)
raw_dat$caffeine_mother_coffee_filter_thirdtrim_continuous<-raw_dat$caffeine_mother_coffee_filter_thirdtrim_continuous *57 #tranform cups to mg per day
# instant
raw_dat$caffeine_mother_coffee_instant_thirdtrim_continuous<-raw_dat$cdr0iccfpd
# cups of coffee multiplied by 57 (mg caffeine in 1 cup of cofee)
raw_dat$caffeine_mother_coffee_instant_thirdtrim_continuous<-raw_dat$caffeine_mother_coffee_instant_thirdtrim_continuous *57 #tranform cups to mg per day
# total coffee
dat$caffeine_mother_coffee_thirdtrim_continuous<-NA
dat$caffeine_mother_coffee_thirdtrim_continuous<- rowSums(raw_dat[,c("caffeine_mother_coffee_filter_thirdtrim_continuous","caffeine_mother_coffee_instant_thirdtrim_continuous")],na.rm=TRUE)
dat$dat$caffeine_mother_coffee_thirdtrim_continuous[apply(raw_dat[,c("caffeine_mother_coffee_instant_thirdtrim_continuous","caffeine_mother_coffee_filter_thirdtrim_continuous")],1,function(x)all(is.na(x)))]<-NA
# Cups of caffeinated tea per day, mg/pd
dat$caffeine_mother_tea_thirdtrim_continuous<-raw_dat$cdr0tecfpd
# cups of tea multiplied by 27 (mg caffeine in 1 cup tea)
dat$caffeine_mother_tea_thirdtrim_continuous<-dat$caffeine_mother_tea_thirdtrim_continuous*27 #tranform cups to mg per day
#Cups of caffeinated cola per day (notdiet)
raw_dat$caffeine_mother_cola_notdiet_thirdtrim_continuous<-raw_dat$cdr0clcfpd
# cups of coffee multiplied by 20 (mg caffeine in 1 cup of cola)
raw_dat$caffeine_mother_cola_notdiet_thirdtrim_continuous<-raw_dat$caffeine_mother_cola_notdiet_thirdtrim_continuous*20 #tranform cups to mg per day
# Cups of caffeinated cola mg/pd (diet)
raw_dat$caffeine_mother_cola_diet_preg_continuous<-raw_dat$cdr0dccfpd
# cups of coffee multiplied by 20 (mg caffeine in 1 cup of cola)
raw_dat$caffeine_mother_cola_diet_preg_continuous<-raw_dat$caffeine_mother_cola_diet_preg_continuous*20 #tranform cups to mg per day
# Total cups caffeinated cola mg/pd (diet and non-diet)
dat$caffeine_mother_cola_thirdtrim_continuous<- rowSums(raw_dat[,c("caffeine_mother_cola_notdiet_thirdtrim_continuous","caffeine_mother_cola_diet_preg_continuous")],na.rm=TRUE)
dat$caffeine_mother_cola_thirdtrim_continuous[apply(raw_dat[,c("caffeine_mother_cola_notdiet_thirdtrim_continuous","caffeine_mother_cola_diet_preg_continuous")],1,function(x)all(is.na(x)))]<-NA
# Total caffeine per day in third trimester mg/day (continuous)
dat$caffeine_mother_total_thirdtrim_continuous<-rowSums(dat[,c("caffeine_mother_coffee_thirdtrim_continuous","caffeine_mother_tea_thirdtrim_continuous","caffeine_mother_cola_thirdtrim_continuous")],na.rm=TRUE)
dat$caffeine_mother_total_thirdtrim_continuous[apply(dat[,c("caffeine_mother_coffee_thirdtrim_continuous","caffeine_mother_tea_thirdtrim_continuous","caffeine_mother_cola_thirdtrim_continuous")],1,function(x)all(is.na(x)))]<-NA
# Average caffeine mg/pd in pregnancy (continuous)
# This is a duplicated variable of 'caffeine_mother_tea_thirdtrim_continuous', as we only have data for the third trimester
dat$caffeine_mother_total_ever_pregnancy_continuous<-dat$caffeine_mother_total_thirdtrim_continuous
# Any caffeine Vs none in third trimester
dat$caffeine_mother_total_thirdtrim_binary<- NA
dat$caffeine_mother_total_thirdtrim_binary[dat$caffeine_mother_total_thirdtrim_continuous==0]<-0
dat$caffeine_mother_total_thirdtrim_binary[dat$caffeine_mother_total_thirdtrim_continuous>0]<-1
# Pregnancy: Any caffeine vs no caffeine in pregnancy
# Duplicate variable of 'caffeine_mother_total_thirdtrim_binary', as only have data for third trimester
dat$caffeine_mother_total_ever_pregnancy_binary <- dat$caffeine_mother_total_thirdtrim_binary
#Ordinal variables**
dat$caffeine_mother_total_thirdtrim_ordinal <- cut(dat$caffeine_mother_total_thirdtrim_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
dat$caffeine_mother_total_ever_pregnancy_ordinal <- cut(dat$caffeine_mother_total_ever_pregnancy_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)

##### GENETIC DATA
source("~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/data_prep/cohorts/bib/gen_genetic_data.r")
genetic_data <- gen_genetic_data()
dat <- left_join(dat,genetic_data[[1]][,grep("childpc|BiBPersonID|prs",colnames(genetic_data[[1]]))],by=c("epoch_child_id"="BiBPersonID"))
dat <- left_join(dat,genetic_data[[2]][,grep("mumpc|BiBPersonID|prs",colnames(genetic_data[[2]]))],by=c("BiBMotherID"="BiBPersonID"))


# save dat

saveRDS(dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_pheno.rds")


