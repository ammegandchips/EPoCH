######################################################################
## Code to create alspac_pheno.rds                                  ##
## This code cleans and derives variables from alspac_pheno_raw.rds ##
######################################################################

library(tidyverse)
library(haven)
raw_dat <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno_raw.rds")

dat <- haven::zap_labels(raw_dat)
  
##### ADMIN VARIABLES

#time at which parents completed questionnaires
dat$time_qA_mother_gestation<-dat$a902
dat$time_qA_mother_gestation[dat$time_qA_mother_gestation<0] <- NA
dat$time_qB_mother_gestation<-dat$b924
dat$time_qB_mother_gestation[dat$time_qB_mother_gestation<0] <- NA
dat$time_qC_mother_gestation<-dat$c991
dat$time_qC_mother_gestation[dat$time_qC_mother_gestation<0] <- NA
dat$time_qD_mother_gestation<-dat$d990
dat$time_qD_mother_gestation[dat$time_qD_mother_gestation<0] <- NA
dat$time_qPA_partner_gestation<-dat$pa900
dat$time_qPA_partner_gestation[dat$time_qPA_partner_gestation<0] <- NA
dat$time_qPB_partner_gestation<-dat$pb900
dat$time_qPB_partner_gestation[dat$time_qPB_partner_gestation<0] <- NA
dat$time_qE_mother_sincebirth<-dat$e699
dat$time_qE_mother_sincebirth[dat$time_qE_mother_sincebirth<0] <- NA
dat$time_qPA_partner_sincebirth<-dat$pa901
dat$time_qPA_partner_sincebirth[dat$time_qPA_partner_sincebirth<0] <- NA
dat$time_qPB_partner_sincebirth<-dat$pa901
dat$time_qPB_partner_sincebirth[dat$time_qPB_partner_sincebirth<0] <- NA
#paternal participation
A<-read_dta("/Volumes/ALSPAC-Data/Current/Quest/Partner/pa_4a.dta")
B<-read_dta("/Volumes/ALSPAC-Data/Current/Quest/Partner/pb_4b.dta")
C<-read_dta("/Volumes/ALSPAC-Data/Current/Quest/Partner/pc_3a.dta")
dat$paternal_participation <- ifelse(dat$aln %in% unique(c(A$aln,B$aln,C$aln)),1,0)
rm(A,B,C)

##### COVARIATES

#sex
dat$covs_sex <- NA
dat$covs_sex[dat$kz021==2]<-"female" #Female
dat$covs_sex[dat$kz021==1]<-"male" #Male
#neonatal measurements age in days
dat$covs_age_birthmeasures_days <- dat$kz028
dat$covs_age_birthmeasures_days[dat$covs_age_birthmeasures_days<0]<-NA
#mother's age at conception (note that to preserve confidentiality these data have been effectively winsorised)
dat$covs_age_mother_conception <- dat$mz028a
dat$covs_age_mother_conception[dat$covs_age_mother_conception<0]<-NA
#mother's age at delivery (note that to preserve confidentiality these data have been effectively winsorised)
dat$covs_age_mother_delivery <- dat$mz028b
dat$covs_age_mother_delivery[dat$covs_age_mother_delivery<0]<-NA
#paternity status
dat$covs_biological_father<-dat$a521
dat$covs_biological_father[dat$covs_biological_father==1]<-"bio_dad"
dat$covs_biological_father[dat$covs_biological_father==(-2)]<-"no_partner"
dat$covs_biological_father[dat$covs_biological_father==(-1)]<-"missing"
dat$covs_biological_father[dat$covs_biological_father==(2)]<-"not_bio_dad"
dat$covs_biological_father[dat$covs_biological_father==(3)]<-"unsure"
#cohabitation
dat$covs_partner_lives_with_mother_prenatal<-NA
dat$covs_partner_lives_with_mother_prenatal[dat$a522==1]<-1
dat$covs_partner_lives_with_mother_prenatal[dat$a522==2]<-0
#Age at months at the 31m, 7y, 1, 9y, 0y clinics
dat$cf015[dat$cf015<0]<-NA
dat$cf014[dat$cf014<0]<-NA
dat$cf016[dat$cf016<0]<-NA
dat$cf017[dat$cf018<0]<-NA
dat$cf017[dat$cf018<0]<-NA
dat$cf015<-dat$cf015/4 #because age at CIF clinic is in weeks
dat$cf014<-dat$cf014/4 #because age at CIF clinic is in weeks
dat$cf016<-dat$cf016/4 #because age at CIF clinic is in weeks
dat$cf017<-dat$cf017/4 #because age at CIF clinic is in weeks
dat$cf018<-dat$cf018/4 #because age at CIF clinic is in weeks
dat$covs_age_child_stage3_f7 <- dat$f7003c
dat$covs_age_child_stage4_f9 <- dat$f9003c
  #some age timepoints for cif are generated below in the anthro section because they rely on knowing the stage1 and 2 timepoints
dat$covs_age_child_stage4_f10<-dat$fd003c
dat$covs_age_child_stage4_f10[dat$fd003c<0]<-NA
dat$covs_age_child_stage2_j<-dat$j914
dat$covs_age_child_stage2_j[dat$j914<0]<-NA
dat$covs_age_child_stage2_j <- dat$covs_age_child_stage2_j*12 #years to months
dat$covs_age_child_stage3_kq<-dat$kq998a
dat$covs_age_child_stage3_kq[dat$kq998a<0]<-NA
dat$covs_age_child_stage3_kr<-dat$kr991a
dat$covs_age_child_stage3_kr[dat$kr991a<0]<-NA
dat$covs_age_child_stage2_cif49<-dat$cf018
dat$covs_age_child_stage2_cif49[dat$cf018<0]<-NA
dat$covs_age_child_stage2_cif49<-dat$covs_age_child_stage2_cif49/12 #weeks to months
dat$covs_age_child_stage4_f8<-dat$f8003c
dat$covs_age_child_stage4_f8[dat$f8003c<0]<-NA
dat$covs_age_child_stage4_kq<-dat$ku991a
dat$covs_age_child_stage4_kq[dat$ku991a<0]<-NA
# Demographics
dat$covs_ethnicity_mother <- NA
dat$covs_ethnicity_mother[dat$c800==1]<-"white"
dat$covs_ethnicity_mother[dat$c800%in%c(2,3,4)]<-"black"
dat$covs_ethnicity_mother[dat$c800%in%c(5,6,7,8)]<-"asian"
dat$covs_ethnicity_mother[dat$c800%in%c(9)]<-"mixed or other"
dat$covs_ethnicity_mother_binary <- NA
dat$covs_ethnicity_mother_binary[dat$c800==1]<-"white"
dat$covs_ethnicity_mother_binary[dat$c800>1]<-"not white"
dat$covs_ethnicity_father <- NA
dat$covs_ethnicity_father[dat$c801==1]<-"white"
dat$covs_ethnicity_father[dat$c801%in%c(2,3,4)]<-"black"
dat$covs_ethnicity_father[dat$c801%in%c(5,6,7,8)]<-"asian"
dat$covs_ethnicity_father[dat$c801%in%c(9)]<-"mixed or other"
dat$covs_ethnicity_father_binary <- NA
dat$covs_ethnicity_father_binary[dat$c801==1]<-"white"
dat$covs_ethnicity_father_binary[dat$c801>1]<-"not white"
dat$covs_ethnicity_child_binary <- NA
dat$covs_ethnicity_child_binary[dat$c804==1]<-"white"
dat$covs_ethnicity_child_binary[dat$c804==2]<-"not white"
dat$covs_age_father_pregnancy <-dat$pa910
dat$covs_age_father_pregnancy[dat$covs_age_father_pregnancy<0]<-NA
dat$covs_edu_father <- NA
dat$covs_edu_father[dat$c666a==1]<-0 #CSE/none
dat$covs_edu_father[dat$c666a%in%c(2,3)]<-1 #O-level or vocational
dat$covs_edu_father[dat$c666a==4]<-2 #A-level
dat$covs_edu_father[dat$c666a==5]<-3 #Degree
dat$covs_edu_father_highestlowest_binary <- NA
dat$covs_edu_father_highestlowest_binary[dat$covs_edu_father==0] <- 0
dat$covs_edu_father_highestlowest_binary[dat$covs_edu_father==3] <- 1
dat$covs_edu_mother <- NA
dat$covs_edu_mother[dat$c645a==1]<-0 #CSE/none
dat$covs_edu_mother[dat$c645a%in%c(2,3)]<-1 #O-level or vocational
dat$covs_edu_mother[dat$c645a==4]<-2 #A-level
dat$covs_edu_mother[dat$c645a==5]<-3 #Degree
dat$covs_edu_mother_highestlowest_binary <- NA
dat$covs_edu_mother_highestlowest_binary[dat$covs_edu_mother==0] <- 0
dat$covs_edu_mother_highestlowest_binary[dat$covs_edu_mother==3] <- 1
dat$covs_occup_mother <- NA
dat$covs_occup_mother[dat$c755%in%c(1,2)]<-3 #professional or managerial/technica
dat$covs_occup_mother[dat$c755==3]<-2 #skilled non-manual
dat$covs_occup_mother[dat$c755==4]<-1 #skilled manual
dat$covs_occup_mother[dat$c755%in%c(5,6)]<-0 #semi-skilled or unskilled
dat$covs_occup_mother_highestlowest_binary <- NA
dat$covs_occup_mother_highestlowest_binary[dat$covs_occup_mother==0] <- 0
dat$covs_occup_mother_highestlowest_binary[dat$covs_occup_mother==3] <- 1
dat$covs_occup_father <- NA
dat$covs_occup_father[dat$c765%in%c(1,2)]<-3 #professional or managerial/technica
dat$covs_occup_father[dat$c765==3]<-2 #skilled non-manual
dat$covs_occup_father[dat$c765==4]<-1 #skilled manual
dat$covs_occup_father[dat$c765%in%c(5,6)]<-0 #semi-skilled or unskilled
dat$covs_occup_father_highestlowest_binary <- NA
dat$covs_occup_father_highestlowest_binary[dat$covs_occup_father==0] <- 0
dat$covs_occup_father_highestlowest_binary[dat$covs_occup_father==3] <- 1
dat$covs_parity_mother_binary <-NA
dat$covs_parity_mother_binary[dat$b032==0]<-0
dat$covs_parity_mother_binary[dat$b032>0]<-1
#Family relationships
dat$covs_married_mother_binary<-NA
dat$covs_married_mother_binary[dat$a525%in%c(1,2,3,4)]<-0
dat$covs_married_mother_binary[dat$a525%in%c(5,6)]<-1
dat$covs_married_father_binary<-NA
dat$covs_married_father_binary[dat$pa065%in%c(1,2,3,4)]<-0
dat$covs_married_father_binary[dat$pa065%in%c(5,6)]<-1
#Parents' health
dat$covs_asthma_father_binary <- NA
dat$covs_asthma_father_binary[dat$pa173a==2]<-0
dat$covs_asthma_father_binary[dat$pa173a==1]<-1
dat$covs_asthma_mother_binary <- NA
dat$covs_asthma_mother_binary[dat$d153a==2]<-0
dat$covs_asthma_mother_binary[dat$d153a==1]<-1
dat$covs_eczema_father_binary <- NA
dat$covs_eczema_father_binary[dat$pa174a==2]<-0
dat$covs_eczema_father_binary[dat$pa174a==1]<-1
dat$covs_eczema_mother_binary <- NA
dat$covs_eczema_mother_binary[dat$d154a==2]<-0
dat$covs_eczema_mother_binary[dat$d154a==1]<-1
dat$covs_allergy_father_binary <- NA
dat$covs_allergy_father_binary[dat$pa210==2]<-0
dat$covs_allergy_father_binary[dat$pa210==1]<-1
dat$covs_allergy_mother_binary <- NA
dat$covs_allergy_mother_binary[dat$d190==2]<-0
dat$covs_allergy_mother_binary[dat$d190==1]<-1
dat$covs_stressfulevents_mother <-dat$b613
dat$covs_stressfulevents_mother[dat$b613<0]<-NA
dat$covs_stressfulevents_mother_zscore <- scale(dat$covs_stressfulevents_mother)
dat$covs_stressfulevents_father <-dat$pb202
dat$covs_stressfulevents_father[dat$pb202<0]<-NA
dat$covs_stressfulevents_father_zscore <- scale(dat$covs_stressfulevents_father)
dat$covs_mother_depression_binary <- NA #severe depression
dat$covs_mother_depression_binary[dat$d171a==2]<-0
dat$covs_mother_depression_binary[dat$d171a==1]<-1
dat$covs_father_depression_binary <- NA
dat$covs_father_depression_binary[dat$pa191a==2]<-0
dat$covs_father_depression_binary[dat$pa191a==1]<-1
dat$covs_supplements_mother_binary <-NA
temp <- dat[,c("b140","b141","b142","b143","b144","b149")]
temp[temp==2]<-0
temp[temp<0]<-NA
temp1 <- rowSums(temp,na.rm = T)
temp1[apply(temp,1,function(x) all(is.na(x)))]<-NA
dat$covs_supplements_mother_binary[temp1==0]<-0
dat$covs_supplements_mother_binary[temp1>0]<-1
rm(temp,temp1)
  # took the earlier time point when supplements are more necessary
dat$covs_height_mother <-dat$dw021
dat$covs_weight_mother <-dat$dw002
dat$covs_height_mother[dat$dw021<1] <- NA
dat$covs_weight_mother[dat$dw002<1] <- NA
dat$covs_bmi_mother <- dat$covs_weight_mother/(dat$covs_height_mother/100)^2
dat$covs_bmi_mother_zscore <-scale(dat$covs_bmi_mother)
dat$covs_height_father <-dat$paw010
dat$covs_weight_father <-dat$paw002
dat$covs_height_father[dat$paw010<1] <- NA
dat$covs_weight_father[dat$paw002<1] <- NA
dat$covs_bmi_father <- dat$covs_weight_father/(dat$covs_height_father/100)^2
dat$covs_bmi_father_zscore <-scale(dat$covs_bmi_father)
#drugs not including cannabis, only 57 women
dat$covs_drugs_mother_binary <-NA
dat$covs_drugs_mother_binary[which(dat$b706==4|dat$b707==4|dat$b708==4|dat$b709==4|dat$b710==4|dat$b711==4|dat$b712==4|dat$b713==4)]<-0
dat$covs_drugs_mother_binary[which(dat$b706%in%c(1,2,3)|dat$b707%in%c(1,2,3)|dat$b708%in%c(1,2,3)|dat$b709%in%c(1,2,3)|dat$b710%in%c(1,2,3)|dat$b711%in%c(1,2,3)|dat$b712%in%c(1,2,3)|dat$b713%in%c(1,2,3))]<-1
dat$covs_drugs_father_binary <-NA
dat$covs_drugs_father_binary[which(dat$pb090==4|dat$pb091==4|dat$pb092==4|dat$pb093==4|dat$pb094==4|dat$pb095==4|dat$pb096==4|dat$pb097==4)]<-0
dat$covs_drugs_father_binary[which(dat$pb090%in%c(1,2,3)|dat$pb091%in%c(1,2,3)|dat$pb092%in%c(1,2,3)|dat$pb093%in%c(1,2,3)|dat$pb094%in%c(1,2,3)|dat$pb095%in%c(1,2,3)|dat$pb096%in%c(1,2,3)|dat$pb097%in%c(1,2,3))]<-1
#Pregnancy complications
dat$covs_hdp_binary<-dat$HDP
dat$covs_hdp_binary[dat$covs_hdp_binary<0]<-NA
#glycosuria, existing diabetes or gestational diabetes vs no glycosuria or diabetes
dat$covs_glycosuria_binary<-NA
dat$covs_glycosuria_binary[dat$pregnancy_diabetes==0]<-0
dat$covs_glycosuria_binary[dat$pregnancy_diabetes%in%c(1,2,3)]<-1
# Child's health
dat$covs_gestage <- dat$bestgest
dat$covs_preterm_binary <- NA
dat$covs_preterm_binary[dat$covs_gestage<37]<-1
dat$covs_preterm_binary[dat$covs_gestage>=37]<-0
dat$covs_breastfeeding_ordinal <- NA
dat$covs_breastfeeding_ordinal[dat$kb280==1] <-0 #never
dat$covs_breastfeeding_ordinal[dat$kb280==2] <-1 #less than 1 month (combined to make less than 3m - matches categories for kc404)
dat$covs_breastfeeding_ordinal[dat$kb280==3] <- 1 #1-<3 months (combined to make less than 3m - matches categories for kc404)
dat$covs_breastfeeding_ordinal[dat$kb280==4] <- 2 #3-<6 months
dat$covs_breastfeeding_ordinal[dat$kb280==5]<- 3 #6 or more months
dat$covs_breastfeeding_ordinal[dat$kc404==0] <- 0
dat$covs_breastfeeding_ordinal[dat$kc404==1] <- 1
dat$covs_breastfeeding_ordinal[dat$kc404==2] <- 2
dat$covs_breastfeeding_ordinal[dat$kc404==3] <- 3
dat$covs_alcohol_child_stage2_binary<-NA
dat$covs_alcohol_child_stage2_binary[which(dat$kg475==0|dat$kk800==0)]<-0
dat$covs_alcohol_child_stage2_binary[which(dat$kg475>0|dat$kk800>0)]<-1
dat$covs_alcohol_child_stage3_binary<-NA
dat$covs_alcohol_child_stage3_binary[dat$kq885==0]<-0
dat$covs_alcohol_child_stage3_binary[dat$kq885>0]<-1
dat$covs_alcohol_child_stage4_binary<-NA
dat$covs_alcohol_child_stage4_binary[dat$kt6400==0]<-0
dat$covs_alcohol_child_stage4_binary[dat$kt6400>0]<-1
dat$covs_alcohol_child_any_binary <- NA
dat$covs_alcohol_child_any_binary[dat$covs_alcohol_child_stage2_binary==0|dat$covs_alcohol_child_stage3_binary==0|dat$covs_alcohol_child_stage4_binary==0]<-0
dat$covs_alcohol_child_any_binary[dat$covs_alcohol_child_stage2_binary==1|dat$covs_alcohol_child_stage3_binary==1|dat$covs_alcohol_child_stage4_binary==1]<-1
  # difficult to derive a continuous or ordinal measure for caffeine intake, so have used a binary variable for each type of drink
dat$covs_coffee_child_stage0_binary<-NA
dat$covs_coffee_child_stage0_binary[dat$kb388==1]<-0
dat$covs_coffee_child_stage0_binary[dat$kb388==2]<-1
dat$covs_tea_child_stage0_binary<-NA
dat$covs_tea_child_stage0_binary[dat$kb385==1]<-0
dat$covs_tea_child_stage0_binary[dat$kb385==2]<-1
dat$covs_cola_child_stage0_binary<-NA
dat$covs_cola_child_stage0_binary[dat$kb361==1]<-0
dat$covs_cola_child_stage0_binary[dat$kb361==2]<-1
dat$covs_caffeinedrinks_child_stage0_binary <-NA
dat$covs_caffeinedrinks_child_stage0_binary[dat$covs_coffee_child_stage0_binary==0&dat$covs_tea_child_stage0_binary==0&dat$covs_cola_child_stage0_binary==0] <-0
dat$covs_caffeinedrinks_child_stage0_binary[dat$covs_coffee_child_stage0_binary==1|dat$covs_tea_child_stage0_binary==1|dat$covs_cola_child_stage0_binary==1] <-1
dat$covs_coffee_child_stage1_binary<-NA
dat$covs_coffee_child_stage1_binary[dat$kc542==1|dat$ke340==1]<-0
dat$covs_coffee_child_stage1_binary[dat$kc542==2|dat$ke340==2]<-1
dat$covs_tea_child_stage1_binary<-NA
dat$covs_tea_child_stage1_binary[dat$kc539==1|dat$ke338==1]<-0
dat$covs_tea_child_stage1_binary[dat$kc539==2|dat$ke338==2]<-1
dat$covs_cola_child_stage1_binary<-NA
dat$covs_cola_child_stage1_binary[dat$kc512==1|dat$ke320==1]<-0
dat$covs_cola_child_stage1_binary[dat$kc512==2|dat$ke320==2]<-1
dat$covs_caffeinedrinks_child_stage1_binary <-NA
dat$covs_caffeinedrinks_child_stage1_binary[dat$covs_coffee_child_stage1_binary==0&dat$covs_tea_child_stage1_binary==0&dat$covs_cola_child_stage1_binary==0] <-0
dat$covs_caffeinedrinks_child_stage1_binary[dat$covs_coffee_child_stage1_binary==1|dat$covs_tea_child_stage1_binary==1|dat$covs_cola_child_stage1_binary==1] <-1
dat$covs_coffee_child_stage2_binary<-NA
dat$covs_coffee_child_stage2_binary[which(dat$kg423==0|dat$kk645==2)]<-0
dat$covs_coffee_child_stage2_binary[which(dat$kg423>0|dat$kk645==1)]<-1
dat$covs_tea_child_stage2_binary<-NA
dat$covs_tea_child_stage2_binary[which(dat$kg420==0|dat$kk640==2)]<-0
dat$covs_tea_child_stage2_binary[which(dat$kg420>0|dat$kk640==1)]<-1
dat$covs_cola_child_stage2_binary<-NA
dat$covs_cola_child_stage2_binary[which(dat$kg369a==1|dat$kk598==1)]<-0
dat$covs_cola_child_stage2_binary[which(dat$kg369a>1|dat$kk598>1)]<-1
dat$covs_caffeinedrinks_child_stage2_binary <-NA
dat$covs_caffeinedrinks_child_stage2_binary[dat$covs_coffee_child_stage2_binary==0&dat$covs_tea_child_stage2_binary==0&dat$covs_cola_child_stage2_binary==0] <-0
dat$covs_caffeinedrinks_child_stage2_binary[dat$covs_coffee_child_stage2_binary==1|dat$covs_tea_child_stage2_binary==1|dat$covs_cola_child_stage2_binary==1] <-1
dat$covs_coffee_child_stage3_binary<-NA
dat$covs_coffee_child_stage3_binary[dat$kq830==1]<-1
dat$covs_coffee_child_stage3_binary[dat$kq830==2]<-0
dat$covs_tea_child_stage3_binary<-NA
dat$covs_tea_child_stage3_binary[dat$kq823==1]<-1
dat$covs_tea_child_stage3_binary[dat$kq823==2]<-0
dat$covs_cola_child_stage3_binary<-NA
dat$covs_cola_child_stage3_binary[dat$kq798a==1]<-1
dat$covs_cola_child_stage3_binary[dat$kq798a==2]<-0
dat$covs_caffeinedrinks_child_stage3_binary <-NA
dat$covs_caffeinedrinks_child_stage3_binary[dat$covs_coffee_child_stage3_binary==0&dat$covs_tea_child_stage3_binary==0&dat$covs_cola_child_stage3_binary==0] <-0
dat$covs_caffeinedrinks_child_stage3_binary[dat$covs_coffee_child_stage3_binary==1|dat$covs_tea_child_stage3_binary==1|dat$covs_cola_child_stage3_binary==1] <-1
dat$covs_coffee_child_stage4_binary<-NA
dat$covs_coffee_child_stage4_binary[dat$kt6290==1]<-1
dat$covs_coffee_child_stage4_binary[dat$kt6290==2]<-0
dat$covs_tea_child_stage4_binary<-NA
dat$covs_tea_child_stage4_binary[dat$kt6280==1]<-1
dat$covs_tea_child_stage4_binary[dat$kt6280==2]<-0
dat$covs_cola_child_stage4_binary<-NA
dat$covs_cola_child_stage4_binary[dat$kt6193==1]<-0
dat$covs_cola_child_stage4_binary[dat$kt6193>1]<-1
dat$covs_caffeinedrinks_child_stage4_binary <-NA
dat$covs_caffeinedrinks_child_stage4_binary[dat$covs_coffee_child_stage4_binary==0&dat$covs_tea_child_stage4_binary==0&dat$covs_cola_child_stage4_binary==0] <-0
dat$covs_caffeinedrinks_child_stage4_binary[dat$covs_coffee_child_stage4_binary==1|dat$covs_tea_child_stage4_binary==1|dat$covs_cola_child_stage4_binary==1] <-1
dat$covs_caffeinedrinks_child_before2_binary <-NA
dat$covs_caffeinedrinks_child_before2_binary[dat$covs_caffeinedrinks_child_stage0_binary==0|dat$covs_caffeinedrinks_child_stage1_binary==0] <-0
dat$covs_caffeinedrinks_child_before2_binary[dat$covs_caffeinedrinks_child_stage0_binary==1|dat$covs_caffeinedrinks_child_stage1_binary==1] <-1
dat$covs_passivesmk_child_stage0_binary <- NA
dat$covs_passivesmk_child_stage0_binary[which(dat$kb549==2&dat$kb551==2)]<-0
dat$covs_passivesmk_child_stage0_binary[which(dat$kb549==1&dat$kb551==1)]<-1
dat$covs_passivesmk_child_stage1_binary <- NA
dat$covs_passivesmk_child_stage1_binary[which(dat$kc363==0|(dat$ke196a==2&dat$ke195a==2))]<-0
dat$covs_passivesmk_child_stage1_binary[which(dat$kc363>0|(dat$ke196a==1|dat$ke195a==1))]<-1
dat$covs_passivesmk_child_stage2_binary <- NA
dat$covs_passivesmk_child_stage2_binary[which(dat$kg174==1|dat$kk312==1)]<-0
dat$covs_passivesmk_child_stage2_binary[which(dat$kg174>1|dat$kk312>1)]<-1
dat$covs_passivesmk_child_stage3_binary <- NA
dat$covs_passivesmk_child_stage3_binary[which((dat$kp5090==6&dat$kp5091==6)|(dat$km3030==6&dat$km3031==6))]<-0
dat$covs_passivesmk_child_stage3_binary[which((dat$kp5090%in%c(1:5)|dat$kp5091%in%c(1:5))|(dat$km3030%in%c(1:5)|dat$km3031%in%c(1:5)))]<-1
dat$covs_passivesmk_child_stage4_binary <- NA
dat$covs_passivesmk_child_stage4_binary[which(dat$kt1210==6&dat$kt1211==6)]<-0
dat$covs_passivesmk_child_stage4_binary[which(dat$kt1210%in%c(1:5)&dat$kt1211%in%c(1:5))]<-1
dat$covs_passivesmk_child_before2_binary <-NA
dat$covs_passivesmk_child_before2_binary[dat$covs_passivesmk_child_stage0_binary==0|dat$covs_passivesmk_child_stage1_binary==0] <-0
dat$covs_passivesmk_child_before2_binary[dat$covs_passivesmk_child_stage0_binary==1|dat$covs_passivesmk_child_stage1_binary==1] <-1

##### PERINATAL OUTCOMES

#survive one year
dat$peri_survive_one_year <-NA
dat$peri_survive_one_year[dat$kz011b==1] <-1
dat$peri_survive_one_year[dat$kz011b==2] <-0
#live births (could be useful outcome, or way to select sample)
dat$peri_live_birth <-NA
dat$peri_live_birth[dat$kz011==1]<-1
dat$peri_live_birth[dat$kz011==2]<-0
#miscarriage or termination before 20 weeks vs live birth (could be useful outcome, or way to select sample)
dat$peri_miscarriage_termination_b420wks <- NA
dat$peri_miscarriage_termination_b420wks[dat$kz011==0]<-1
dat$peri_miscarriage_termination_b420wks[dat$peri_live_birth==1]<-0
#fetal death/stillbirth after 20 weeks vs live birth (could be useful outcome, or way to select sample)
dat$peri_fetal_death_after_20wks <- NA
dat$peri_fetal_death_after_20wks[dat$kz011==1]<-1
dat$peri_fetal_death_after_20wks[dat$peri_live_birth==1]<-0
#termination for congenital malformation (could be useful outcome, or way to select sample)
dat$peri_congenital_malf_termination <-NA
dat$peri_congenital_malf_termination[dat$mz011b==1]<-1
dat$peri_congenital_malf_termination[dat$mz011b==3]<-0
dat$peri_congenital_malf_termination[dat$mz011b==7]<-0
#death with a congenital defect up to one year (vs deaths before 1 with no congenital malformation)
dat$peri_congenital_malf_death_before_one_year <-NA
dat$peri_congenital_malf_death_before_one_year[dat$kz017==1] <-1
dat$peri_congenital_malf_death_before_one_year[dat$kz017==2] <-0

##### ANTHROPOMETRIC OUTCOMES

#birthweight
dat$anthro_birthweight <-dat$kz030
dat$anthro_birthweight[dat$anthro_birthweight<0]<-NA #removing missing data
dat$anthro_birthweight_zscore <-scale(dat$anthro_birthweight)
#head circumference in cm
dat$anthro_head_circ_birth <- dat$kz031
dat$anthro_head_circ_birth[dat$anthro_head_circ_birth<0]<-NA
dat$anthro_head_circ_birth_zscore <-scale(dat$anthro_head_circ_birth)
#crown-heel in cm
dat$anthro_crown_heel_birth <- dat$kz032
dat$anthro_crown_heel_birth[dat$anthro_crown_heel_birth<0]<-NA
dat$anthro_crown_heel_birth_zscore <-scale(dat$anthro_crown_heel_birth)
#High BW > 4500g vs >=2500g & <=4500g 
dat$anthro_birthweight_high_binary <- NA
dat$anthro_birthweight_high_binary[dat$anthro_birthweight>4500]<-1
dat$anthro_birthweight_high_binary[dat$anthro_birthweight>=2500&dat$anthro_birthweight<=4500]<-0
#Low BW <2500g vs >=2500g & <=4500g
dat$anthro_birthweight_low_binary <- NA
dat$anthro_birthweight_low_binary[dat$anthro_birthweight<2500]<-1
dat$anthro_birthweight_low_binary[dat$anthro_birthweight>=2500&dat$anthro_birthweight<=4500]<-0
#SGA and LGA can be derived from the centile data in Useful Data.
dat$anthro_birthweight_sga_binary <- NA
dat$anthro_birthweight_sga_binary[dat$centiles<=10]<-1
dat$anthro_birthweight_sga_binary[dat$centiles>10]<-0
dat$anthro_birthweight_lga_binary <- NA
dat$anthro_birthweight_lga_binary[dat$centiles>=90]<-1
dat$anthro_birthweight_lga_binary[dat$centiles<90]<-0
#Head circumference at other ages - there are a few carer-reported measures in the km and kp files, but it's unclear why there are multiple measurements and anyway there is likely to be a lot of measurement error in these, so we will stick to HC measured at the F7 clinic (stage 3):
dat$anthro_head_circ_stage3 <-dat$f7ms014
dat$anthro_head_circ_stage3[dat$anthro_head_circ_stage3<0]<-NA
dat$anthro_head_circ_stage3_zscore <- scale(dat$anthro_head_circ_stage3)
#Height** - there are lots of measures, but we will prioritise clinic measures of parental report of child's height
#Height at stage 1 (12 months to 35 months) - take the latest timepoint first, then supplement with earlier timepoints if NA
temp31<-dat$cf055
temp31[temp31<0]<-NA
temp25<-dat$cf054
temp25[temp25<0]<-NA
timepoint <-ifelse(is.na(temp31),NA,"31")
temp3125 <-temp31
temp3125[is.na(timepoint)]<-temp25[is.na(timepoint)]
timepoint[is.na(timepoint)&(is.na(temp25)==FALSE)]<-"25"
dat$stage1_timepoint <-timepoint
dat$anthro_height_stage1 <- temp3125
dat$anthro_height_stage1_zscore <- scale(dat$anthro_height_stage1)
#Height at stage 2 (>=3 <5y; 36 to 60 months) - take the latest timepoint first, then supplement with earlier timepoints if NA
temp37<-dat$cf056
temp37[temp37<0]<-NA
temp43<-dat$cf057
temp43[temp43<0]<-NA
temp49<-dat$cf058
temp49[temp49<0]<-NA
timepoint <-ifelse(is.na(temp49),NA,"49")
temp494337 <-temp49 # take latest timepoint (49 m)
temp494337[is.na(timepoint)]<-temp43[is.na(timepoint)] #if NA, use 43 m
timepoint[is.na(timepoint)&(is.na(temp43)==FALSE)]<-"43"
temp494337[is.na(timepoint)]<-temp37[is.na(timepoint)] #if both 49 and 43 NA, use 37 m
timepoint[is.na(timepoint)&(is.na(temp37)==FALSE)]<-"37"
dat$stage2_timepoint <-timepoint
dat$anthro_height_stage2 <- temp494337
dat$anthro_height_stage2_zscore <- scale(dat$anthro_height_stage2)
#Height at stage 3 (take age 7 clinic). The earliest possible file we could use is CIF at 61 months (5y 1m), but this is only in about 1000 children. F7 is the earliest complete clinic. There is a clinic at F8, but this is too late for this timepoint
dat$anthro_height_stage3<-dat$f7ms010
dat$anthro_height_stage3[dat$anthro_height_stage3<0]<-NA
dat$anthro_height_stage3_zscore <- scale(dat$anthro_height_stage3)
#Height at stage 4 - there are three clinics (8, 9 & 10) and we could do as above for stage 1 and 3 by taking F10 and then filling in missing values with F9 then F8, but then we would be in a potentially tricky situation later when we are calculating fat mass index and need height JUST at F9. So I made the decision to just use F9, which is in the middle of the age category and should suit our purposes fine.
dat$anthro_height_stage4<-dat$fdms010
dat$anthro_height_stage4[dat$anthro_height_stage4<0]<-NA
dat$anthro_height_stage4_zscore <- scale(dat$anthro_height_stage4)
#Waist circumference** 
#WC at stage 1 (12 months to 35 months) - only measured at 31
dat$anthro_waist_stage1<-dat$cf075
dat$anthro_waist_stage1[dat$anthro_waist_stage1<0]<-NA
dat$anthro_waist_stage1_zscore <- scale(dat$anthro_waist_stage1)
#WC at stage 2 (>=3 <5y; 36 to 60 months) - take measurement at timepoint used for the height measurement above (else different timepoints will be used for different outcomes and this will get confusing and overly clunky)
dat$anthro_waist_stage2 <- NA
dat$anthro_waist_stage2[which(dat$stage2_timepoint=="37")] <-dat$cf076[which(dat$stage2_timepoint=="37")]
dat$anthro_waist_stage2[which(dat$stage2_timepoint=="43")] <-dat$cf077[which(dat$stage2_timepoint=="43")]
dat$anthro_waist_stage2[which(dat$stage2_timepoint=="49")] <-dat$cf078[which(dat$stage2_timepoint=="49")]
dat$anthro_waist_stage2[dat$anthro_waist_stage2<0]<-NA
dat$anthro_waist_stage2_zscore <- scale(dat$anthro_waist_stage2)
#WC at stage 3 (take age 7 clinic). The earliest possible file we could use is CIF at 61 months (5y 1m), but this is only in about 1000 children. F7 is the earliest complete clinic. There is a clinic at F8, but this is too late for this timepoint
dat$anthro_waist_stage3<-dat$f7ms018
dat$anthro_waist_stage3[dat$anthro_waist_stage3<0]<-NA
dat$anthro_waist_stage3_zscore <- scale(dat$anthro_waist_stage3)
#WC at stage 4 (use age 9 clinic)
dat$anthro_waist_stage4<-dat$f9ms018
dat$anthro_waist_stage4[dat$anthro_waist_stage4<0]<-NA
dat$anthro_waist_stage4_zscore <- scale(dat$anthro_waist_stage4)
#Weight ** 
#Weight at stage 1 (12 months to 35 months) - measured at 25 and 31m
dat$anthro_weight_stage1 <- NA
dat$anthro_weight_stage1[which(dat$stage1_timepoint=="31")] <-dat$cf045[which(dat$stage1_timepoint=="31")]
dat$anthro_weight_stage1[which(dat$stage1_timepoint=="25")] <-dat$cf044[which(dat$stage1_timepoint=="25")]
dat$anthro_weight_stage1[dat$anthro_weight_stage1<0]<-NA
dat$anthro_weight_stage1_zscore <- scale(dat$anthro_weight_stage1)
#Weight at stage 2 (>=3 <5y; 36 to 60 months) - take measurement at timepoint used for the height measurement above (else different timepoints will be used for different outcomes and this will get confusing and overly clunky)
dat$anthro_weight_stage2 <- NA
dat$anthro_weight_stage2[which(dat$stage2_timepoint=="37")] <-dat$cf046[which(dat$stage2_timepoint=="37")]
dat$anthro_weight_stage2[which(dat$stage2_timepoint=="43")] <-dat$cf047[which(dat$stage2_timepoint=="43")]
dat$anthro_weight_stage2[which(dat$stage2_timepoint=="49")] <-dat$cf048[which(dat$stage2_timepoint=="49")]
dat$anthro_weight_stage2[dat$anthro_weight_stage2<0]<-NA
dat$anthro_weight_stage2_zscore <- scale(dat$anthro_weight_stage2)
#Weight at stage 3 (take age 7 clinic). The earliest possible file we could use is CIF at 61 months (5y 1m), but this is only in about 1000 children. F7 is the earliest complete clinic. There is a clinic at F8, but this is too late for this timepoint
dat$anthro_weight_stage3<-dat$f7ms026
dat$anthro_weight_stage3[dat$anthro_weight_stage3<0]<-NA
dat$anthro_weight_stage3_zscore <- scale(dat$anthro_weight_stage3)
#Weight at stage 4 (use age 9 clinic)
dat$anthro_weight_stage4<-dat$f9ms026
dat$anthro_weight_stage4[dat$anthro_weight_stage4<0]<-NA
dat$anthro_weight_stage4_zscore <- scale(dat$anthro_weight_stage4)
dat$covs_age_child_stage1_cif <- NA
dat$covs_age_child_stage1_cif[which(dat$stage1_timepoint=="25")] <-dat$cf014[which(dat$stage1_timepoint=="25")]
dat$covs_age_child_stage1_cif[which(dat$stage1_timepoint=="31")] <-dat$cf015[which(dat$stage1_timepoint=="31")]
#age at CIF clinics
dat$covs_age_child_stage2_cif <- NA
dat$covs_age_child_stage2_cif[which(dat$stage2_timepoint=="37")] <-dat$cf016[which(dat$stage2_timepoint=="37")]
dat$covs_age_child_stage2_cif[which(dat$stage2_timepoint=="43")] <-dat$cf017[which(dat$stage2_timepoint=="43")]
dat$covs_age_child_stage2_cif[which(dat$stage2_timepoint=="49")] <-dat$cf018[which(dat$stage2_timepoint=="49")]
#BMI ** 
#Stage 1
dat$anthro_bmi_stage1 <- dat$anthro_weight_stage1 / ((dat$anthro_height_stage1/100)^2)
#Stage 2
dat$anthro_bmi_stage2 <- dat$anthro_weight_stage2 / ((dat$anthro_height_stage2/100)^2)
#Stage 3
dat$anthro_bmi_stage3 <- dat$anthro_weight_stage3 / ((dat$anthro_height_stage3/100)^2)
#Stage 4
dat$anthro_bmi_stage4 <- dat$anthro_weight_stage4 / ((dat$anthro_height_stage4/100)^2)
#WHO categories of overweight and obesity**
#Stage 1
library(childsds)
dat$anthro_bmi_stage1_sds <- sds(value = dat$anthro_bmi_stage1,
                                 age = dat$covs_age_child_stage1_cif/12,
                                 sex = dat$covs_sex, male = "male", female = "female",
                                 ref = ukwho.ref, item = "bmi")
#Stage 2
dat$anthro_bmi_stage2_sds <- sds(value = dat$anthro_bmi_stage2,
                                 age = dat$covs_age_child_stage2_cif/12,
                                 sex = dat$covs_sex, male = "male", female = "female",
                                 ref = ukwho.ref, item = "bmi")
#Stage 3
dat$anthro_bmi_stage3_sds <- sds(value = dat$anthro_bmi_stage3,
                                 age = dat$covs_age_child_stage3_f7/12,
                                 sex = dat$covs_sex, male = "male", female = "female",
                                 ref = ukwho.ref, item = "bmi")
#Stage 4
dat$anthro_bmi_stage4_sds <- sds(value = dat$anthro_bmi_stage4,
                                 age = dat$covs_age_child_stage4_f9/12,
                                 sex = dat$covs_sex, male = "male", female = "female",
                                 ref = ukwho.ref, item = "bmi")
#Variables comparing overweight/obese to normal, and obese to normal
#Stage 1
dat$anthro_overweightobese_stage1_binary <- NA
dat$anthro_overweightobese_stage1_binary[dat$anthro_bmi_stage1_sds>1] <-1
dat$anthro_overweightobese_stage1_binary[which(dat$anthro_bmi_stage1_sds>=(-2) &dat$anthro_bmi_stage1_sds<=1)] <-0
dat$anthro_obese_stage1_binary <- NA
dat$anthro_obese_stage1_binary[which(dat$anthro_bmi_stage1_sds>2)] <-1
dat$anthro_obese_stage1_binary[which(dat$anthro_bmi_stage1_sds<=1 &dat$anthro_bmi_stage1_sds>=(-2))] <-0
#Stage 2
dat$anthro_overweightobese_stage2_binary <- NA
dat$anthro_overweightobese_stage2_binary[dat$anthro_bmi_stage2_sds>1] <-1
dat$anthro_overweightobese_stage2_binary[which(dat$anthro_bmi_stage2_sds>=(-2) &dat$anthro_bmi_stage2_sds<=1)] <-0
dat$anthro_obese_stage2_binary <- NA
dat$anthro_obese_stage2_binary[which(dat$anthro_bmi_stage2_sds>2)] <-1
dat$anthro_obese_stage2_binary[which(dat$anthro_bmi_stage2_sds<=1 &dat$anthro_bmi_stage2_sds>=(-2))] <-0
#Stage 3
dat$anthro_overweightobese_stage3_binary <- NA
dat$anthro_overweightobese_stage3_binary[dat$anthro_bmi_stage3_sds>1] <-1
dat$anthro_overweightobese_stage3_binary[which(dat$anthro_bmi_stage3_sds>=(-2) &dat$anthro_bmi_stage3_sds<=1)] <-0
dat$anthro_obese_stage3_binary <- NA
dat$anthro_obese_stage3_binary[which(dat$anthro_bmi_stage3_sds>2)] <-1
dat$anthro_obese_stage3_binary[which(dat$anthro_bmi_stage3_sds<=1 &dat$anthro_bmi_stage3_sds>=(-2))] <-0
#Stage 4
dat$anthro_overweightobese_stage4_binary <- NA
dat$anthro_overweightobese_stage4_binary[dat$anthro_bmi_stage4_sds>1] <-1
dat$anthro_overweightobese_stage4_binary[which(dat$anthro_bmi_stage4_sds>=(-2) &dat$anthro_bmi_stage4_sds<=1)] <-0
dat$anthro_obese_stage4_binary <- NA
dat$anthro_obese_stage4_binary[which(dat$anthro_bmi_stage4_sds>2)] <-1
dat$anthro_obese_stage4_binary[which(dat$anthro_bmi_stage4_sds<=1 &dat$anthro_bmi_stage4_sds>=(-2))] <-0
#Fat mass index **
dat$anthro_fmi_stage4 <- dat$f9dx135
dat$anthro_fmi_stage4[dat$f9dx135<0]<-NA
dat$anthro_fmi_stage4 <- dat$anthro_fmi_stage4 / dat$anthro_height_stage4
dat$anthro_fmi_stage4_zscore <- scale(dat$anthro_fmi_stage4)

##### IMMUNOLOGICAL OUTCOMES

#Wheeze**
  #Stage 0 (>0,<1) - kb child wheezed (selected just for the participants answering before 12 months)
dat$immuno_wheeze_stage0_binary <-NA
dat$immuno_wheeze_stage0_binary[which(dat$kb053==1&dat$kb879a>0&dat$kb879a<12)]<-1
dat$immuno_wheeze_stage0_binary[which(dat$kb053==2&dat$kb879a>0&dat$kb879a<12)]<-0
#Stage 1 (around age 2; >=1 to <3) - kd, kf: kd051b Wheezing since 6mths and 
#kd070 Wheezing & Whistling on Chest since 6 MTHS and kf063 Child wheezed > 18 months, Y/N. 
dat$immuno_wheeze_stage1_binary <-NA
dat$immuno_wheeze_stage1_binary[which(dat$kd051b==2 | dat$kd070==2 | dat$kf063==2)] <-0
dat$immuno_wheeze_stage1_binary[which(dat$kd051b==1 | dat$kd070==1 | dat$kf063==1)] <-1
#Stage 2 (around age 4; >=3 to <5) - kj and kl have questions.
dat$immuno_wheeze_stage2_binary <-NA
dat$immuno_wheeze_stage2_binary[which(dat$kj043==2 | dat$kj090==2 | dat$kl031==3| dat$kl080==2)] <-0
dat$immuno_wheeze_stage2_binary[which(dat$kj043==1 | dat$kj090==1 | dat$kl031%in%c(1,2)| dat$kl080==1)] <-1
#Stage 3 (around age 6; >=5 to <8) - kn, kq, kr, kp have questions.
dat$immuno_wheeze_stage3_binary <-NA
dat$immuno_wheeze_stage3_binary[which(dat$kn1031==3 | dat$kn1110==2 | dat$kq024a==2| dat$kq070==2| dat$kr031a==2)] <-0
dat$immuno_wheeze_stage3_binary[which(dat$kn1031%in%c(1,2) | dat$kn1110==1 | dat$kq024a==1| dat$kq070==1| dat$kr031a==1)] <-1
#Stage 4 (around age 9; >=8 to <11) - ks, kv have questions
dat$immuno_wheeze_stage4_binary <-NA
dat$immuno_wheeze_stage4_binary[which(dat$ks1031==3 | dat$ks1260==2 | dat$kv1080==2|dat$kv1050==3)] <-0
dat$immuno_wheeze_stage4_binary[which(dat$ks1031%in%c(1,2) | dat$ks1260==1 | dat$kv1080==1|dat$kv1050%in%c(1,2))] <-1
#Any timepoint
dat$immuno_wheeze_allstages_binary <- rowSums(dat[,c("immuno_wheeze_stage0_binary","immuno_wheeze_stage1_binary","immuno_wheeze_stage2_binary","immuno_wheeze_stage3_binary","immuno_wheeze_stage4_binary")],na.rm=T)
dat$immuno_wheeze_allstages_binary[dat$immuno_wheeze_allstages_binary>0]<-1
dat$immuno_wheeze_allstages_binary[which(is.na(dat$immuno_wheeze_stage0_binary) & is.na(dat$immuno_wheeze_stage1_binary) & is.na(dat$immuno_wheeze_stage2_binary)&is.na(dat$immuno_wheeze_stage3_binary)&is.na(dat$immuno_wheeze_stage4_binary))] <- NA
#Asthma**
#Stage 3 (around age 6; >=5 to <8) - kn, kq, kr, kp have questions. kp3030 C1p: Child had asthma medication in past 12 months, kq034a DV: CH Had Asthma In Past Year, kr041a DV: Child had asthma in past 12 months (Y/N), kr050 A4: Doctor has ever said child has asthma, kr105a DV: Child had asthma medicine in past 12 months
dat$immuno_asthma_stage3_binary <-NA
dat$immuno_asthma_stage3_binary[which(dat$kp3030==1 | dat$kq034a==2 | dat$kr041a==2 | dat$kr105a==2)] <-0
dat$immuno_asthma_stage3_binary[which(dat$kp3030%in%c(2,3) | dat$kq034a==1 | dat$kr041a==1 | dat$kr105a==1)]  <-1
#Stage 4 (around age 9; >=8 to <11) - ks1041 A3v: Child had asthma in past year, ks1240 A8p: Child given asthma medication in past year, kv1059 A4t: Child had asthma in past 12 months
dat$immuno_asthma_stage4_binary <-NA
dat$immuno_asthma_stage4_binary[which(dat$ks1041==3 | dat$ks1240==1 | dat$kv1059==3)] <-0
dat$immuno_asthma_stage4_binary[which(dat$ks1041%in%c(1,2) | dat$ks1240%in%c(2,3)|dat$kv1059%in%c(1,2))] <-1
#Any timepoint
dat$immuno_asthma_allstages_binary <- rowSums(dat[,c("immuno_asthma_stage3_binary","immuno_asthma_stage4_binary")],na.rm=T)
dat$immuno_asthma_allstages_binary[dat$immuno_asthma_allstages_binary>0]<-1
dat$immuno_asthma_allstages_binary[which(is.na(dat$immuno_asthma_stage3_binary)&is.na(dat$immuno_asthma_stage4_binary))] <- NA
# replace if doctor diagnosed
dat$immuno_asthma_allstages_binary[which(dat$kr050==1)] <-1
dat$immuno_asthma_allstages_binary[which(dat$kv1070%in%c(1,3))] <-1
#Eczema-like rash or Eczema**
#Stage 0 (>0,<1) ka,kb
dat$immuno_eczema_stage0_binary <-NA
dat$immuno_eczema_stage0_binary[which(dat$ka249 ==2| dat$ka252==2 | dat$kb086==2 & (dat$kb879a>0&dat$kb879a<12))] <-0
dat$immuno_eczema_stage0_binary[which(dat$ka249 ==1| dat$ka252==1 | dat$kb086==1 & (dat$kb879a>0&dat$kb879a<12))] <-1
#Stage 1 (around age 2; >=1 to <3) - kd, kf (kd questions refer to since 6 months, not clear if this is stage 0 or 1, so omitted)
dat$immuno_eczema_stage1_binary <-NA
dat$immuno_eczema_stage1_binary[which(dat$kf110 ==2)]<-0
dat$immuno_eczema_stage1_binary[which(dat$kf110 ==1)]<-1
#Stage 2 (around age 4; >=3 to <5) - kj and kl have questions.
dat$immuno_eczema_stage2_binary <-NA
dat$immuno_eczema_stage2_binary[which(dat$kj100 ==2| dat$kl100==2)] <-0
dat$immuno_eczema_stage2_binary[which(dat$kj100 ==1| dat$kl100==1)] <-1
#Stage 3 (around age 6; >=5 to <8) - kn, kq, kr, kp 
dat$immuno_eczema_stage3_binary <-NA
dat$immuno_eczema_stage3_binary[which(dat$kn1120==2| dat$kq035a==2 | dat$kq090==2 | dat$kr042a==2)] <-0
dat$immuno_eczema_stage3_binary[which(dat$kn1120==1| dat$kq035a==1 | dat$kq090==1 | dat$kr042a==1)] <-1
#Stage 4 (around age 9; >=8 to <11) - ks, kv 
dat$immuno_eczema_stage4_binary <-NA
dat$immuno_eczema_stage4_binary[which(dat$ks1042==3 | dat$ks1280==2 | dat$kv1110==2 | dat$kv1111==2)] <-0
dat$immuno_eczema_stage4_binary[which(dat$ks1042%in%c(1,2) | dat$ks1280==1 | dat$kv1110==1 | dat$kv1111==1)] <-1
#Any timepoint
dat$immuno_eczema_allstages_binary <- rowSums(dat[,c("immuno_eczema_stage0_binary","immuno_eczema_stage1_binary","immuno_eczema_stage2_binary","immuno_eczema_stage3_binary","immuno_eczema_stage4_binary")],na.rm=T)
dat$immuno_eczema_allstages_binary[dat$immuno_eczema_allstages_binary>0]<-1
dat$immuno_eczema_allstages_binary[which(is.na(dat$immuno_eczema_stage0_binary) & is.na(dat$immuno_eczema_stage1_binary) & is.na(dat$immuno_eczema_stage2_binary)&is.na(dat$immuno_eczema_stage3_binary)&is.na(dat$immuno_eczema_stage4_binary))] <- NA
dat$immuno_eczema_allstages_binary[which(dat$kv1070%in%c(2,3))] <-1 #replace with 1 if doctor diagnosed
#Allergies**
#Food*
#Stage 2 (around age 4; >=3 to <5) - kk
dat$immuno_allergy_food_stage2_binary <- NA
dat$immuno_allergy_food_stage2_binary[which(dat$kk262a==1)]<-1
dat$immuno_allergy_food_stage2_binary[which(dat$kk262a==2)]<-0
#Stage 3 (around age 6; >=5 to <8) - kq km have questions, but joining both together (as in commented out code below) gives too many "cases" (compared with variables at other stages and each single variable). Therefore, have decided to choose just one variable - kq is more towards the middle of this stage
dat$immuno_allergy_food_stage3_binary <- NA
dat$immuno_allergy_food_stage3_binary[which(dat$kq195a==2)]<-0
dat$immuno_allergy_food_stage3_binary[which(dat$kq195a==1)]<-1
#Stage 4 (around age 9; >=8 to <11) - ks
dat$immuno_allergy_food_stage4_binary <- NA
dat$immuno_allergy_food_stage4_binary[which(dat$ks3000%in%c(1,2))]<-1
dat$immuno_allergy_food_stage4_binary[which(dat$ks3000==3)]<-0
#Pollen*
#Stage 2 (around age 4; >=3 to <5) - kk (km?)
dat$immuno_allergy_pollen_stage2_binary <- NA
dat$immuno_allergy_pollen_stage2_binary[dat$kk286==2]<-0
dat$immuno_allergy_pollen_stage2_binary[dat$kk286==1]<-1
#Stage 3 (around age 6; >=5 to <8) - kq (6.5) km (5.5)
dat$immuno_allergy_pollen_stage3_binary <- NA
dat$immuno_allergy_pollen_stage3_binary[dat$kq217==2]<-0
dat$immuno_allergy_pollen_stage3_binary[dat$kq217==1]<-1
#Stage 4 (around age 9; >=8 to <11) - ks
dat$immuno_allergy_pollen_stage4_binary <-NA
dat$immuno_allergy_pollen_stage4_binary[which(dat$ks3030%in%c(1,2))] <-0 #set to no if give valid answer to "apart from food and drink, is your child allergic to anything else?
dat$immuno_allergy_pollen_stage4_binary[which(dat$ks3031==1)] <-1 # replace with yes if they ticked this box
#Cats*
#Stage 2 (around age 4; >=3 to <5) - kk (km?)
dat$immuno_allergy_cat_stage2_binary <- NA
dat$immuno_allergy_cat_stage2_binary[dat$kk287==2]<-0
dat$immuno_allergy_cat_stage2_binary[dat$kk287==1]<-1
#Stage 3 (around age 6; >=5 to <8) - kq (km?)
dat$immuno_allergy_cat_stage3_binary <- NA
dat$immuno_allergy_cat_stage3_binary[dat$kq218==2]<-0
dat$immuno_allergy_cat_stage3_binary[dat$kq218==1]<-1
#Stage 4 (around age 9; >=8 to <11) - ks
dat$immuno_allergy_cat_stage4_binary <-NA
dat$immuno_allergy_cat_stage4_binary[which(dat$ks3030%in%c(1,2))] <-0 #set to no if give valid answer to "apart from food and drink, is your child allergic to anything else?
dat$immuno_allergy_cat_stage4_binary[which(dat$ks3032==1)] <-1 # replace with yes if they ticked this box
#Dogs*
#Stage 2 (around age 4; >=3 to <5) - kk (km?)
dat$immuno_allergy_dog_stage2_binary <- NA
dat$immuno_allergy_dog_stage2_binary[dat$kk288==2]<-0
dat$immuno_allergy_dog_stage2_binary[dat$kk288==1]<-1
#Stage 3 (around age 6; >=5 to <8) - kq (km?)
dat$immuno_allergy_dog_stage3_binary <- NA
dat$immuno_allergy_dog_stage3_binary[dat$kq219==2]<-0
dat$immuno_allergy_dog_stage3_binary[dat$kq219==1]<-1
#Stage 4 (around age 9; >=8 to <11) - ks
dat$immuno_allergy_dog_stage4_binary <-NA
dat$immuno_allergy_dog_stage4_binary[which(dat$ks3030%in%c(1,2))] <-0 #set to no if give valid answer to "apart from food and drink, is your child allergic to anything else?
dat$immuno_allergy_dog_stage4_binary[which(dat$ks3033==1)] <-1 # replace with yes if they ticked this box
#Insect sting*
#Stage 2 (around age 4; >=3 to <5) - kk (km?)
dat$immuno_allergy_insect_stage2_binary <- NA
dat$immuno_allergy_insect_stage2_binary[dat$kk289==2]<-0
dat$immuno_allergy_insect_stage2_binary[dat$kk289==1]<-1
#Stage 3 (around age 6; >=5 to <8) - kq (km?)
dat$immuno_allergy_insect_stage3_binary <- NA
dat$immuno_allergy_insect_stage3_binary[dat$kq220==2]<-0
dat$immuno_allergy_insect_stage3_binary[dat$kq220==1]<-1
#Stage 4 (around age 9; >=8 to <11) - ks
dat$immuno_allergy_insect_stage4_binary <-NA
dat$immuno_allergy_insect_stage4_binary[which(dat$ks3030%in%c(1,2))] <-0 #set to no if give valid answer to "apart from food and drink, is your child allergic to anything else?
dat$immuno_allergy_insect_stage4_binary[which(dat$ks3034==1)] <-1 # replace with yes if they ticked this box
#House dust*
#Stage 2 (around age 4; >=3 to <5) - kk (km?)
dat$immuno_allergy_dust_stage2_binary <- NA
dat$immuno_allergy_dust_stage2_binary[dat$kk290==2]<-0
dat$immuno_allergy_dust_stage2_binary[dat$kk290==1]<-1
#Stage 3 (around age 6; >=5 to <8) - kq (km?)
dat$immuno_allergy_dust_stage3_binary <- NA
dat$immuno_allergy_dust_stage3_binary[dat$kq221==2]<-0
dat$immuno_allergy_dust_stage3_binary[dat$kq221==1]<-1
#Stage 4 (around age 9; >=8 to <11) - ks
dat$immuno_allergy_dust_stage4_binary <-NA
dat$immuno_allergy_dust_stage4_binary[which(dat$ks3030%in%c(1,2))] <-0 #set to no if give valid answer to "apart from food and drink, is your child allergic to anything else?
dat$immuno_allergy_dust_stage4_binary[which(dat$ks3035==1)] <-1 # replace with yes if they ticked this box
#Any allergy*
#Stage 2
dat$immuno_allergy_any_stage2_binary <- NA
dat$immuno_allergy_any_stage2_binary[which(dat$immuno_allergy_food_stage2_binary==0&dat$immuno_allergy_pollen_stage2_binary==0&dat$immuno_allergy_cat_stage2_binary==0&dat$immuno_allergy_dog_stage2_binary==0&dat$immuno_allergy_insect_stage2_binary==0&dat$immuno_allergy_dust_stage2_binary==0)] <-0
dat$immuno_allergy_any_stage2_binary[which(dat$immuno_allergy_food_stage2_binary==1|dat$immuno_allergy_pollen_stage2_binary==1|dat$immuno_allergy_cat_stage2_binary==1|dat$immuno_allergy_dog_stage2_binary==1|dat$immuno_allergy_insect_stage2_binary==1|dat$immuno_allergy_dust_stage2_binary==1)] <-1
#Stage 3
dat$immuno_allergy_any_stage3_binary <- NA
dat$immuno_allergy_any_stage3_binary[which(dat$immuno_allergy_food_stage3_binary==0&dat$immuno_allergy_pollen_stage3_binary==0&dat$immuno_allergy_cat_stage3_binary==0&dat$immuno_allergy_dog_stage3_binary==0&dat$immuno_allergy_insect_stage3_binary==0&dat$immuno_allergy_dust_stage3_binary==0)] <-0
dat$immuno_allergy_any_stage3_binary[which(dat$immuno_allergy_food_stage3_binary==1|dat$immuno_allergy_pollen_stage3_binary==1|dat$immuno_allergy_cat_stage3_binary==1|dat$immuno_allergy_dog_stage3_binary==1|dat$immuno_allergy_insect_stage3_binary==1|dat$immuno_allergy_dust_stage3_binary==1)] <-1
#Stage 4
dat$immuno_allergy_any_stage4_binary <- NA
dat$immuno_allergy_any_stage4_binary[which(dat$immuno_allergy_food_stage4_binary==0&dat$immuno_allergy_pollen_stage4_binary==0&dat$immuno_allergy_cat_stage4_binary==0&dat$immuno_allergy_dog_stage4_binary==0&dat$immuno_allergy_insect_stage4_binary==0&dat$immuno_allergy_dust_stage4_binary==0)] <-0
dat$immuno_allergy_any_stage4_binary[which(dat$immuno_allergy_food_stage4_binary==1|dat$immuno_allergy_pollen_stage4_binary==1|dat$immuno_allergy_cat_stage4_binary==1|dat$immuno_allergy_dog_stage4_binary==1|dat$immuno_allergy_insect_stage4_binary==1|dat$immuno_allergy_dust_stage4_binary==1)] <-1
#Any time
dat$immuno_allergy_any_allstages_binary <- rowSums(dat[,c("immuno_allergy_any_stage2_binary","immuno_allergy_any_stage3_binary","immuno_allergy_any_stage4_binary")],na.rm=T)
dat$immuno_allergy_any_allstages_binary[dat$immuno_allergy_any_allstages_binary>0]<-1
dat$immuno_allergy_any_allstages_binary[which(is.na(dat$immuno_allergy_any_stage2_binary) & is.na(dat$immuno_allergy_any_stage3_binary) & is.na(dat$immuno_allergy_any_stage4_binary))] <- NA

##### NEUROLOGICAL/PSYCHOSOCIAL OUTCOMES

#Depression (MFQ)**
dat$neuro_depression_stage4<-dat$fddp130
dat$neuro_depression_stage4[dat$fddp130<0]<-NA
dat$neuro_depression_stage4_zscore<-scale(dat$neuro_depression_stage4)
#SDQ**
#Hyperactivity (SDQ) - maternal report, continuous and dichotomised at >=7
#Stage 2
dat$neuro_hyperactivity_stage2<-dat$j557c
dat$neuro_hyperactivity_stage2[dat$j557c<0]<-NA
dat$neuro_hyperactivity_stage2_zscore <- scale(dat$neuro_hyperactivity_stage2)
dat$neuro_hyperactivity_stage2_binary <- NA
dat$neuro_hyperactivity_stage2_binary[dat$neuro_hyperactivity_stage2>=7]<-1
dat$neuro_hyperactivity_stage2_binary[dat$neuro_hyperactivity_stage2<7]<-0
#Stage 3
dat$neuro_hyperactivity_stage3<-dat$kq348b
dat$neuro_hyperactivity_stage3[dat$kq348b<0]<-NA
dat$neuro_hyperactivity_stage3_zscore <- scale(dat$neuro_hyperactivity_stage3)
dat$neuro_hyperactivity_stage3_binary <- NA
dat$neuro_hyperactivity_stage3_binary[dat$neuro_hyperactivity_stage3>=7]<-1
dat$neuro_hyperactivity_stage3_binary[dat$neuro_hyperactivity_stage3<7]<-0
#Stage 4
dat$neuro_hyperactivity_stage4<-dat$ku706b
dat$neuro_hyperactivity_stage4[dat$ku706b<0]<-NA
dat$neuro_hyperactivity_stage4_zscore <- scale(dat$neuro_hyperactivity_stage4)
dat$neuro_hyperactivity_stage4_binary <- NA
dat$neuro_hyperactivity_stage4_binary[dat$neuro_hyperactivity_stage4>=7]<-1
dat$neuro_hyperactivity_stage4_binary[dat$neuro_hyperactivity_stage4<7]<-0
#Emotional symptoms (SDQ) - maternal report, continuous and dichotomised at >=5
#Stage 2
dat$neuro_emotional_stage2<-dat$j557a
dat$neuro_emotional_stage2[dat$j557a<0]<-NA
dat$neuro_emotional_stage2_zscore <- scale(dat$neuro_emotional_stage2)
dat$neuro_emotional_stage2_binary <- NA
dat$neuro_emotional_stage2_binary[dat$neuro_emotional_stage2>=5]<-1
dat$neuro_emotional_stage2_binary[dat$neuro_emotional_stage2<5]<-0
#Stage 3
dat$neuro_emotional_stage3<-dat$kq348c
dat$neuro_emotional_stage3[dat$kq348c<0]<-NA
dat$neuro_emotional_stage3_zscore <- scale(dat$neuro_emotional_stage3)
dat$neuro_emotional_stage3_binary <- NA
dat$neuro_emotional_stage3_binary[dat$neuro_emotional_stage3>=5]<-1
dat$neuro_emotional_stage3_binary[dat$neuro_emotional_stage3<5]<-0
#Stage 4
dat$neuro_emotional_stage4<-dat$ku707b
dat$neuro_emotional_stage4[dat$ku707b<0]<-NA
dat$neuro_emotional_stage4_zscore <- scale(dat$neuro_emotional_stage4)
dat$neuro_emotional_stage4_binary <- NA
dat$neuro_emotional_stage4_binary[dat$neuro_emotional_stage4>=5]<-1
dat$neuro_emotional_stage4_binary[dat$neuro_emotional_stage4<5]<-0
#Conduct problems (SDQ) - maternal report, continuous and dichotomised at >=4
#Stage 2
dat$neuro_conduct_stage2<-dat$j557b
dat$neuro_conduct_stage2[dat$j557b<0]<-NA
dat$neuro_conduct_stage2_zscore <- scale(dat$neuro_conduct_stage2)
dat$neuro_conduct_stage2_binary <- NA
dat$neuro_conduct_stage2_binary[dat$neuro_conduct_stage2>=4]<-1
dat$neuro_conduct_stage2_binary[dat$neuro_conduct_stage2<4]<-0
#Stage 3
dat$neuro_conduct_stage3<-dat$kq348d
dat$neuro_conduct_stage3[dat$kq348d<0]<-NA
dat$neuro_conduct_stage3_zscore <- scale(dat$neuro_conduct_stage3)
dat$neuro_conduct_stage3_binary <- NA
dat$neuro_conduct_stage3_binary[dat$neuro_conduct_stage2>=4]<-1
dat$neuro_conduct_stage3_binary[dat$neuro_conduct_stage2<4]<-0
#Stage 4
dat$neuro_conduct_stage4<-dat$ku708b
dat$neuro_conduct_stage4[dat$ku708b<0]<-NA
dat$neuro_conduct_stage4_zscore <- scale(dat$neuro_conduct_stage4)
dat$neuro_conduct_stage4_binary <- NA
dat$neuro_conduct_stage4_binary[dat$neuro_conduct_stage4>=4]<-1
dat$neuro_conduct_stage4_binary[dat$neuro_conduct_stage4<4]<-0
#Peer problems (SDQ) - maternal report, continuous and dichotomised at >=4
#Stage 2
dat$neuro_peer_stage2<-dat$j557d
dat$neuro_peer_stage2[dat$j557d<0]<-NA
dat$neuro_peer_stage2_zscore <- scale(dat$neuro_peer_stage2)
dat$neuro_peer_stage2_binary <- NA
dat$neuro_peer_stage2_binary[dat$neuro_peer_stage2>=4]<-1
dat$neuro_peer_stage2_binary[dat$neuro_peer_stage2<4]<-0
#Stage 3
dat$neuro_peer_stage3<-dat$kq348e
dat$neuro_peer_stage3[dat$kq348e<0]<-NA
dat$neuro_peer_stage3_zscore <- scale(dat$neuro_peer_stage3)
dat$neuro_peer_stage3_binary <- NA
dat$neuro_peer_stage3_binary[dat$neuro_peer_stage3>=4]<-1
dat$neuro_peer_stage3_binary[dat$neuro_peer_stage3<4]<-0
#Stage 4
dat$neuro_peer_stage4<-dat$ku709b
dat$neuro_peer_stage4[dat$ku709b<0]<-NA
dat$neuro_peer_stage4_zscore <- scale(dat$neuro_peer_stage4)
dat$neuro_peer_stage4_binary <- NA
dat$neuro_peer_stage4_binary[dat$neuro_peer_stage4>=4]<-1
dat$neuro_peer_stage4_binary[dat$neuro_peer_stage4<4]<-0
#Prosocial behaviour (SDQ)  - maternal report, continuous and dichotomised at <=6
#Stage 2
dat$neuro_prosocial_stage2<-dat$j557e
dat$neuro_prosocial_stage2[dat$j557e<0]<-NA
dat$neuro_prosocial_stage2_zscore <- scale(dat$neuro_prosocial_stage2)
dat$neuro_prosocial_stage2_binary <- NA
dat$neuro_prosocial_stage2_binary[dat$neuro_prosocial_stage2<=6]<-1
dat$neuro_prosocial_stage2_binary[dat$neuro_prosocial_stage2>6]<-0
#Stage 3
dat$neuro_prosocial_stage3<-dat$kq348a
dat$neuro_prosocial_stage3[dat$kq348a<0]<-NA
dat$neuro_prosocial_stage3_zscore <- scale(dat$neuro_prosocial_stage3)
dat$neuro_prosocial_stage3_binary <- NA
dat$neuro_prosocial_stage3_binary[dat$neuro_prosocial_stage3<=6]<-1
dat$neuro_prosocial_stage3_binary[dat$neuro_prosocial_stage3>6]<-0
#Stage 4
dat$neuro_prosocial_stage4<-dat$ku705b
dat$neuro_prosocial_stage4[dat$ku705b<0]<-NA
dat$neuro_prosocial_stage4_zscore <- scale(dat$neuro_prosocial_stage4)
dat$neuro_prosocial_stage4_binary <- NA
dat$neuro_prosocial_stage4_binary[dat$neuro_prosocial_stage4<=6]<-1
dat$neuro_prosocial_stage4_binary[dat$neuro_prosocial_stage4>6]<-0
#Total behavioural difficulties (SDQ) - maternal report, continuous and dichotomised at >=17 [this is a combination of 4 subscales - excluding prosocial behaviour]
#Stage 2
dat$neuro_totalsdq_stage2<-dat$j557f
dat$neuro_totalsdq_stage2[dat$j557f<0]<-NA
dat$neuro_totalsdq_stage2_zscore <- scale(dat$neuro_totalsdq_stage2)
dat$neuro_totalsdq_stage2_binary <- NA
dat$neuro_totalsdq_stage2_binary[dat$neuro_totalsdq_stage2>=17]<-1
dat$neuro_totalsdq_stage2_binary[dat$neuro_totalsdq_stage2<17]<-0
#Stage 3
dat$neuro_totalsdq_stage3<-dat$kq348f
dat$neuro_totalsdq_stage3[dat$kq348f<0]<-NA
dat$neuro_totalsdq_stage3_zscore <- scale(dat$neuro_totalsdq_stage3)
dat$neuro_totalsdq_stage3_binary <- NA
dat$neuro_totalsdq_stage3_binary[dat$neuro_totalsdq_stage3>=17]<-1
dat$neuro_totalsdq_stage3_binary[dat$neuro_totalsdq_stage3<17]<-0
#Stage 4
dat$neuro_totalsdq_stage4<-dat$ku710b
dat$neuro_totalsdq_stage4[dat$ku710b<0]<-NA
dat$neuro_totalsdq_stage4_zscore <- scale(dat$neuro_totalsdq_stage4)
dat$neuro_totalsdq_stage4_binary <- NA
dat$neuro_totalsdq_stage4_binary[dat$neuro_totalsdq_stage4>=17]<-1
dat$neuro_totalsdq_stage4_binary[dat$neuro_totalsdq_stage4<17]<-0
#Internalising problems (SDQ) - maternal report, combination of emotional symptoms and peer problems
#Stage 2
dat$neuro_internalising_stage2 <- rowSums(dat[,c("neuro_emotional_stage2","neuro_peer_stage2")])
dat$neuro_internalising_stage2_zscore <- scale(dat$neuro_internalising_stage2)
#Stage 3
dat$neuro_internalising_stage3 <- rowSums(dat[,c("neuro_emotional_stage3","neuro_peer_stage3")])
dat$neuro_internalising_stage3_zscore <- scale(dat$neuro_internalising_stage3)
#Stage 4
dat$neuro_internalising_stage4 <- rowSums(dat[,c("neuro_emotional_stage4","neuro_peer_stage4")])
dat$neuro_internalising_stage4_zscore <- scale(dat$neuro_internalising_stage4)
#Externalising problems (SDQ) - maternal report, combination of hyperactivity and conduct problems
#Stage 2
dat$neuro_externalising_stage2 <- rowSums(dat[,c("neuro_hyperactivity_stage2","neuro_conduct_stage2")])
dat$neuro_externalising_stage2_zscore <- scale(dat$neuro_externalising_stage2)
#Stage 3
dat$neuro_externalising_stage3 <- rowSums(dat[,c("neuro_hyperactivity_stage3","neuro_conduct_stage3")])
dat$neuro_externalising_stage3_zscore <- scale(dat$neuro_externalising_stage3)
#Stage 4
dat$neuro_externalising_stage4 <- rowSums(dat[,c("neuro_hyperactivity_stage4","neuro_conduct_stage4")])
dat$neuro_externalising_stage4_zscore <- scale(dat$neuro_externalising_stage4)
#SCDC (Skuse Social Communication Score) prorated**
#Stage 3
dat$neuro_scdc_stage3<-dat$kr554b
dat$neuro_scdc_stage3[dat$kr554b<0]<-NA
dat$neuro_scdc_stage3_zscore <- scale(dat$neuro_scdc_stage3)
#IQ and/or other or composite measures of intelligence/cognitive performance**
#Verbal, performance and total
#Stage 2
dat$neuro_cognition_performance_stage2<-dat$cf811
dat$neuro_cognition_performance_stage2[dat$cf811<0]<-NA
dat$neuro_cognition_performance_stage2_zscore <- scale(dat$neuro_cognition_performance_stage2)
dat$neuro_cognition_verbal_stage2<-dat$cf812
dat$neuro_cognition_verbal_stage2[dat$cf812<0]<-NA
dat$neuro_cognition_verbal_stage2_zscore <- scale(dat$neuro_cognition_verbal_stage2)
dat$neuro_cognition_total_stage2<-dat$cf813
dat$neuro_cognition_total_stage2[dat$cf813<0]<-NA
dat$neuro_cognition_total_stage2_zscore <- scale(dat$neuro_cognition_total_stage2)
#Stage 4
dat$neuro_cognition_performance_stage4<-dat$f8ws111
dat$neuro_cognition_performance_stage4[dat$f8ws111<0]<-NA
dat$neuro_cognition_performance_stage4_zscore <- scale(dat$neuro_cognition_performance_stage4)
dat$neuro_cognition_verbal_stage4<-dat$f8ws110
dat$neuro_cognition_verbal_stage4[dat$f8ws110<0]<-NA
dat$neuro_cognition_verbal_stage4_zscore <- scale(dat$neuro_cognition_verbal_stage4)
dat$neuro_cognition_total_stage4<-dat$f8ws112
dat$neuro_cognition_total_stage4[dat$f8ws112<0]<-NA
dat$neuro_cognition_total_stage4_zscore <- scale(dat$neuro_cognition_total_stage4)

#### CARDIOMETABOLIC OUTCOMES

#SBP
dat$cardio_sbp_stage2<- NA
dat$cardio_sbp_stage2[which(dat$stage2_timepoint=="37")] <-dat$cf123[which(dat$stage2_timepoint=="37")]
dat$cardio_sbp_stage2[which(dat$stage2_timepoint=="49")] <-dat$cf133[which(dat$stage2_timepoint=="49")]
dat$cardio_sbp_stage2[dat$cardio_sbp_stage2<0]<-NA
dat$cardio_sbp_stage2_zscore <- scale(dat$cardio_sbp_stage2)
dat$cardio_sbp_stage3 <- dat$f7sa021
dat$cardio_sbp_stage3[dat$f7sa021<0]<-NA
dat$cardio_sbp_stage3_zscore <- scale(dat$cardio_sbp_stage3)
dat$cardio_sbp_stage4 <- dat$f9sa021
dat$cardio_sbp_stage4[dat$f9sa021<0]<-NA
dat$cardio_sbp_stage4_zscore <- scale(dat$cardio_sbp_stage4)
#DBP
dat$cardio_dbp_stage2<- NA
dat$cardio_dbp_stage2[which(dat$stage2_timepoint=="37")] <-dat$cf124[which(dat$stage2_timepoint=="37")]
dat$cardio_dbp_stage2[which(dat$stage2_timepoint=="49")] <-dat$cf134[which(dat$stage2_timepoint=="49")]
dat$cardio_dbp_stage2[dat$cardio_dbp_stage2<0]<-NA
dat$cardio_dbp_stage2_zscore <- scale(dat$cardio_dbp_stage2)
dat$cardio_dbp_stage3 <- dat$f7sa022
dat$cardio_dbp_stage3[dat$f7sa022<0]<-NA
dat$cardio_dbp_stage3_zscore <- scale(dat$cardio_dbp_stage3)
dat$cardio_dbp_stage4 <- dat$f9sa022
dat$cardio_dbp_stage4[dat$f9sa022<0]<-NA
dat$cardio_dbp_stage4_zscore <- scale(dat$cardio_dbp_stage4)
#Triglycerides
dat$cardio_trig_stage0 <- dat$trig_cord
dat$cardio_trig_stage0[dat$trig_cord<0]<-NA
dat$cardio_trig_stage0_zscore <- scale(dat$cardio_trig_stage0)
dat$cardio_trig_stage1 <- dat$Trig_CIF31
dat$cardio_trig_stage1[dat$Trig_CIF31<0]<-NA
dat$cardio_trig_stage1_zscore <- scale(dat$cardio_trig_stage1)
dat$cardio_trig_stage2 <- dat$Trig_CIF43
dat$cardio_trig_stage2[dat$Trig_CIF43<0]<-NA
dat$cardio_trig_stage2_zscore <- scale(dat$cardio_trig_stage2)
dat$cardio_trig_stage3 <- dat$TRIG_F7
dat$cardio_trig_stage3[dat$TRIG_F7<0]<-NA
dat$cardio_trig_stage3_zscore <- scale(dat$cardio_trig_stage3)
dat$cardio_trig_stage4 <- dat$trig_f9
dat$cardio_trig_stage4[dat$trig_f9<0]<-NA
dat$cardio_trig_stage4_zscore <- scale(dat$cardio_trig_stage4)
#HDL
dat$cardio_HDL_stage0 <- dat$HDL_cord
dat$cardio_HDL_stage0[dat$HDL_cord<0]<-NA
dat$cardio_HDL_stage0_zscore <- scale(dat$cardio_HDL_stage0)
dat$cardio_HDL_stage1 <- dat$HDL_CIF31
dat$cardio_HDL_stage1[dat$HDL_CIF31<0]<-NA
dat$cardio_HDL_stage1_zscore <- scale(dat$cardio_HDL_stage1)
dat$cardio_HDL_stage2 <- dat$HDL_CIF43
dat$cardio_HDL_stage2[dat$HDL_CIF43<0]<-NA
dat$cardio_HDL_stage2_zscore <- scale(dat$cardio_HDL_stage2)
dat$cardio_HDL_stage3 <- dat$HDL_F7
dat$cardio_HDL_stage3[dat$HDL_F7<0]<-NA
dat$cardio_HDL_stage3_zscore <- scale(dat$cardio_HDL_stage3)
dat$cardio_HDL_stage4 <- dat$HDL_f9
dat$cardio_HDL_stage4[dat$HDL_f9<0]<-NA
dat$cardio_HDL_stage4_zscore <- scale(dat$cardio_HDL_stage4)
#LDL
dat$cardio_LDL_stage0 <- dat$LDL_cord
dat$cardio_LDL_stage0[dat$LDL_cord<0]<-NA
dat$cardio_LDL_stage0_zscore <- scale(dat$cardio_LDL_stage0)
dat$cardio_LDL_stage1 <- dat$LDL_CIF31
dat$cardio_LDL_stage1[dat$LDL_CIF31<0]<-NA
dat$cardio_LDL_stage1_zscore <- scale(dat$cardio_LDL_stage1)
dat$cardio_LDL_stage2 <- dat$LDL_CIF43
dat$cardio_LDL_stage2[dat$LDL_CIF43<0]<-NA
dat$cardio_LDL_stage2_zscore <- scale(dat$cardio_LDL_stage2)
dat$cardio_LDL_stage3 <- dat$LDL_F7
dat$cardio_LDL_stage3[dat$LDL_F7<0]<-NA
dat$cardio_LDL_stage3_zscore <- scale(dat$cardio_LDL_stage3)
dat$cardio_LDL_stage4 <- dat$LDL_f9
dat$cardio_LDL_stage4[dat$LDL_f9<0]<-NA
dat$cardio_LDL_stage4_zscore <- scale(dat$cardio_LDL_stage4)
#Total cholesterol
dat$cardio_chol_stage0 <- dat$chol_cord
dat$cardio_chol_stage0[dat$chol_cord<0]<-NA
dat$cardio_chol_stage0_zscore <- scale(dat$cardio_chol_stage0)
dat$cardio_chol_stage1 <- dat$Chol_CIF31
dat$cardio_chol_stage1[dat$Chol_CIF31<0]<-NA
dat$cardio_chol_stage1_zscore <- scale(dat$cardio_chol_stage1)
dat$cardio_chol_stage2 <- dat$Chol_CIF43
dat$cardio_chol_stage2[dat$Chol_CIF43<0]<-NA
dat$cardio_chol_stage2_zscore <- scale(dat$cardio_chol_stage2)
dat$cardio_chol_stage3 <- dat$CHOL_F7
dat$cardio_chol_stage3[dat$CHOL_F7<0]<-NA
dat$cardio_chol_stage3_zscore <- scale(dat$cardio_chol_stage3)
dat$cardio_chol_stage4 <- dat$CHOL_F9
dat$cardio_chol_stage4[dat$CHOL_F9<0]<-NA
dat$cardio_chol_stage4_zscore <- scale(dat$cardio_chol_stage4)
#Insulin
dat$cardio_insulin_stage0 <- dat$Insulin_cord
dat$cardio_insulin_stage0[dat$Insulin_cord<0]<-NA
dat$cardio_insulin_stage0_zscore <- scale(dat$cardio_insulin_stage0)
dat$cardio_insulin_stage4 <- dat$insulin_F9
dat$cardio_insulin_stage4[dat$insulin_F9<0]<-NA
dat$cardio_insulin_stage4_zscore <- scale(dat$cardio_insulin_stage4)
#CRP
dat$cardio_CRP_stage0 <- dat$CRP_cord
dat$cardio_CRP_stage0[dat$CRP_cord<0]<-NA
dat$cardio_CRP_stage0_zscore <- scale(dat$cardio_CRP_stage0)
dat$cardio_CRP_stage4 <- dat$CRP_f9
dat$cardio_CRP_stage4[dat$CRP_f9<0]<-NA
dat$cardio_CRP_stage4_zscore <- scale(dat$cardio_CRP_stage4)
#Apolipoprotein-A
dat$cardio_apoA_stage4 <- dat$ApoAI_f9
dat$cardio_apoA_stage4[dat$ApoAI_f9<0]<-NA
dat$cardio_apoA_stage4_zscore <- scale(dat$cardio_apoA_stage4)
#Apolipoprotein-B
dat$cardio_apoB_stage4 <- dat$ApoB_f9
dat$cardio_apoB_stage4[dat$ApoB_f9<0]<-NA
dat$cardio_apoB_stage4_zscore <- scale(dat$cardio_apoB_stage4)
#IL-6
dat$cardio_il6_stage4 <- dat$IL6_f9
dat$cardio_il6_stage4[dat$IL6_f9<0]<-NA
dat$cardio_il6_stage4_zscore <- scale(dat$cardio_il6_stage4)

##### NEGATIVE CONTROL OUTCOMES
# Pigeon infestation
dat$negcon_pigeons_binary <-NA
dat$negcon_pigeons_binary[which(dat$g572a==2|dat$h462a==2)]<-0
dat$negcon_pigeons_binary[which(dat$g572a==1|dat$h462a==1)]<-1
# Mice infestation
dat$negcon_mice_binary <-NA
dat$negcon_mice_binary[which(dat$g571a==2|dat$h461a==2)]<-0
dat$negcon_mice_binary[which(dat$g571a==1|dat$h461a==1)]<-1
# Left handedness (to draw)
dat$negcon_lefthand_binary <-NA
dat$negcon_lefthand_binary[which(dat$kf528%in%c(2,3)|dat$kj518%in%c(2,3))]<-0 #not very well or hasn't done yet
dat$negcon_lefthand_binary[which(dat$kf528==1|dat$kj518==1)]<-1#does well

##### SMOKING EXPOSURES
### Maternal
#Any time up to birth: ever vs never smoker: binary variable
dat$smoking_mother_ever_life_binary <- NA
dat$smoking_mother_ever_life_binary[dat$b650==1] <- 1
dat$smoking_mother_ever_life_binary[dat$b650==2] <- 0
#Early-onset: Smoking before or including age 11 vs no smoking before age 11
dat$smoking_mother_before11_binary <- NA
dat$smoking_mother_before11_binary[dat$b651<=11 & dat$b651>0] <- 1
dat$smoking_mother_before11_binary[dat$b651==(-2)|dat$b651>11] <- 0 #-2 is never smoked
#Pre-conception: Any vs no smoking in the three months prior to pregnancy
dat$smoking_mother_preconception_binary <- NA
dat$smoking_mother_preconception_binary[dat$b663==1]<-0
dat$smoking_mother_preconception_binary[dat$b663%in%c(2,3,4,5)]<-1
#Pre-conception: Number of cigarettes per day in the three months prior to pregnancy (ordered categorical)
  #lifecyle have defined using none, <10 and >10. Looking at the variable catalogue, it looks like we can split into more categories for our cohorts (none, light, moderate, heavy)
dat$smoking_mother_preconception_ordinal <- NA
dat$smoking_mother_preconception_ordinal[dat$b669==0]<-"None"
dat$smoking_mother_preconception_ordinal[dat$b669%in%c(1,5)]<-"Light" #i.e. <10 but not 0
dat$smoking_mother_preconception_ordinal[dat$b669==10 | dat$b669==15]<-"Moderate" #i.e. <20, >=10
dat$smoking_mother_preconception_ordinal[dat$b669>=20]<-"Heavy" #i.e.>=20
dat$smoking_mother_preconception_ordinal<-factor(dat$smoking_mother_preconception_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: N cigarettes in the first trimester (up to end of 12 weeks)
dat$smoking_mother_firsttrim_ordinal <- NA
  #b670 asks for number smoked in first trimester
  dat$smoking_mother_firsttrim_ordinal[dat$b670==0]<-"None"
  dat$smoking_mother_firsttrim_ordinal[dat$b670%in%c(1,5)]<-"Light" #i.e. <5 but not 0
  dat$smoking_mother_firsttrim_ordinal[dat$b670==10 | dat$b670==15]<-"Moderate" #i.e. <20, >=10
  dat$smoking_mother_firsttrim_ordinal[dat$b670>=20]<-"Heavy" #i.e.>=20
  #b671 asks for number smoked in last two weeks, which could be first trimester depending on when she filled out the questionnaire
  dat$smoking_mother_firsttrim_ordinal[which(dat$b671==1&dat$time_qB_mother_gestation<=12&is.na(dat$smoking_mother_firsttrim_ordinal))]<-"Light"
  dat$smoking_mother_firsttrim_ordinal[which(dat$b671==5&dat$time_qB_mother_gestation<=12&is.na(dat$smoking_mother_firsttrim_ordinal))]<-"Light"
  dat$smoking_mother_firsttrim_ordinal[which((dat$b671==10|dat$b671==15)&dat$time_qB_mother_gestation<=12&is.na(dat$smoking_mother_firsttrim_ordinal))]<-"Moderate"
  dat$smoking_mother_firsttrim_ordinal[which(dat$b671>=20&dat$time_qB_mother_gestation<=12&is.na(dat$smoking_mother_firsttrim_ordinal))]<-"Heavy"
dat$smoking_mother_firsttrim_ordinal<-factor(dat$smoking_mother_firsttrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking in the first trimester (up to end of 12 weeks)
dat$smoking_mother_firsttrim_binary <- NA
dat$smoking_mother_firsttrim_binary[dat$smoking_mother_firsttrim_ordinal=="None"]<-0
dat$smoking_mother_firsttrim_binary[dat$smoking_mother_firsttrim_ordinal%in% c("Light","Moderate","Heavy")]<-1
#Pregnancy: N cigarettes in the second trimester (week 13 to end of 26)
  #we can use 2 variables, b671 has most data, so we'll start with that and then fill in missing values with c482
  dat$smoking_mother_secondtrim_ordinal <- NA
  #b671 asks if mother smoked in last two weeks, which could be second trimester depending on when she answered the question
  dat$smoking_mother_secondtrim_ordinal[which(dat$b671==0&dat$time_qB_mother_gestation%in%13:26)]<-"None"
  dat$smoking_mother_secondtrim_ordinal[which(dat$b671==1&dat$time_qB_mother_gestation%in%13:26)]<-"Light"
  dat$smoking_mother_secondtrim_ordinal[which(dat$b671==5&dat$time_qB_mother_gestation%in%13:26)]<-"Light"
  dat$smoking_mother_secondtrim_ordinal[which((dat$b671==10|dat$b671==15)&dat$time_qB_mother_gestation%in%13:26)]<-"Moderate"
  dat$smoking_mother_secondtrim_ordinal[which(dat$b671>=20&dat$time_qB_mother_gestation%in%13:26)]<-"Heavy"
  #c482 asks for number smoked "at the moment", which could be second trimester
  dat$smoking_mother_secondtrim_ordinal[which(dat$c482==0&dat$time_qC_mother_gestation%in%13:26&is.na(dat$smoking_mother_secondtrim_ordinal))]<-"None"
  dat$smoking_mother_secondtrim_ordinal[which(dat$c482%in%1:4&dat$time_qC_mother_gestation%in%13:26&is.na(dat$smoking_mother_secondtrim_ordinal))]<-"Light"
  dat$smoking_mother_secondtrim_ordinal[which(dat$c482%in%5:9&dat$time_qC_mother_gestation%in%13:26&is.na(dat$smoking_mother_secondtrim_ordinal))]<-"Light"
  dat$smoking_mother_secondtrim_ordinal[which(dat$c482%in%10:19&dat$time_qC_mother_gestation%in%13:26&is.na(dat$smoking_mother_secondtrim_ordinal))]<-"Moderate"
  dat$smoking_mother_secondtrim_ordinal[which(dat$c482>=20&dat$time_qC_mother_gestation%in%13:26&is.na(dat$smoking_mother_secondtrim_ordinal))]<-"Heavy"
dat$smoking_mother_secondtrim_ordinal<-factor(dat$smoking_mother_secondtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking in the second trimester (week 13-end 26)
dat$smoking_mother_secondtrim_binary <- NA
dat$smoking_mother_secondtrim_binary[dat$smoking_mother_secondtrim_ordinal=="None"]<-0
dat$smoking_mother_secondtrim_binary[dat$smoking_mother_secondtrim_ordinal%in% c("Light","Moderate","Heavy")]<-1
#Pregnancy: N cigarettes per day in the third trimester (week 27 onwards)
  #we can use three variables, e178 is the most straightforward, so we'll start with that and then fill in the missing values using the other variables where possible
  dat$smoking_mother_thirdtrim_ordinal <- NA
  #e178 asks how many times per day did they smoked in the last two months of pregnancy
  dat$smoking_mother_thirdtrim_ordinal[dat$e178==0]<-"None"
  dat$smoking_mother_thirdtrim_ordinal[dat$e178==1]<-"Light" #i.e. <5 but not 0
  dat$smoking_mother_thirdtrim_ordinal[dat$e178==5]<-"Light" #i.e. <10, >=5
  dat$smoking_mother_thirdtrim_ordinal[dat$e178==10 | dat$e178==15]<-"Moderate" #i.e. <20, >=10
  dat$smoking_mother_thirdtrim_ordinal[dat$e178>=20]<-"Heavy" #i.e.>=20
  #c482 asks for number smoked "at the moment", which could be third trimester
  dat$smoking_mother_thirdtrim_ordinal[which(dat$c482==0&dat$time_qC_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"None"
  dat$smoking_mother_thirdtrim_ordinal[which(dat$c482%in%1:4&dat$time_qC_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Light"
  dat$smoking_mother_thirdtrim_ordinal[which(dat$c482%in%5:9&dat$time_qC_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Light"
  dat$smoking_mother_thirdtrim_ordinal[which(dat$c482%in%10:19&dat$time_qC_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Moderate"
  dat$smoking_mother_thirdtrim_ordinal[which(dat$c482>=20&dat$time_qC_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Heavy"
  #b671 asks how much the mother smoked in last two weeks, which could be third trimester depending on when she filled out the questionnaire
  dat$smoking_mother_thirdtrim_ordinal[which(dat$b671==1&dat$time_qB_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Light"
  dat$smoking_mother_thirdtrim_ordinal[which(dat$b671==5&dat$time_qB_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Light"
  dat$smoking_mother_thirdtrim_ordinal[which((dat$b671==10|dat$b671==15)&dat$time_qB_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Moderate"
  dat$smoking_mother_thirdtrim_ordinal[which(dat$b671>=20&dat$time_qB_mother_gestation>=27&is.na(dat$smoking_mother_thirdtrim_ordinal))]<-"Heavy"
dat$smoking_mother_thirdtrim_ordinal<-factor(dat$smoking_mother_thirdtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking in the third trimester (27 weeks onward)
dat$smoking_mother_thirdtrim_binary <- NA
dat$smoking_mother_thirdtrim_binary[dat$smoking_mother_thirdtrim_ordinal=="None"]<-0
dat$smoking_mother_thirdtrim_binary[dat$smoking_mother_thirdtrim_ordinal%in% c("Light","Moderate","Heavy")]<-1
#Pregnancy: Any smoking vs no smoking at any time during pregnancy
dat$smoking_mother_ever_pregnancy_binary<-NA
dat$smoking_mother_ever_pregnancy_binary[dat$smoking_mother_firsttrim_binary==0 & dat$smoking_mother_secondtrim_binary==0 &dat$smoking_mother_thirdtrim_binary==0] <- 0
dat$smoking_mother_ever_pregnancy_binary[dat$smoking_mother_firsttrim_binary==1 | dat$smoking_mother_secondtrim_binary==1 | dat$smoking_mother_thirdtrim_binary==1] <- 1
#Passive smoke during pregnancy: binary variable
dat$smoking_mother_passive_binary<-NA
dat$smoking_mother_passive_binary[dat$c481a==1]<-0
dat$smoking_mother_passive_binary[dat$c481a>1]<-1
#Postnatal: ordinal smoking after birth of child, up to 2 years (first 1000 days)
  #smoking at 8 months = f620; 0=none, 1=light, 5=light to moderate, 10|15=moderate to heavy, 20+=heavy
  #smoking at 21 months = g820; 0=none, 1=light, 5=light to moderate, 10|15=moderate to heavy, 20+=heavy
  temp_var_8<-NA
  temp_var_8[dat$f620==0]<-0
  temp_var_8[dat$f620==1]<-1
  temp_var_8[dat$f620==5]<-1
  temp_var_8[dat$f620==10|dat$f620==15]<-2
  temp_var_8[dat$f620>=20]<-3
  temp_var_21<-NA
  temp_var_21[dat$g820==0]<-0
  temp_var_21[dat$g820==1]<-1
  temp_var_21[dat$g820==5]<-1
  temp_var_21[dat$g820==10|dat$g820==15]<-2
  temp_var_21[dat$g820>=20]<-3
  temp_df<-data.frame(temp_var_8,temp_var_21)
  temp_df$temp_var_218<-apply(temp_df,1,max,na.rm=T)
  temp_df$temp_var_218[is.infinite(temp_df$temp_var_218)]<-NA
dat$smoking_mother_postnatal_ordinal<-temp_df$temp_var_218
dat$smoking_mother_postnatal_ordinal[dat$smoking_mother_postnatal_ordinal==0]<-"None"
dat$smoking_mother_postnatal_ordinal[dat$smoking_mother_postnatal_ordinal==1]<-"Light"
dat$smoking_mother_postnatal_ordinal[dat$smoking_mother_postnatal_ordinal==2]<-"Moderate"
dat$smoking_mother_postnatal_ordinal[dat$smoking_mother_postnatal_ordinal==3]<-"Heavy"
dat$smoking_mother_postnatal_ordinal<-factor(dat$smoking_mother_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
rm(temp_df,temp_var_21,temp_var_8)
#Postnatal: any vs no smoking after birth of child, up to 2 years (first 1000 days)
dat$smoking_mother_postnatal_binary <- NA
dat$smoking_mother_postnatal_binary[dat$smoking_mother_postnatal_ordinal=="None"]<-0
dat$smoking_mother_postnatal_binary[dat$smoking_mother_postnatal_ordinal%in% c("Light","Moderate","Heavy")]<-1

### Paternal
#Any time up to birth: ever vs never smoker: binary variable
  #self report, but there were a small number (33) where mother said in b683 that father is current smoker, but partner has reported they are a never smoker... Not going to do anything about this because the number is small and the mother may have been answering for a different partner(?), and we don't know the error rate (and can't do anything about the error) where fathers have said they are ever smokers and mothers have said they are not current smokers.
dat$smoking_father_ever_life_binary <- NA
dat$smoking_father_ever_life_binary[dat$pb071==1]<-1
dat$smoking_father_ever_life_binary[dat$pb071==2]<-0
#Early-onset: Smoking before or including age 11 vs no smoking before age 11
  #concordance between maternal report and paternal report is ok, but there are some discrepancies and the paternal reported data is more complete, so stick with this.
  #self-report
  dat$smoking_father_before11_binary <- NA
  dat$smoking_father_before11_binary[dat$pb072<=11 & dat$pb072>0] <- 1
  dat$smoking_father_before11_binary[dat$pb072>11] <- 0
  dat$smoking_father_before11_binary[dat$smoking_father_ever_life_binary==0] <-0 #never smoker
  #maternal-report
  dat$smoking_father_before11_binary_mreport <-NA
  dat$smoking_father_before11_binary_mreport[dat$b691<=11 & dat$b691>0] <- 1
  dat$smoking_father_before11_binary_mreport[dat$b691>11] <- 0
  dat$smoking_father_before11_binary_mreport[dat$smoking_father_ever_life_binary==0] <-0 #never smoker
#Pre-conception/first trimester: Any vs no smoking in the three months prior to pregnancy or first trimester
  #There were a few options here: pb077 asked if they smoked regularly in the last 9 months, but depending on when they filled out the questionnaire this could have been post-conception. pb075 and pb076 asks years and months since giving up smoking, but when I tried to derive the variable the n was very low. b683 is maternal report of partner current smoking, but not attached to a date. pb078 is times smoked per day at start of pregnancy, which is likely to be the same as preconception, so I think go with that.
  #It wasn't possible to distinguish between pre-conception and first trimester
dat$smoking_father_startpregnancy_binary <- NA
dat$smoking_father_startpregnancy_binary[dat$pb078==0]<-0
dat$smoking_father_startpregnancy_binary[dat$pb078 %in% 1:30]<-1
dat$smoking_father_startpregnancy_binary_mreport <-NA
dat$smoking_father_startpregnancy_binary_mreport[dat$b683==1]<-0
dat$smoking_father_startpregnancy_binary_mreport[dat$b683>1]<-1
#Pre-conception/first trimester: Number of cigarettes per day (ordered categorical)
dat$smoking_father_startpregnancy_ordinal <- NA
dat$smoking_father_startpregnancy_ordinal[dat$pb078==0]<-"None"
dat$smoking_father_startpregnancy_ordinal[dat$pb078 == 1]<-"Light"
dat$smoking_father_startpregnancy_ordinal[dat$pb078 == 5]<-"Light"
dat$smoking_father_startpregnancy_ordinal[dat$pb078 == 10 | dat$pb078 == 15]<-"Moderate"
dat$smoking_father_startpregnancy_ordinal[dat$pb078 >= 20]<-"Heavy"
dat$smoking_father_startpregnancy_ordinal<-factor(dat$smoking_father_startpregnancy_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
dat$smoking_father_startpregnancy_ordinal_mreport <- NA
dat$smoking_father_startpregnancy_ordinal_mreport[dat$b685==0]<-"None"
dat$smoking_father_startpregnancy_ordinal_mreport[dat$b685 == 1|dat$b685==5]<-"Light"
dat$smoking_father_startpregnancy_ordinal_mreport[dat$b685 == 5]<-"Light"
dat$smoking_father_startpregnancy_ordinal_mreport[dat$b685 == 10 | dat$b685 == 15]<-"Moderate"
dat$smoking_father_startpregnancy_ordinal_mreport[dat$b685 >= 20]<-"Heavy"
dat$smoking_father_startpregnancy_ordinal_mreport<-factor(dat$smoking_father_startpregnancy_ordinal_mreport,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of cigarettes per day in the second trimester (ordered categorical)
  #pb079 asks how much smoking per day in past 2 weeks, and was mostly answered during the second trimester
dat$smoking_father_secondtrim_ordinal <-NA
dat$smoking_father_secondtrim_ordinal[dat$pb079==0 & dat$time_qPB_partner_gestation %in% 13:26] <-"None"
dat$smoking_father_secondtrim_ordinal[dat$pb079==1 & dat$time_qPB_partner_gestation %in% 13:26] <-"Light"
dat$smoking_father_secondtrim_ordinal[dat$pb079==5 & dat$time_qPB_partner_gestation %in% 13:26] <-"Light"
dat$smoking_father_secondtrim_ordinal[dat$pb079%in% 10:15 & dat$time_qPB_partner_gestation %in% 13:26] <-"Moderate"
dat$smoking_father_secondtrim_ordinal[dat$pb079>=20 & dat$time_qPB_partner_gestation %in% 13:26] <-"Heavy"
dat$smoking_father_secondtrim_ordinal<-factor(dat$smoking_father_secondtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking in the second trimester
dat$smoking_father_secondtrim_binary <- NA
dat$smoking_father_secondtrim_binary[dat$smoking_father_secondtrim_ordinal=="None"]<-0
dat$smoking_father_secondtrim_binary[dat$smoking_father_secondtrim_ordinal %in% c("Light","Moderate","Heavy")]<-1
#Pregnancy: Number of cigarettes per day in the third trimester (ordered categorical)
  #pc260 asks how many times per day did you smoke in the last 2 months of pregnancy
dat$smoking_father_thirdtrim_ordinal <- NA
dat$smoking_father_thirdtrim_ordinal[dat$pc260==0]<-"None"
dat$smoking_father_thirdtrim_ordinal[dat$pc260 == 1]<-"Light"
dat$smoking_father_thirdtrim_ordinal[dat$pc260 == 5]<-"Light"
dat$smoking_father_thirdtrim_ordinal[dat$pc260 == 10 | dat$pc260 == 15]<-"Moderate"
dat$smoking_father_thirdtrim_ordinal[dat$pc260 >= 20]<-"Heavy"
dat$smoking_father_thirdtrim_ordinal<-factor(dat$smoking_father_thirdtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any smoking vs no smoking in the third trimester
dat$smoking_father_thirdtrim_binary <- NA
dat$smoking_father_thirdtrim_binary[dat$smoking_father_thirdtrim_ordinal=="None"]<-0
dat$smoking_father_thirdtrim_binary[dat$smoking_father_thirdtrim_ordinal %in% c("Light","Moderate","Heavy")]<-1
#Pregnancy: Any smoking vs no smoking at any time during pregnancy
dat$smoking_father_ever_pregnancy_binary<-NA
dat$smoking_father_ever_pregnancy_binary[dat$smoking_father_startpregnancy_binary==0 & 
                                    dat$smoking_father_secondtrim_binary==0 &
                                    dat$smoking_father_thirdtrim_binary==0] <- 0
dat$smoking_father_ever_pregnancy_binary[dat$smoking_father_startpregnancy_binary==1 | 
                                    dat$smoking_father_secondtrim_binary==1 |
                                    dat$smoking_father_thirdtrim_binary==1] <- 1
#Postnatal: ordinal smoking after birth of child, up to 2 years (first 1000 days)
  #smoking at 8 months = pd620; 0=none, 1=light, 5=light to moderate, 10|15=moderate to heavy, 20+=heavy
  #smoking at 21 months = pe450; 0=none, 1=light, 5=light to moderate, 10|15=moderate to heavy, 20+=heavy
temp_var_8<-NA
temp_var_8[dat$pd620==0]<-0
temp_var_8[dat$pd620==1]<-1
temp_var_8[dat$pd620==5]<-1
temp_var_8[dat$pd620==10|dat$pd620==15]<-2
temp_var_8[dat$pd620>=20]<-3
temp_var_21<-NA
temp_var_21[dat$pe450==0]<-0
temp_var_21[dat$pe450==1]<-1
temp_var_21[dat$pe450==5]<-1
temp_var_21[dat$pe450==10|dat$pe450==15]<-2
temp_var_21[dat$pe450>=20]<-3
temp_df<-data.frame(temp_var_8,temp_var_21)
temp_df$temp_var_218<-apply(temp_df,1,max,na.rm=T)
temp_df$temp_var_218[is.infinite(temp_df$temp_var_218)]<-NA
dat$smoking_father_postnatal_ordinal<-temp_df$temp_var_218
dat$smoking_father_postnatal_ordinal[dat$smoking_father_postnatal_ordinal==0]<-"None"
dat$smoking_father_postnatal_ordinal[dat$smoking_father_postnatal_ordinal==1]<-"Light"
dat$smoking_father_postnatal_ordinal[dat$smoking_father_postnatal_ordinal==2]<-"Moderate"
dat$smoking_father_postnatal_ordinal[dat$smoking_father_postnatal_ordinal==3]<-"Heavy"
dat$smoking_father_postnatal_ordinal<-factor(dat$smoking_father_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
rm(temp_df,temp_var_21,temp_var_8)
#Postnatal: any vs no smoking after birth of child, up to 2 years (first 1000 days)
dat$smoking_father_postnatal_binary <- NA
dat$smoking_father_postnatal_binary[dat$smoking_father_postnatal_ordinal=="None"]<-0
dat$smoking_father_postnatal_binary[dat$smoking_father_postnatal_ordinal%in% c("Light","Moderate","Heavy")]<-1

##### CAFFEINE EXPOSURES
### Maternal
#First trimester coffee mg per day**
  #The n is quite low here because we have to limit to mothers who filled in the questionnaire in the first trimester (so use average over three trimesters to derive any/no caffeine in pregnancy rather than enforcing that this variable has to be 0 for no caffeine)
  #cups of coffee per week
dat$caffeine_mother_coffee_firsttrim_continuous <-dat$a228
dat$caffeine_mother_coffee_firsttrim_continuous[dat$a228<0]<-NA
dat$caffeine_mother_coffee_firsttrim_continuous[dat$time_qA_mother_gestation>12]<-NA
  # cups of coffee multiplied by 57 (mg caffeine in 1 cup coffee)
dat$caffeine_mother_coffee_firsttrim_continuous<-dat$caffeine_mother_coffee_firsttrim_continuous*57
  # mg per day
dat$caffeine_mother_coffee_firsttrim_continuous<-round(dat$caffeine_mother_coffee_firsttrim_continuous/7)
#First trimester tea mg per day**
  #cups of tea per week
dat$caffeine_mother_tea_firsttrim_continuous <-dat$a222
dat$caffeine_mother_tea_firsttrim_continuous[dat$a222<0]<-NA
dat$caffeine_mother_tea_firsttrim_continuous[dat$time_qA_mother_gestation>12]<-NA
  # cups of tea multiplied by 27 (mg caffeine in 1 cup tea)
dat$caffeine_mother_tea_firsttrim_continuous<-dat$caffeine_mother_tea_firsttrim_continuous*27
  # mg per day
dat$caffeine_mother_tea_firsttrim_continuous<-round(dat$caffeine_mother_tea_firsttrim_continuous/7)
#First trimester cola mg per day**
  #cups of cola per week
dat$caffeine_mother_cola_firsttrim_continuous <-dat$a234
dat$caffeine_mother_cola_firsttrim_continuous[dat$a234<0]<-NA
dat$caffeine_mother_cola_firsttrim_continuous[dat$time_qA_mother_gestation>12]<-NA
  # cups of cola multiplied by 27 (mg caffeine in 1 cup cola)
dat$caffeine_mother_cola_firsttrim_continuous<-dat$caffeine_mother_cola_firsttrim_continuous*20
  # mg per day
dat$caffeine_mother_cola_firsttrim_continuous<-round(dat$caffeine_mother_cola_firsttrim_continuous/7)
#First trimester total caffeine mg per day**
dat$caffeine_mother_total_firsttrim_continuous <- rowSums(dat[,c("caffeine_mother_cola_firsttrim_continuous","caffeine_mother_coffee_firsttrim_continuous","caffeine_mother_tea_firsttrim_continuous")],na.rm=TRUE)
dat$caffeine_mother_total_firsttrim_continuous[which(is.na(dat$caffeine_mother_coffee_firsttrim_continuous) & is.na(dat$caffeine_mother_tea_firsttrim_continuous) & is.na(dat$caffeine_mother_cola_firsttrim_continuous))]<-NA
#Second trimester tea mg per day**
#TEA
dat$caffeine_mother_tea_secondtrim_continuous<-dat$b742
dat$caffeine_mother_tea_secondtrim_continuous[dat$b742<0]<-NA
dat$caffeine_mother_tea_secondtrim_continuous<-dat$caffeine_mother_tea_secondtrim_continuous*27 #transform cups to mg per week
dat$caffeine_mother_tea_secondtrim_continuous<-dat$caffeine_mother_tea_secondtrim_continuous/7 #transform weekly caffeine to daily
#Second trimester coffee mg per day**
#COFFEE
dat$caffeine_mother_coffee_secondtrim_continuous<-dat$b748
dat$caffeine_mother_coffee_secondtrim_continuous[dat$b748<0]<-NA
dat$caffeine_mother_coffee_secondtrim_continuous<-dat$caffeine_mother_coffee_secondtrim_continuous*57 #transform cups to mg per week
dat$caffeine_mother_coffee_secondtrim_continuous<-dat$caffeine_mother_coffee_secondtrim_continuous/7 #transform weekly caffeine to daily
#Second trimester cola mg per day**
#COLA
dat$caffeine_mother_cola_secondtrim_continuous<-dat$b763
dat$caffeine_mother_cola_secondtrim_continuous[dat$b763<0]<-NA
dat$caffeine_mother_cola_secondtrim_continuous<-dat$caffeine_mother_cola_secondtrim_continuous*20 #transform cups to mg per week
dat$caffeine_mother_cola_secondtrim_continuous<-dat$caffeine_mother_cola_secondtrim_continuous/7 #transform weekly caffeine to daily
#Second trimester total caffeine mg per day**
dat$caffeine_mother_total_secondtrim_continuous <- rowSums(dat[,c("caffeine_mother_cola_secondtrim_continuous","caffeine_mother_coffee_secondtrim_continuous","caffeine_mother_tea_secondtrim_continuous")],na.rm=TRUE)
dat$caffeine_mother_total_secondtrim_continuous[which(is.na(dat$caffeine_mother_coffee_secondtrim_continuous) & is.na(dat$caffeine_mother_tea_secondtrim_continuous) & is.na(dat$caffeine_mother_cola_secondtrim_continuous))]<-NA
#Third trimester tea caffeine mg per day**
#TEA (cups of caffeinated tea per day)
dat$caffeine_mother_tea_thirdtrim_continuous<-dat$c300
dat$caffeine_mother_tea_thirdtrim_continuous[dat$c300<0]<-NA
dat$caffeine_mother_tea_thirdtrim_continuous<-dat$caffeine_mother_tea_thirdtrim_continuous*27 #tranform cups to mg per day
#Third trimester coffee caffeine mg per day**
#COFFEE (cups of caffeinated coffee per day)
dat$caffeine_mother_coffee_thirdtrim_continuous<-dat$c305
dat$caffeine_mother_coffee_thirdtrim_continuous[dat$c305<0]<-NA
dat$caffeine_mother_coffee_thirdtrim_continuous<-dat$caffeine_mother_coffee_thirdtrim_continuous*57 #tranform cups to mg per day
#Third trimester cola caffeine mg per day**
#COLA (cups of caffeinated cola per week)
dat$caffeine_mother_cola_thirdtrim_continuous<-dat$c310
dat$caffeine_mother_cola_thirdtrim_continuous[dat$c310<0]<-NA
dat$caffeine_mother_cola_thirdtrim_continuous<-dat$caffeine_mother_cola_thirdtrim_continuous*20 #tranform cups to mg per week
dat$caffeine_mother_cola_thirdtrim_continuous<-dat$caffeine_mother_cola_thirdtrim_continuous/7 #transform to mg per day
#Third trimester total caffeine mg per day**
dat$caffeine_mother_total_thirdtrim_continuous <- rowSums(dat[,c("caffeine_mother_cola_thirdtrim_continuous","caffeine_mother_coffee_thirdtrim_continuous","caffeine_mother_tea_thirdtrim_continuous")],na.rm=TRUE)
dat$caffeine_mother_total_thirdtrim_continuous[which(is.na(dat$caffeine_mother_coffee_thirdtrim_continuous) & is.na(dat$caffeine_mother_tea_thirdtrim_continuous) & is.na(dat$caffeine_mother_cola_thirdtrim_continuous))]<-NA
#Any vs none in first trim **
dat$caffeine_mother_total_firsttrim_binary <- NA
dat$caffeine_mother_total_firsttrim_binary[dat$caffeine_mother_total_firsttrim_continuous==0]<-0
dat$caffeine_mother_total_firsttrim_binary[dat$caffeine_mother_total_firsttrim_continuous>0]<-1
#Any vs none in second trim **
dat$caffeine_mother_total_secondtrim_binary <- NA
dat$caffeine_mother_total_secondtrim_binary[dat$caffeine_mother_total_secondtrim_continuous==0]<-0
dat$caffeine_mother_total_secondtrim_binary[dat$caffeine_mother_total_secondtrim_continuous>0]<-1
#Any vs none in third trim **
dat$caffeine_mother_total_thirdtrim_binary <- NA
dat$caffeine_mother_total_thirdtrim_binary[dat$caffeine_mother_total_thirdtrim_continuous==0]<-0
dat$caffeine_mother_total_thirdtrim_binary[dat$caffeine_mother_total_thirdtrim_continuous>0]<-1
#Average per day in pregnancy**
dat$caffeine_mother_total_ever_pregnancy_continuous <- rowMeans(dat[,c("caffeine_mother_total_thirdtrim_continuous","caffeine_mother_total_secondtrim_continuous","caffeine_mother_total_firsttrim_continuous")],na.rm=TRUE)
#Any vs none any time in pregnancy **
dat$caffeine_mother_total_ever_pregnancy_binary <- NA
dat$caffeine_mother_total_ever_pregnancy_binary[dat$caffeine_mother_total_ever_pregnancy_continuous==0]<-0
dat$caffeine_mother_total_ever_pregnancy_binary[dat$caffeine_mother_total_ever_pregnancy_continuous>0]<-1
#Postnatal tea caffeine mg per day**
#TEA (cups of caffeinated tea per day)
dat$caffeine_mother_tea_postnatal_continuous<-dat$e153
dat$caffeine_mother_tea_postnatal_continuous[dat$e153<0]<-NA
dat$caffeine_mother_tea_postnatal_continuous<-dat$caffeine_mother_tea_postnatal_continuous*27 #tranform cups to mg per day
#Postnatal coffee caffeine mg per day**
#COFFEE (cups of caffeinated coffee per day)
dat$caffeine_mother_coffee_postnatal_continuous<-dat$e155
dat$caffeine_mother_coffee_postnatal_continuous[dat$e155<0]<-NA
dat$caffeine_mother_coffee_postnatal_continuous<-dat$caffeine_mother_coffee_postnatal_continuous*57 #tranform cups to mg per day
#**Postnatal cola caffeine mg per day**
#COLA (cups of caffeinated cola per week)
dat$caffeine_mother_cola_postnatal_continuous<-dat$e151
dat$caffeine_mother_cola_postnatal_continuous[dat$e151<0]<-NA
dat$caffeine_mother_cola_postnatal_continuous<-dat$caffeine_mother_cola_postnatal_continuous*20 #tranform cups to mg per week
dat$caffeine_mother_cola_postnatal_continuous<-dat$caffeine_mother_cola_postnatal_continuous/7 #transform to mg per day
#Postnatal total caffeine mg per day**
dat$caffeine_mother_total_postnatal_continuous <- rowSums(dat[,c("caffeine_mother_cola_postnatal_continuous","caffeine_mother_coffee_postnatal_continuous","caffeine_mother_tea_postnatal_continuous")],na.rm=TRUE)
dat$caffeine_mother_total_postnatal_continuous[which(is.na(dat$caffeine_mother_coffee_postnatal_continuous) & is.na(dat$caffeine_mother_tea_postnatal_continuous) & is.na(dat$caffeine_mother_cola_postnatal_continuous))]<-NA
#Any vs none postnatally**
dat$caffeine_mother_total_postnatal_binary <- NA
dat$caffeine_mother_total_postnatal_binary[dat$caffeine_mother_total_postnatal_continuous==0]<-0
dat$caffeine_mother_total_postnatal_binary[dat$caffeine_mother_total_postnatal_continuous>0]<-1
#Ordinal variables**
dat$caffeine_mother_total_firsttrim_ordinal <- cut(dat$caffeine_mother_total_firsttrim_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
dat$caffeine_mother_total_secondtrim_ordinal <- cut(dat$caffeine_mother_total_secondtrim_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
dat$caffeine_mother_total_thirdtrim_ordinal <- cut(dat$caffeine_mother_total_thirdtrim_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
dat$caffeine_mother_total_postnatal_ordinal <- cut(dat$caffeine_mother_total_postnatal_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
dat$caffeine_mother_total_ever_pregnancy_ordinal <- cut(dat$caffeine_mother_total_ever_pregnancy_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
### Paternal
#For dads, we only have one time point (in the second trimester), which can be used for "any time in pregnancy". The problem is that the questions on how many cups of tea/coffee/cola were decaf were different in different versions of the questionnaire. In the beginning, they were asked to say whether "some" "all" or "none" of their beverages were decaf, but in later versions they were asked to give the number of cups that were decaf. If we just take the question from the latter version, we end up with a lot of missing data, so we need to consider all versions of that question.
#Second trimester tea mg per day**
#TEA
dat$caffeine_father_tea_secondtrim_continuous<-dat$pb054 #cups of tea per day)
dat$caffeine_father_tea_secondtrim_continuous[dat$pb054<0]<-NA
dat$caffeine_father_tea_secondtrim_continuous[dat$pb056a==1]<-0#set to no caffeine if say always or usually drink decaf
dat$caffeine_father_tea_secondtrim_continuous[dat$pb056==1]<-0#set to no caffeine if say always or usually drink decaf
dat$pb057[dat$pb056a==3]<-0#set decaf to 0 if say never drink decaf
dat$pb057[dat$pb056==3]<-0#set decaf to 0 if say never drink decaf
dat$pb057[dat$pb057<0]<-NA #set missing to NA in n decaf cups 
dat$caffeine_father_tea_secondtrim_continuous<-dat$caffeine_father_tea_secondtrim_continuous-dat$pb057
dat$caffeine_father_tea_secondtrim_continuous[dat$caffeine_father_tea_secondtrim_continuous<0] <-NA
dat$caffeine_father_tea_secondtrim_continuous<-dat$caffeine_father_tea_secondtrim_continuous*27 #tranform cups to mg per day
#Second trimester coffee mg per day**
#COFFEE
dat$caffeine_father_coffee_secondtrim_continuous<-dat$pb058 #cups of coffee per day)
dat$caffeine_father_coffee_secondtrim_continuous[dat$pb058<0]<-NA
dat$caffeine_father_coffee_secondtrim_continuous[dat$pb060a==1]<-0#set to no caffeine if say always or usually drink decaf
dat$caffeine_father_coffee_secondtrim_continuous[dat$pb060==1]<-0#set to no caffeine if say always or usually drink decaf
dat$pb061[dat$pb060a==3]<-0#set decaf to 0 if say never drink decaf
dat$pb061[dat$pb060==3]<-0#set decaf to 0 if say never drink decaf
dat$pb061[dat$pb061<0]<-NA #set missing to NA in n decaf cups 
dat$caffeine_father_coffee_secondtrim_continuous<-dat$caffeine_father_coffee_secondtrim_continuous-dat$pb061
dat$caffeine_father_coffee_secondtrim_continuous[dat$caffeine_father_coffee_secondtrim_continuous<0] <-NA
dat$caffeine_father_coffee_secondtrim_continuous<-dat$caffeine_father_coffee_secondtrim_continuous*57 #transform cups to mg per day
#Second trimester cola mg per day**
#COLA
dat$caffeine_father_cola_secondtrim_continuous<-dat$pb064 #cups of cola per weel)
dat$caffeine_father_cola_secondtrim_continuous[dat$pb064<0]<-NA
dat$caffeine_father_cola_secondtrim_continuous[dat$pb065a==1]<-0#set to no caffeine if say always or usually drink decaf
dat$caffeine_father_cola_secondtrim_continuous[dat$pb065==1]<-0#set to no caffeine if say always or usually drink decaf
dat$pb066[dat$pb065a==3]<-0#set decaf to 0 if say never drink decaf
dat$pb066[dat$pb065==3]<-0#set decaf to 0 if say never drink decaf
dat$pb066[dat$pb066<0]<-NA #set missing to NA in n decaf cups 
dat$caffeine_father_cola_secondtrim_continuous<-dat$caffeine_father_cola_secondtrim_continuous-dat$pb066
dat$caffeine_father_cola_secondtrim_continuous[dat$caffeine_father_cola_secondtrim_continuous<0] <-NA
dat$caffeine_father_cola_secondtrim_continuous<-dat$caffeine_father_cola_secondtrim_continuous*20 #tranform cups to mg per week
dat$caffeine_father_cola_secondtrim_continuous<-dat$caffeine_father_cola_secondtrim_continuous/7 #per day
#Second trimester total caffeine mg per day**
dat$caffeine_father_total_secondtrim_continuous <- rowSums(dat[,c("caffeine_father_cola_secondtrim_continuous","caffeine_father_coffee_secondtrim_continuous","caffeine_father_tea_secondtrim_continuous")],na.rm=TRUE)
dat$caffeine_father_total_secondtrim_continuous[which(is.na(dat$caffeine_father_coffee_secondtrim_continuous) & is.na(dat$caffeine_father_tea_secondtrim_continuous) & is.na(dat$caffeine_father_cola_secondtrim_continuous))]<-NA
#Any vs none in second trimester**
dat$caffeine_father_total_secondtrim_binary <- NA
dat$caffeine_father_total_secondtrim_binary[dat$caffeine_father_total_secondtrim_continuous==0]<-0
dat$caffeine_father_total_secondtrim_binary[dat$caffeine_father_total_secondtrim_continuous>0]<-1
#Any in pregnancy** (using only the second trimester)
dat$caffeine_father_total_ever_pregnancy_binary <- dat$caffeine_father_total_secondtrim_binary
dat$caffeine_father_total_ever_pregnancy_continuous <- dat$caffeine_father_total_secondtrim_continuous
#Ordinal variables**
dat$caffeine_father_total_secondtrim_ordinal <- cut(dat$caffeine_father_total_secondtrim_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)
dat$caffeine_father_total_ever_pregnancy_ordinal <- cut(dat$caffeine_father_total_ever_pregnancy_continuous,breaks = c(-1,0,200,400,Inf),labels = c("None","Light","Moderate","Heavy"),ordered_result = T)

##### ALCOHOL EXPOSURES

### Maternal
#Pre-conception: Number of units per day in the three months prior to pregnancy (ordered categorical)**
dat$alcohol_mother_preconception_ordinal <-NA
dat$alcohol_mother_preconception_ordinal[dat$b720==1]<-"None"
dat$alcohol_mother_preconception_ordinal[dat$b720==2]<-"Light" # <1glass per week
dat$alcohol_mother_preconception_ordinal[dat$b720%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_mother_preconception_ordinal[dat$b720%in%c(4,5,6)]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_mother_preconception_ordinal<-factor(dat$alcohol_mother_preconception_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of units per day in the first trimester (ordered categorical)**
dat$alcohol_mother_firsttrim_ordinal <-NA
dat$alcohol_mother_firsttrim_ordinal[dat$b721==1]<-"None"
dat$alcohol_mother_firsttrim_ordinal[dat$b721==2]<-"Light" #i.e. <1 glass pw
dat$alcohol_mother_firsttrim_ordinal[dat$b721%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_mother_firsttrim_ordinal[dat$b721%in%c(4,5,6)]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_mother_firsttrim_ordinal<-factor(dat$alcohol_mother_firsttrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of units per day in the second trimester (ordered categorical)**
  #The question asked was actually "how much were you drinking at around the time you first felt the baby move, or if you haven't felt the baby move yet, the last 2 weeks". People usually feel the baby kick between 16 and 25 weeks (first trim), so we can pretty safely assume this question relates to the second trimester.
dat$alcohol_mother_secondtrim_ordinal <-NA
dat$alcohol_mother_secondtrim_ordinal[dat$b722==1]<-"None"
dat$alcohol_mother_secondtrim_ordinal[dat$b722==2]<-"Light" #i.e. <1 glass pw
dat$alcohol_mother_secondtrim_ordinal[dat$b722%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_mother_secondtrim_ordinal[dat$b722%in%c(4,5,6)]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_mother_secondtrim_ordinal<-factor(dat$alcohol_mother_secondtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of units per day in the third trimester (ordered categorical)**
  #Frequency of alcohol in last 2 months of pregnancy
dat$alcohol_mother_thirdtrim_ordinal <-NA
dat$alcohol_mother_thirdtrim_ordinal[dat$e220==1]<-"None"
dat$alcohol_mother_thirdtrim_ordinal[dat$e220==2]<-"Light" #i.e. <1 glass pw
dat$alcohol_mother_thirdtrim_ordinal[dat$e220%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_mother_thirdtrim_ordinal[dat$e220%in%c(4,5,6)]<-"Heavy" #i.e DAILY drinking 1-2 glasses pd, 3-9 glasses per day, 10+ glasses per day
dat$alcohol_mother_thirdtrim_ordinal<-factor(dat$alcohol_mother_thirdtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any drinking vs no drinking preconception**
dat$alcohol_mother_preconception_binary <- NA
dat$alcohol_mother_preconception_binary[dat$alcohol_mother_preconception_ordinal=="None"] <- 0
dat$alcohol_mother_preconception_binary[dat$alcohol_mother_preconception_ordinal%in%c("Light","Moderate","Heavy")] <- 1
#Pregnancy: Any drinking vs no drinking in the first trimester**
dat$alcohol_mother_firsttrim_binary <- NA
dat$alcohol_mother_firsttrim_binary[dat$alcohol_mother_firsttrim_ordinal=="None"] <- 0
dat$alcohol_mother_firsttrim_binary[dat$alcohol_mother_firsttrim_ordinal%in%c("Light","Moderate","Heavy")] <- 1
#Pregnancy: Any drinking vs no drinking in the second trimester**
dat$alcohol_mother_secondtrim_binary <- NA
dat$alcohol_mother_secondtrim_binary[dat$alcohol_mother_secondtrim_ordinal=="None"] <- 0
dat$alcohol_mother_secondtrim_binary[dat$alcohol_mother_secondtrim_ordinal%in%c("Light","Moderate","Heavy")] <- 1
#Pregnancy: Any drinking vs no drinking in the third trimester**
dat$alcohol_mother_thirdtrim_binary <- NA
dat$alcohol_mother_thirdtrim_binary[dat$alcohol_mother_thirdtrim_ordinal=="None"] <- 0
dat$alcohol_mother_thirdtrim_binary[dat$alcohol_mother_thirdtrim_ordinal%in%c("Light","Moderate","Heavy")] <- 1
#Pregnancy: Any drinking vs no drinking at any time during pregnancy**
dat$alcohol_mother_ever_pregnancy_binary<-NA
dat$alcohol_mother_ever_pregnancy_binary[dat$alcohol_mother_firsttrim_binary==0 &dat$alcohol_mother_secondtrim_binary==0 & dat$alcohol_mother_thirdtrim_binary == 0] <-0
dat$alcohol_mother_ever_pregnancy_binary[dat$alcohol_mother_firsttrim_binary==1 |dat$alcohol_mother_secondtrim_binary ==1 |dat$alcohol_mother_thirdtrim_binary ==1] <-1
#Binge drinking in first trimester**
dat$alcohol_mother_binge1_binary<-NA
dat$alcohol_mother_binge1_binary[dat$b723==0]<- 0
dat$alcohol_mother_binge1_binary[dat$b723>0]<- 1
#Binge drinking in third trimester**
dat$alcohol_mother_binge3_binary<-NA
dat$alcohol_mother_binge3_binary[dat$c360==0]<- 0
dat$alcohol_mother_binge3_binary[dat$c360>0]<- 1
#Binge drinking at any point during pregnancy**
dat$alcohol_mother_bingepreg_binary <-NA
dat$alcohol_mother_bingepreg_binary[dat$alcohol_mother_binge1_binary==0&dat$alcohol_mother_binge3_binary==0] <-0
dat$alcohol_mother_bingepreg_binary[dat$alcohol_mother_binge1_binary==1|dat$alcohol_mother_binge3_binary==1] <-1
#Postnatal: ordinal alcohol use after birth of child up to 2 years (first 1000 days)**
  #alcohol use at 8 weeks = e221; 0=none, 1=light, 2=light to moderate, 3= Heavy
  #alcohol use at 8 months = f625; 0=none, 1=light, 2=light to moderate, 3=heavy
  #alcohol use at 21 months = g822; 0=none, 1=light, 2=light to moderate, 3=heavy
temp_var_8w<-NA
temp_var_8w[dat$e221==1]<-0
temp_var_8w[dat$e221==2]<-1
temp_var_8w[dat$e221==3]<-2
temp_var_8w[dat$e221%in%c(4,5,6)]<-3
temp_var_8m<-NA
temp_var_8m[dat$f625==1]<-0
temp_var_8m[dat$f625==2]<-1
temp_var_8m[dat$f625==3]<-2
temp_var_8m[dat$f625%in%c(4,5,6)]<-3
temp_var_21m<-NA
temp_var_21m[dat$g822==1]<-0
temp_var_21m[dat$g822==2]<-1
temp_var_21m[dat$g822==3]<-2
temp_var_21m[dat$g822%in%c(4,5,6)]<-3
temp_df<-data.frame(temp_var_8w,temp_var_8m,temp_var_21m)
temp_df$temp_var_test<-apply(temp_df,1,max,na.rm=T)
temp_df$temp_var_test[is.infinite(temp_df$temp_var_test)]<-NA
dat$alcohol_mother_postnatal_ordinal<-temp_df$temp_var_test
dat$alcohol_mother_postnatal_ordinal[dat$alcohol_mother_postnatal_ordinal==0]<-"None"
dat$alcohol_mother_postnatal_ordinal[dat$alcohol_mother_postnatal_ordinal==1]<-"Light"
dat$alcohol_mother_postnatal_ordinal[dat$alcohol_mother_postnatal_ordinal==2]<-"Moderate"
dat$alcohol_mother_postnatal_ordinal[dat$alcohol_mother_postnatal_ordinal==3]<-"Heavy"
dat$alcohol_mother_postnatal_ordinal<-factor(dat$alcohol_mother_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
rm(temp_df,temp_var_21m,temp_var_8m,temp_var_8w)
#Postnatal: any vs no drinking after birth of child up to 2 years**
dat$alcohol_mother_postnatal_binary <- NA
dat$alcohol_mother_postnatal_binary[dat$alcohol_mother_postnatal_ordinal=="None"]<-0
dat$alcohol_mother_postnatal_binary[dat$alcohol_mother_postnatal_ordinal%in% c("Light","Moderate","Heavy")]<-1
### Paternal
#Questions regarding alcohol before or during pregnancy (exposures) are going to be in the early questionnaires described above: PA and PB
#Pre-conception: Any vs no drinking in the three months prior to pregnancy**
dat$alcohol_father_preconception_binary <- NA
dat$alcohol_father_preconception_binary[dat$pb099==1]<-0
dat$alcohol_father_preconception_binary[dat$pb099%in%c(2,3,4,5,6)]<-1
#Pre-conception: Number of units per day in the three months prior to pregnancy (ordered categorical)**
dat$alcohol_father_preconception_ordinal <-NA
dat$alcohol_father_preconception_ordinal[dat$pb099==1]<-"None"
dat$alcohol_father_preconception_ordinal[dat$pb099==2]<-"Light" # <1glass per week
dat$alcohol_father_preconception_ordinal[dat$pb099%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_father_preconception_ordinal[dat$pb099%in%c(4,5,6)]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_father_preconception_ordinal<-factor(dat$alcohol_father_preconception_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of units per day in the second trimester (ordered categorical)**
dat$alcohol_father_secondtrim_ordinal <-NA
dat$alcohol_father_secondtrim_ordinal[dat$pb100==1]<-"None"
dat$alcohol_father_secondtrim_ordinal[dat$pb100==2]<-"Light" # <1glass per week
dat$alcohol_father_secondtrim_ordinal[dat$pb100%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_father_secondtrim_ordinal[dat$pb100%in%c(4,5,6)]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_father_secondtrim_ordinal<-factor(dat$alcohol_father_secondtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Number of units per day in the third trimester (ordered categorical)**
dat$alcohol_father_thirdtrim_ordinal <-NA
dat$alcohol_father_thirdtrim_ordinal[dat$pc280==1]<-"None"
dat$alcohol_father_thirdtrim_ordinal[dat$pc280==2]<-"Light" # <1glass per week
dat$alcohol_father_thirdtrim_ordinal[dat$pc280%in%c(3)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_father_thirdtrim_ordinal[dat$pc280%in%c(4,5,6)]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_father_thirdtrim_ordinal<-factor(dat$alcohol_father_thirdtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Pregnancy: Any drinking vs no drinking in the second trimester**
dat$alcohol_father_secondtrim_binary <- NA
dat$alcohol_father_secondtrim_binary[dat$pb100==1] <- 0
dat$alcohol_father_secondtrim_binary[dat$pb100>1] <- 1
#Pregnancy: Any drinking vs no drinking in the third trimester**
dat$alcohol_father_thirdtrim_binary <- NA
dat$alcohol_father_thirdtrim_binary[dat$pc280==1] <- 0
dat$alcohol_father_thirdtrim_binary[dat$pc280>1] <- 1
#Pregnancy: Any drinking vs no drinking at any time during pregnancy**
dat$alcohol_father_ever_pregnancy_binary<-NA
dat$alcohol_father_ever_pregnancy_binary[dat$alcohol_father_secondtrim_binary==0 & dat$alcohol_father_thirdtrim_binary == 0] <-0
dat$alcohol_father_ever_pregnancy_binary[dat$alcohol_father_secondtrim_binary ==1 |dat$alcohol_father_thirdtrim_binary ==1] <-1
dat$alcohol_father_ever_pregnancy_binary_mreport<-NA
dat$alcohol_father_ever_pregnancy_binary_mreport[dat$b730==1]<-0
dat$alcohol_father_ever_pregnancy_binary_mreport[dat$b730>1]<-1
#Binge drinking**
  #Only available in second trimester, so take this for the whole of pregnancy
dat$alcohol_father_bingepreg_binary<-NA
dat$alcohol_father_bingepreg_binary[dat$pb101==0]<- 0
dat$alcohol_father_bingepreg_binary[dat$pb101>0]<- 1
#Postnatal: ordinal alcohol use after birth of child up to 2 years (first 1000 days)**
  #drunk alcohol since birth asked at 8 weeks= pc281; 0=none,1=light,2=light to moderate, 3=heavy
  #how much alcohol drink at 8 months = pd625; 0=none,1=light,2=light to moderate, 3=heavy
  #how much alochol drink at 1 year 9m = pe452; 0=none,1=light,2=light to moderate, 3=heavy
temp_var_pc<-NA
temp_var_pc[dat$pc281==1]<-0
temp_var_pc[dat$pc281%in%c(2)]<-1
temp_var_pc[dat$pc281==3]<-2
temp_var_pc[dat$pc281%in%c(4,5,6)]<-3
temp_var_pd<-NA
temp_var_pd[dat$pd625==5]<-0
temp_var_pd[dat$pd625%in%c(2,3)]<-1
temp_var_pd[dat$pd625==2]<-2
temp_var_pd[dat$pd625==1]<-3
temp_var_pe<-NA
temp_var_pe[dat$pe452==1]<-0
temp_var_pe[dat$pe452%in%c(2)]<-1
temp_var_pe[dat$pe452==3]<-2
temp_var_pe[dat$pe452%in%c(4,5,6)]<-3
temp_df<-data.frame(temp_var_pc,temp_var_pd,temp_var_pe)
temp_df$temp_var_test<-apply(temp_df,1,max,na.rm=T)
temp_df$temp_var_test[is.infinite(temp_df$temp_var_test)]<-NA
dat$alcohol_father_postnatal_ordinal<-temp_df$temp_var_test
dat$alcohol_father_postnatal_ordinal[dat$alcohol_father_postnatal_ordinal==0]<-"None"
dat$alcohol_father_postnatal_ordinal[dat$alcohol_father_postnatal_ordinal==1]<-"Light"
dat$alcohol_father_postnatal_ordinal[dat$alcohol_father_postnatal_ordinal==2]<-"Moderate"
dat$alcohol_father_postnatal_ordinal[dat$alcohol_father_postnatal_ordinal==3]<-"Heavy"
dat$alcohol_father_postnatal_ordinal<-factor(dat$alcohol_father_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
rm(temp_df,temp_var_pe,temp_var_pd,temp_var_pc)
#Postnatal: any vs no drinking after birth of child up to 2 years**
dat$alcohol_father_postnatal_binary <- NA
dat$alcohol_father_postnatal_binary[dat$alcohol_father_postnatal_ordinal=="None"]<-0
dat$alcohol_father_postnatal_binary[dat$alcohol_father_postnatal_ordinal%in% c("Light","Moderate","Heavy")]<-1

##### PHYSICAL ACTIVITY EXPOSURES

#Maternal and paternal PA in the second trimester
dat$physact_mother_secondtrim_ordinal <- NA
dat$physact_mother_secondtrim_ordinal[dat$b635==0|dat$b634==2]<-"None" #0
dat$physact_mother_secondtrim_ordinal[which(dat$b635>0&dat$b635<=3)]<-"Light" #<=3
dat$physact_mother_secondtrim_ordinal[which(dat$b635>3&dat$b635<=6)]<-"Moderate" #<=6
dat$physact_mother_secondtrim_ordinal[dat$b635>6]<-"Heavy" #>6
dat$physact_mother_secondtrim_ordinal<-factor(dat$physact_mother_secondtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
dat$physact_father_secondtrim_ordinal <- NA
dat$physact_father_secondtrim_ordinal[dat$pb014==0|dat$pb013==2]<-"None" #0
dat$physact_father_secondtrim_ordinal[which(dat$pb014>0&dat$pb014<=3)]<-"Light" #<=3
dat$physact_father_secondtrim_ordinal[which(dat$pb014>3&dat$pb014<=6)]<-"Moderate" #<=6
dat$physact_father_secondtrim_ordinal[dat$pb014>6]<-"Heavy" #>6
dat$physact_father_secondtrim_ordinal<-factor(dat$physact_father_secondtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Maternal PA in the third trimester
dat$physact_mother_thirdtrim_ordinal <- NA
dat$physact_mother_thirdtrim_ordinal[dat$c504==0|dat$c503==2]<-"None" #0
dat$physact_mother_thirdtrim_ordinal[which(dat$c504>0&dat$c504<=3)]<-"Light" #<=3
dat$physact_mother_thirdtrim_ordinal[which(dat$c504>3&dat$c504<=6)]<-"Moderate" #<=6
dat$physact_mother_thirdtrim_ordinal[dat$c504>6]<-"Heavy" #>6
dat$physact_mother_thirdtrim_ordinal<-factor(dat$physact_mother_thirdtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)
#Maternal PA in the postnatal period up to age 2
  #NOTE THAT THIS IS NOT THE SAME AS IN TRIMESTER 2 AND 3 (DAYS NOT WEEKS) THEREFORE NOT DIRECTLY COMPARABLE
dat$physact_mother_postnatal_ordinal <- NA
dat$physact_mother_postnatal_ordinal[dat$g761==2]<-"None" #0
dat$physact_mother_postnatal_ordinal[dat$g762%in%c(1,2)]<-"Light" #1-2 days
dat$physact_mother_postnatal_ordinal[which(dat$g762>=3&dat$g762<=5)]<-"Moderate" #3-5 days
dat$physact_mother_postnatal_ordinal[dat$g762>=6]<-"Heavy" #6-7 days per week
dat$physact_mother_postnatal_ordinal<-factor(dat$physact_mother_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

##### DIETARY EXPOSURES
source("University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/data_prep/cohorts/alspac/gen_med_diet_data.R")
med_diet_data <- gen_med_diet_data()
dat <- left_join(dat,med_diet_data,by=c("aln","qlet"),all.x=T)

##### GENETIC DATA
source("University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/data_prep/cohorts/alspac/gen_genetic_data.R")
genetic_data <- gen_genetic_data()
dat <- left_join(dat,genetic_data,by=c("aln","qlet"),all.x=T)

##### Save file
saveRDS(dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds")
