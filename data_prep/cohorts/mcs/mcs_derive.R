######################################################################
## Code to create mcs_pheno.rds                                     ##
## This code cleans and derives variables from mcs_pheno_raw.rds    ##
######################################################################

## CURRENTLY DOESN'T INCLUDE STUDY WEIGHTS, BUT SHOULD DO.
## SEE: https://stylizeddata.com/how-to-use-survey-weights-in-r/
## AND: https://cls.ucl.ac.uk/wp-content/uploads/2017/07/User-Guide-to-Analysing-MCS-Data-using-Stata.pdf
## AND: https://stackoverflow.com/questions/46737602/translating-stata-code-to-r-survey-weights
## ESSENTIALLY, WE HAVE TO SET UP THE SURVEY DESIGN (DIFFERENT FOR DIFFERENT OUTCOMES BECAUSE DIFFERENT SWEEPS NEED DIFFERENT WEIGHTS) - MAY BE EASIEST TO SET UP DIFFERENT VERSIONS OF MCS DAT DEPENDING ON OUTCOME, E.G. MCS_S1, MCS_S2 ETC
## THEN RUN THE PHEWAS USING SPECIFIC FUNCTIONS FOR LM AND GLM FROM THE SURVEY PACKAGE - APPLIED TO EACH VERSION OF MCS DEPENDING ON THE OUTCOMES (MCS_1 ETC)

library(knitr)
library(haven)
library(survey)

raw_dat <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno_raw.rds")
dat<- raw_dat[,c(names(raw_dat)[1:7],"covs_biological_father","paternal_participation")]

# Timing specific smoking
raw_dat$smoking_amount_now_mum <-raw_dat$amsmma00 #if smokes cigs or roll-ups now, how many per day?
raw_dat$smoking_amount_now_mum[raw_dat$smoking_amount_now_mum<0]<-NA
raw_dat$smoking_amount_now_mum[raw_dat$amsmus0a==1|raw_dat$amsmus0b==1|raw_dat$amsmus0c==1] <- 0 #doesn't smoke now

raw_dat$smoking_amount_prepreg_mum <- raw_dat$amcipr00 #if smokes now or has in the past 2 years, how many just before pregnancy
raw_dat$smoking_amount_prepreg_mum[raw_dat$smoking_amount_prepreg_mum<0]<-NA
raw_dat$smoking_amount_prepreg_mum[raw_dat$amsmty00==2]<-0
raw_dat$smoking_amount_prepreg_mum[raw_dat$amsmus0a==1|raw_dat$amsmus0b==1|raw_dat$amsmus0c==1]<-0

raw_dat$smoking_amount_afterchange_mum <- raw_dat$amcich00# how many cigs per day after changed during pregnancy
raw_dat$smoking_amount_afterchange_mum[raw_dat$smoking_amount_afterchange_mum<0]<-NA
raw_dat$smoking_amount_afterchange_mum[raw_dat$smoking_amount_afterchange_mum==97]<-NA # can't remember
raw_dat$smoking_amount_afterchange_mum[raw_dat$smoking_amount_afterchange_mum==96]<-1 # less than 1 per day
raw_dat$smoking_amount_afterchange_mum[raw_dat$smoking_amount_prepreg_mum==0]<-0 #wasn't smoking before pregnancy
raw_dat$smoking_amount_afterchange_mum[raw_dat$amsmch00==2] <- raw_dat$smoking_amount_prepreg_mum[raw_dat$amsmch00==2]#didn't change the amount they smoked

raw_dat$smoking_amount_firsttrim_mum <- raw_dat$smoking_amount_prepreg_mum
raw_dat$smoking_amount_firsttrim_mum[raw_dat$amwhch00%in%c(1,2,3)] <-raw_dat$smoking_amount_afterchange_mum[raw_dat$amwhch00%in%c(1,2,3)]

raw_dat$smoking_amount_secondtrim_mum <- raw_dat$smoking_amount_firsttrim_mum
raw_dat$smoking_amount_secondtrim_mum[raw_dat$amwhch00%in%c(4,5,6)] <-raw_dat$smoking_amount_afterchange_mum[raw_dat$amwhch00%in%c(4,5,6)]

raw_dat$smoking_amount_thirdtrim_mum <- raw_dat$smoking_amount_secondtrim_mum
raw_dat$smoking_amount_thirdtrim_mum[raw_dat$amwhch00%in%c(7,8,9)] <-raw_dat$smoking_amount_afterchange_mum[raw_dat$amwhch00%in%c(7,8,9)]





# Timing specific smoking
raw_dat$smoking_amount_now_dad <-raw_dat$apsmma00 #if smokes cigs or roll-ups now, how many per day?
raw_dat$smoking_amount_now_dad[raw_dat$smoking_amount_now_dad<0]<-NA
raw_dat$smoking_amount_now_dad[raw_dat$apsmus0a==1|raw_dat$apsmus0b==1|raw_dat$apsmus0c==1|raw_dat$apsmus0d==1] <- 0 #doesn't smoke now

raw_dat$smoking_amount_prepreg_dad <- raw_dat$apcipr00 #if smokes now or has in the past 2 years, how many just before pregnancy
raw_dat$smoking_amount_prepreg_dad[raw_dat$smoking_amount_prepreg_dad<0]<-NA
raw_dat$smoking_amount_prepreg_dad[raw_dat$apsmty00==2]<-0
raw_dat$smoking_amount_prepreg_dad[raw_dat$apsmus0a==1|raw_dat$apsmus0b==1|raw_dat$apsmus0c==1|raw_dat$apsmus0d==1]<-0

raw_dat$smoking_amount_afterchange_dad <- raw_dat$apcich00# how many cigs per day after changed during pregnancy
raw_dat$smoking_amount_afterchange_dad[raw_dat$smoking_amount_afterchange_dad<0]<-NA
raw_dat$smoking_amount_afterchange_dad[raw_dat$smoking_amount_afterchange_dad==97]<-NA # can't remember
raw_dat$smoking_amount_afterchange_dad[raw_dat$smoking_amount_afterchange_dad==96]<-1 # less than 1 per day
raw_dat$smoking_amount_afterchange_dad[raw_dat$smoking_amount_prepreg_dad==0]<-0 #wasn't smoking before pregnancy
raw_dat$smoking_amount_afterchange_dad[raw_dat$apsmch00==2] <- raw_dat$smoking_amount_prepreg_dad[raw_dat$apsmch00==2]#didn't change the amount they smoked

raw_dat$smoking_amount_firsttrim_dad <- raw_dat$smoking_amount_prepreg_dad
raw_dat$smoking_amount_firsttrim_dad[raw_dat$apwhch00%in%c(1,2,3)] <-raw_dat$smoking_amount_afterchange_dad[raw_dat$apwhch00%in%c(1,2,3)]

raw_dat$smoking_amount_secondtrim_dad <- raw_dat$smoking_amount_firsttrim_dad
raw_dat$smoking_amount_secondtrim_dad[raw_dat$apwhch00%in%c(4,5,6)] <-raw_dat$smoking_amount_afterchange_dad[raw_dat$apwhch00%in%c(4,5,6)]

raw_dat$smoking_amount_thirdtrim_dad <- raw_dat$smoking_amount_secondtrim_dad
raw_dat$smoking_amount_thirdtrim_dad[raw_dat$apwhch00%in%c(7,8,9)] <-raw_dat$smoking_amount_afterchange_dad[raw_dat$apwhch00%in%c(7,8,9)]




#Ever regular smoker
#SMUS: what type smoked NOW, can provide up to 5 response (SMUS0a, SMUS0b etc)

dat$smoking_mother_ever_life_binary <- NA
dat$smoking_mother_ever_life_binary[raw_dat$amsmus0a%in%c(2,3)|raw_dat$amsmus0b%in%c(2,3)|raw_dat$amsmus0c%in%c(2,3)] <- 1 # current smoker (cigarettes or roll-ups)
dat$smoking_mother_ever_life_binary[raw_dat$amsmus0a==1|raw_dat$amsmus0b==1|raw_dat$amsmus0c==1] <- 0 #not current smoker
dat$smoking_mother_ever_life_binary[raw_dat$amsmty00==1] <-1 # if not current smoker, smoked in past 2 years?
dat$smoking_mother_ever_life_binary[raw_dat$amsmev00==1] <-1# if not smoked in past 2 yrs, ever smoked regularly for 12 months or more?

# Preconception
dat$smoking_mother_preconception_binary <- NA
dat$smoking_mother_preconception_binary[raw_dat$smoking_amount_prepreg_mum==0]<-0
dat$smoking_mother_preconception_binary[raw_dat$smoking_amount_prepreg_mum>0]<-1

dat$smoking_mother_preconception_ordinal <- NA
dat$smoking_mother_preconception_ordinal[raw_dat$smoking_amount_prepreg_mum==0]<-"None"
dat$smoking_mother_preconception_ordinal[raw_dat$smoking_amount_prepreg_mum>0 & raw_dat$smoking_amount_prepreg_mum<10]<-"Light" #i.e. <10 but not 0
dat$smoking_mother_preconception_ordinal[raw_dat$smoking_amount_prepreg_mum>=10 & raw_dat$smoking_amount_prepreg_mum<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_mother_preconception_ordinal[raw_dat$smoking_amount_prepreg_mum>=20]<-"Heavy" #i.e.>=20
dat$smoking_mother_preconception_ordinal<-factor(dat$smoking_mother_preconception_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# First trimester
dat$smoking_mother_firsttrim_binary <- NA
dat$smoking_mother_firsttrim_binary[raw_dat$smoking_amount_firsttrim_mum==0]<-0
dat$smoking_mother_firsttrim_binary[raw_dat$smoking_amount_firsttrim_mum>0]<-1

dat$smoking_mother_firsttrim_ordinal <- NA
dat$smoking_mother_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_mum==0]<-"None"
dat$smoking_mother_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_mum>0 & raw_dat$smoking_amount_firsttrim_mum<10]<-"Light" #i.e. <10 but not 0
dat$smoking_mother_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_mum>=10 & raw_dat$smoking_amount_firsttrim_mum<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_mother_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_mum>=20]<-"Heavy" #i.e.>=20
dat$smoking_mother_firsttrim_ordinal<-factor(dat$smoking_mother_firsttrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# Second trimester
dat$smoking_mother_secondtrim_binary <- NA
dat$smoking_mother_secondtrim_binary[raw_dat$smoking_amount_secondtrim_mum==0]<-0
dat$smoking_mother_secondtrim_binary[raw_dat$smoking_amount_secondtrim_mum>0]<-1

dat$smoking_mother_secondtrim_ordinal <- NA
dat$smoking_mother_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_mum==0]<-"None"
dat$smoking_mother_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_mum>0 & raw_dat$smoking_amount_secondtrim_mum<10]<-"Light" #i.e. <10 but not 0
dat$smoking_mother_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_mum>=10 & raw_dat$smoking_amount_secondtrim_mum<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_mother_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_mum>=20]<-"Heavy" #i.e.>=20
dat$smoking_mother_secondtrim_ordinal<-factor(dat$smoking_mother_secondtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# Third trimester
dat$smoking_mother_thirdtrim_binary <- NA
dat$smoking_mother_thirdtrim_binary[raw_dat$smoking_amount_thirdtrim_mum==0]<-0
dat$smoking_mother_thirdtrim_binary[raw_dat$smoking_amount_thirdtrim_mum>0]<-1

dat$smoking_mother_thirdtrim_ordinal <- NA
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_mum==0]<-"None"
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_mum>0 & raw_dat$smoking_amount_thirdtrim_mum<10]<-"Light" #i.e. <10 but not 0
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_mum>=10 & raw_dat$smoking_amount_thirdtrim_mum<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_mum>=20]<-"Heavy" #i.e.>=20
dat$smoking_mother_thirdtrim_ordinal<-factor(dat$smoking_mother_thirdtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# Any time in pregnancy
dat$smoking_mother_ever_pregnancy_binary<-NA
dat$smoking_mother_ever_pregnancy_binary[dat$smoking_mother_firsttrim_binary==0 & dat$smoking_mother_secondtrim_binary==0 &dat$smoking_mother_thirdtrim_binary==0] <- 0
dat$smoking_mother_ever_pregnancy_binary[dat$smoking_mother_firsttrim_binary==1 | dat$smoking_mother_secondtrim_binary==1 | dat$smoking_mother_thirdtrim_binary==1] <- 1

# Postnatal
dat$smoking_mother_postnatal_binary <- NA
dat$smoking_mother_postnatal_binary[raw_dat$smoking_amount_now_mum==0]<-0
dat$smoking_mother_postnatal_binary[raw_dat$smoking_amount_now_mum>0]<-1

dat$smoking_mother_postnatal_ordinal <- NA
dat$smoking_mother_postnatal_ordinal[raw_dat$smoking_amount_now_mum==0]<-"None"
dat$smoking_mother_postnatal_ordinal[raw_dat$smoking_amount_now_mum>0 & raw_dat$smoking_amount_now_mum<10]<-"Light" #i.e. <10 but not 0
dat$smoking_mother_postnatal_ordinal[raw_dat$smoking_amount_now_mum>=10 & raw_dat$smoking_amount_now_mum<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_mother_postnatal_ordinal[raw_dat$smoking_amount_now_mum>=20]<-"Heavy" #i.e.>=20
dat$smoking_mother_postnatal_ordinal<-factor(dat$smoking_mother_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)




#Ever regular smoker
#SMUS: what type smoked NOW, can provide up to 5 response (SMUS0a, SMUS0b etc)

dat$smoking_father_ever_life_binary <- NA
dat$smoking_father_ever_life_binary[raw_dat$apsmus0a%in%c(2,3)|raw_dat$apsmus0b%in%c(2,3)|raw_dat$apsmus0c%in%c(2,3)|raw_dat$apsmus0d%in%c(2,3)] <- 1 # current smoker (cigarettes or roll-ups)
dat$smoking_father_ever_life_binary[raw_dat$apsmus0a==1|raw_dat$apsmus0b==1|raw_dat$apsmus0c==1|raw_dat$apsmus0d==1] <- 0 #not current smoker
dat$smoking_father_ever_life_binary[raw_dat$apsmty00==1] <-1 # if not current smoker, smoked in past 2 years?
dat$smoking_father_ever_life_binary[raw_dat$apsmev00==1] <-1# if not smoked in past 2 yrs, ever smoked regularly for 12 months or more?

# Preconception
dat$smoking_father_preconception_binary <- NA
dat$smoking_father_preconception_binary[raw_dat$smoking_amount_prepreg_dad==0]<-0
dat$smoking_father_preconception_binary[raw_dat$smoking_amount_prepreg_dad>0]<-1

dat$smoking_father_preconception_ordinal <- NA
dat$smoking_father_preconception_ordinal[raw_dat$smoking_amount_prepreg_dad==0]<-"None"
dat$smoking_father_preconception_ordinal[raw_dat$smoking_amount_prepreg_dad>0 & raw_dat$smoking_amount_prepreg_dad<10]<-"Light" #i.e. <10 but not 0
dat$smoking_father_preconception_ordinal[raw_dat$smoking_amount_prepreg_dad>=10 & raw_dat$smoking_amount_prepreg_dad<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_father_preconception_ordinal[raw_dat$smoking_amount_prepreg_dad>=20]<-"Heavy" #i.e.>=20
dat$smoking_father_preconception_ordinal<-factor(dat$smoking_father_preconception_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# First trimester
dat$smoking_father_firsttrim_binary <- NA
dat$smoking_father_firsttrim_binary[raw_dat$smoking_amount_firsttrim_dad==0]<-0
dat$smoking_father_firsttrim_binary[raw_dat$smoking_amount_firsttrim_dad>0]<-1

dat$smoking_father_firsttrim_ordinal <- NA
dat$smoking_father_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_dad==0]<-"None"
dat$smoking_father_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_dad>0 & raw_dat$smoking_amount_firsttrim_dad<10]<-"Light" #i.e. <10 but not 0
dat$smoking_father_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_dad>=10 & raw_dat$smoking_amount_firsttrim_dad<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_father_firsttrim_ordinal[raw_dat$smoking_amount_firsttrim_dad>=20]<-"Heavy" #i.e.>=20
dat$smoking_father_firsttrim_ordinal<-factor(dat$smoking_father_firsttrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# Second trimester
dat$smoking_father_secondtrim_binary <- NA
dat$smoking_father_secondtrim_binary[raw_dat$smoking_amount_secondtrim_dad==0]<-0
dat$smoking_father_secondtrim_binary[raw_dat$smoking_amount_secondtrim_dad>0]<-1

dat$smoking_father_secondtrim_ordinal <- NA
dat$smoking_father_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_dad==0]<-"None"
dat$smoking_father_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_dad>0 & raw_dat$smoking_amount_secondtrim_dad<10]<-"Light" #i.e. <10 but not 0
dat$smoking_father_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_dad>=10 & raw_dat$smoking_amount_secondtrim_dad<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_father_secondtrim_ordinal[raw_dat$smoking_amount_secondtrim_dad>=20]<-"Heavy" #i.e.>=20
dat$smoking_father_secondtrim_ordinal<-factor(dat$smoking_father_secondtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# Third trimester
dat$smoking_father_thirdtrim_binary <- NA
dat$smoking_father_thirdtrim_binary[raw_dat$smoking_amount_thirdtrim_dad==0]<-0
dat$smoking_father_thirdtrim_binary[raw_dat$smoking_amount_thirdtrim_dad>0]<-1

dat$smoking_father_thirdtrim_ordinal <- NA
dat$smoking_father_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_dad==0]<-"None"
dat$smoking_father_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_dad>0 & raw_dat$smoking_amount_thirdtrim_dad<10]<-"Light" #i.e. <10 but not 0
dat$smoking_father_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_dad>=10 & raw_dat$smoking_amount_thirdtrim_dad<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_father_thirdtrim_ordinal[raw_dat$smoking_amount_thirdtrim_dad>=20]<-"Heavy" #i.e.>=20
dat$smoking_father_thirdtrim_ordinal<-factor(dat$smoking_father_thirdtrim_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)

# Any time in pregnancy
dat$smoking_father_ever_pregnancy_binary<-NA
dat$smoking_father_ever_pregnancy_binary[dat$smoking_father_firsttrim_binary==0 & dat$smoking_father_secondtrim_binary==0 &dat$smoking_father_thirdtrim_binary==0] <- 0
dat$smoking_father_ever_pregnancy_binary[dat$smoking_father_firsttrim_binary==1 | dat$smoking_father_secondtrim_binary==1 | dat$smoking_father_thirdtrim_binary==1] <- 1

# Postnatal
dat$smoking_father_postnatal_binary <- NA
dat$smoking_father_postnatal_binary[raw_dat$smoking_amount_now_dad==0]<-0
dat$smoking_father_postnatal_binary[raw_dat$smoking_amount_now_dad>0]<-1

dat$smoking_father_postnatal_ordinal <- NA
dat$smoking_father_postnatal_ordinal[raw_dat$smoking_amount_now_dad==0]<-"None"
dat$smoking_father_postnatal_ordinal[raw_dat$smoking_amount_now_dad>0 & raw_dat$smoking_amount_now_dad<10]<-"Light" #i.e. <10 but not 0
dat$smoking_father_postnatal_ordinal[raw_dat$smoking_amount_now_dad>=10 & raw_dat$smoking_amount_now_dad<20]<-"Moderate" #i.e. <20, >=10
dat$smoking_father_postnatal_ordinal[raw_dat$smoking_amount_now_dad>=20]<-"Heavy" #i.e.>=20
dat$smoking_father_postnatal_ordinal<-factor(dat$smoking_father_postnatal_ordinal,levels=c("None","Light","Moderate","Heavy"),ordered=T)





#During pregnancy
raw_dat$alcohol_preg_mother <- raw_dat$amdrof00 # Which of these best describes how often you usually drank alcohol when pregnant?
#1 Every day
#2 5-6 times per week
#3 3-4 times per week
#4 1-2 times per week
#5 1-2 times per month
#6 Less than once a month
#7 Never

dat$alcohol_mother_ever_pregnancy_binary <-NA
dat$alcohol_mother_ever_pregnancy_binary[raw_dat$alcohol_preg_mother==7]<-0
dat$alcohol_mother_ever_pregnancy_binary[raw_dat$alcohol_preg_mother %in% c(1,2,3,4,5,6)]<-1

dat$alcohol_mother_ever_pregnancy_ordinal <- NA
dat$alcohol_mother_ever_pregnancy_ordinal[raw_dat$alcohol_preg_mother==7]<-"None"
dat$alcohol_mother_ever_pregnancy_ordinal[raw_dat$alcohol_preg_mother%in%c(5,6)]<-"Light" # <1glass per week
dat$alcohol_mother_ever_pregnancy_ordinal[raw_dat$alcohol_preg_mother%in%c(2,3,4)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_mother_ever_pregnancy_ordinal[raw_dat$alcohol_preg_mother==1]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_mother_ever_pregnancy_ordinal<-factor(dat$alcohol_mother_ever_pregnancy_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)


#Now (postnatal)
raw_dat$alcohol_now_mother <- raw_dat$amaldr00 # Which of these best describes how often you usually drink alcohol?
#1 Every day
#2 5-6 times per week
#3 3-4 times per week
#4 1-2 times per week
#5 1-2 times per month
#6 Less than once a month
#7 Never

dat$alcohol_mother_postnatal_binary <-NA
dat$alcohol_mother_postnatal_binary[raw_dat$alcohol_now_mother==7]<-0
dat$alcohol_mother_postnatal_binary[raw_dat$alcohol_now_mother %in% c(1,2,3,4,5,6)]<-1

dat$alcohol_mother_postnatal_ordinal <- NA
dat$alcohol_mother_postnatal_ordinal[raw_dat$alcohol_now_mother==7]<-"None"
dat$alcohol_mother_postnatal_ordinal[raw_dat$alcohol_now_mother%in%c(5,6)]<-"Light" # <1glass per week
dat$alcohol_mother_postnatal_ordinal[raw_dat$alcohol_now_mother%in%c(2,3,4)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_mother_postnatal_ordinal[raw_dat$alcohol_now_mother==1]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_mother_postnatal_ordinal<-factor(dat$alcohol_mother_postnatal_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)





#Now (postnatal)
raw_dat$alcohol_now_father <- raw_dat$apaldr00 # Which of these best describes how often you usually drink alcohol?
#1 Every day
#2 5-6 times per week
#3 3-4 times per week
#4 1-2 times per week
#5 1-2 times per month
#6 Less than once a month
#7 Never

dat$alcohol_father_postnatal_binary <-NA
dat$alcohol_father_postnatal_binary[raw_dat$alcohol_now_father==7]<-0
dat$alcohol_father_postnatal_binary[raw_dat$alcohol_now_father %in% c(1,2,3,4,5,6)]<-1

dat$alcohol_father_postnatal_ordinal <- NA
dat$alcohol_father_postnatal_ordinal[raw_dat$alcohol_now_father==7]<-"None"
dat$alcohol_father_postnatal_ordinal[raw_dat$alcohol_now_father%in%c(5,6)]<-"Light" # <1glass per week
dat$alcohol_father_postnatal_ordinal[raw_dat$alcohol_now_father%in%c(2,3,4)]<-"Moderate" #1+glasses pwk, but not daily
dat$alcohol_father_postnatal_ordinal[raw_dat$alcohol_now_father==1]<-"Heavy" #daily drinking, 1-2pd, 3-9pd, 10+pd
dat$alcohol_father_postnatal_ordinal<-factor(dat$alcohol_father_postnatal_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)






# Birthweight (g)
dat$anthro_birthweight <- raw_dat$adbwgta0 #bw in kg
dat$anthro_birthweight[raw_dat$adbwgta0<0]<-NA
dat$anthro_birthweight <-dat$anthro_birthweight*1000
dat$anthro_birthweight_zscore <-scale(dat$anthro_birthweight)

dat$anthro_birthweight_high_binary <- NA
dat$anthro_birthweight_high_binary[dat$anthro_birthweight>4500]<-1
dat$anthro_birthweight_high_binary[dat$anthro_birthweight>=2500&dat$anthro_birthweight<=4500]<-0

dat$anthro_birthweight_low_binary <- NA
dat$anthro_birthweight_low_binary[dat$anthro_birthweight<2500]<-1
dat$anthro_birthweight_low_binary[dat$anthro_birthweight>=2500&dat$anthro_birthweight<=4500]<-0

#SGA
#LGA

#Birth length (cm) - not available
#Waist circumference (cm)

raw_dat$waist_measurement_1 <- raw_dat$cywsma00
raw_dat$waist_measurement_1[raw_dat$waist_measurement_1<0]<-NA
raw_dat$waist_measurement_2 <- raw_dat$cywsmb00
raw_dat$waist_measurement_2[raw_dat$waist_measurement_2<0]<-NA
raw_dat$waist_measurement_3 <- raw_dat$cywsmc00
raw_dat$waist_measurement_3[raw_dat$waist_measurement_3<0]<-NA

dat$anthro_waist_stage3 <- rowMeans(raw_dat[,c("waist_measurement_1","waist_measurement_2","waist_measurement_3")],na.rm = T)
dat$anthro_waist_stage3_zscore <- scale(dat$anthro_waist_stage3)

#Head circumference (cm) - not available

#Height (cm)

dat$anthro_height_stage2 <- raw_dat$bdhcmc00
dat$anthro_height_stage2[dat$anthro_height_stage2<0]<-NA
dat$anthro_height_stage2_zscore <- scale(dat$anthro_height_stage2)

dat$anthro_height_stage3 <- raw_dat$cyhtcm00
dat$anthro_height_stage3[dat$anthro_height_stage3<0]<-NA
dat$anthro_height_stage3_zscore <- scale(dat$anthro_height_stage3)

dat$anthro_height_stage4 <- raw_dat$echtcma0
dat$anthro_height_stage4[dat$anthro_height_stage4<0]<-NA
dat$anthro_height_stage4_zscore <- scale(dat$anthro_height_stage4)

#Weight (kg)

dat$anthro_weight_stage0 <- raw_dat$adlstwa0
dat$anthro_weight_stage0[dat$anthro_weight_stage0<0]<-NA
dat$anthro_weight_stage0_zscore <- scale(dat$anthro_weight_stage0)

dat$anthro_weight_stage2 <- raw_dat$bdwtkc00 + (raw_dat$bdwtgc00/10) # kg + g
dat$anthro_weight_stage2[dat$anthro_weight_stage2<0]<-NA
dat$anthro_weight_stage2_zscore <- scale(dat$anthro_weight_stage2)

dat$anthro_weight_stage3 <- raw_dat$cywtcm00
dat$anthro_weight_stage3[dat$anthro_weight_stage3<0]<-NA
dat$anthro_weight_stage3_zscore <- scale(dat$anthro_weight_stage3)


dat$anthro_weight_stage4 <- raw_dat$ecwtcma0
dat$anthro_weight_stage4[dat$anthro_weight_stage4<0]<-NA
dat$anthro_weight_stage4_zscore <- scale(dat$anthro_weight_stage4)


#BMI and WHO categories of overweight/obese/underweight vs normal weight

dat$anthro_bmi_stage2 <- dat$anthro_weight_stage2 / ((dat$anthro_height_stage2/100)^2)
dat$anthro_bmi_stage3 <- dat$anthro_weight_stage3 / ((dat$anthro_height_stage3/100)^2)
dat$anthro_bmi_stage4 <- dat$anthro_weight_stage4 / ((dat$anthro_height_stage4/100)^2)

dat$anthro_bmi_stage2_zscore <- scale(dat$anthro_bmi_stage2)
dat$anthro_bmi_stage3_zscore <- scale(dat$anthro_bmi_stage3)
dat$anthro_bmi_stage4_zscore <- scale(dat$anthro_bmi_stage4)

# (first need to derive age at each stage/sweep):

dat$covs_age_child_stage0wt <- raw_dat$adaglwa0 # age when weight measurement taken
dat$covs_age_child_stage0wt[dat$covs_age_child_stage0wt<0]<-NA

dat$covs_age_child_stage0 <- raw_dat$ahbage00 #age at interview
dat$covs_age_child_stage0[dat$covs_age_child_stage0<0]<-NA

dat$covs_age_child_stage2 <- raw_dat$bhcagea0
dat$covs_age_child_stage2[dat$covs_age_child_stage2<0]<-NA
dat$covs_age_child_stage2 <- dat$covs_age_child_stage2/365.25

dat$covs_age_child_stage3c <- raw_dat$chcagea0
dat$covs_age_child_stage3c[dat$covs_age_child_stage3c<0]<-NA
dat$covs_age_child_stage3c <- dat$covs_age_child_stage3c/365.25

dat$covs_age_child_stage3d <- raw_dat$dhcagea0
dat$covs_age_child_stage3d[dat$covs_age_child_stage3d<0]<-NA
dat$covs_age_child_stage3d <- dat$covs_age_child_stage3d/365.25

dat$covs_age_child_stage4 <- raw_dat$emcs5age
dat$covs_age_child_stage4[dat$covs_age_child_stage4<0]<-NA

dat$covs_sex <- NA
dat$covs_sex[raw_dat$ahcsexa0==1]<-"male"
dat$covs_sex[raw_dat$ahcsexa0==2]<-"female"

library(childsds)

dat$anthro_bmi_stage2_sds <- sds(value = dat$anthro_bmi_stage2,
		      age = dat$covs_age_child_stage2,
		      sex = dat$covs_sex, male = "male", female = "female",
		      ref = ukwho.ref, item = "bmi")
dat$anthro_bmi_stage2_sds[dat$anthro_bmi_stage2_sds=="Inf"]<-NA # Think 33 come out as Inf maybe because age is not normally distributed? (only thing I can think of...)

dat$anthro_bmi_stage3_sds <- sds(value = dat$anthro_bmi_stage3,
		      age = dat$covs_age_child_stage3c,
		      sex = dat$covs_sex, male = "male", female = "female",
		      ref = ukwho.ref, item = "bmi")

dat$anthro_bmi_stage4_sds <- sds(value = dat$anthro_bmi_stage4,
		      age = dat$covs_age_child_stage4,
		      sex = dat$covs_sex, male = "male", female = "female",
		      ref = ukwho.ref, item = "bmi")

dat$anthro_obese_stage2_binary <- NA
dat$anthro_obese_stage2_binary[which(dat$anthro_bmi_stage2_sds>2)] <-1
dat$anthro_obese_stage2_binary[which(dat$anthro_bmi_stage2_sds<=1 &dat$anthro_bmi_stage2_sds>=(-2))] <-0

dat$anthro_obese_stage3_binary <- NA
dat$anthro_obese_stage3_binary[which(dat$anthro_bmi_stage3_sds>2)] <-1
dat$anthro_obese_stage3_binary[which(dat$anthro_bmi_stage3_sds<=1 &dat$anthro_bmi_stage3_sds>=(-2))] <-0

dat$anthro_obese_stage4_binary <- NA
dat$anthro_obese_stage4_binary[which(dat$anthro_bmi_stage4_sds>2)] <-1
dat$anthro_obese_stage4_binary[which(dat$anthro_bmi_stage4_sds<=1 &dat$anthro_bmi_stage4_sds>=(-2))] <-0

#Body fat PERCENT (note, not fat mass index)

dat$anthro_fatpc_stage4 <- raw_dat$ecbfpc00
dat$anthro_fatpc_stage4[dat$anthro_fatpc_stage4<0]<-NA
dat$anthro_fatpc_stage4_zscore <- scale(dat$anthro_fatpc_stage4)






#Total behavioural difficulties (SDQ) - maternal report, continuous and dichotomised at >=17 [this is a combination of 4 subscales - excluding prosocial behaviour]
#Stage 2
dat$neuro_totalsdq_stage2<-raw_dat$bdebdta0
dat$neuro_totalsdq_stage2[raw_dat$bdebdta0<0]<-NA
dat$neuro_totalsdq_stage2_zscore <- scale(dat$neuro_totalsdq_stage2)
dat$neuro_totalsdq_stage2_binary <- NA
dat$neuro_totalsdq_stage2_binary[dat$neuro_totalsdq_stage2>=17]<-1
dat$neuro_totalsdq_stage2_binary[dat$neuro_totalsdq_stage2<17]<-0

#Stage 3
dat$neuro_totalsdq_stage3<-raw_dat$ddebdta0
dat$neuro_totalsdq_stage3[raw_dat$ddebdta0<0]<-NA
dat$neuro_totalsdq_stage3_zscore <- scale(dat$neuro_totalsdq_stage3)
dat$neuro_totalsdq_stage3_binary <- NA
dat$neuro_totalsdq_stage3_binary[dat$neuro_totalsdq_stage3>=17]<-1
dat$neuro_totalsdq_stage3_binary[dat$neuro_totalsdq_stage3<17]<-0

#Hyperactivity (SDQ) - maternal report, continuous and dichotomised at >=7
#Stage 2
dat$neuro_hyperactivity_stage2<-raw_dat$bdhypea0
dat$neuro_hyperactivity_stage2[raw_dat$bdhypea0<0]<-NA
dat$neuro_hyperactivity_stage2_zscore <- scale(dat$neuro_hyperactivity_stage2)
dat$neuro_hyperactivity_stage2_binary <- NA
dat$neuro_hyperactivity_stage2_binary[dat$neuro_hyperactivity_stage2>=7]<-1
dat$neuro_hyperactivity_stage2_binary[dat$neuro_hyperactivity_stage2<7]<-0
#Stage 3
dat$neuro_hyperactivity_stage3<-raw_dat$ddhypea0
dat$neuro_hyperactivity_stage3[raw_dat$ddhypea0<0]<-NA
dat$neuro_hyperactivity_stage3_zscore <- scale(dat$neuro_hyperactivity_stage3)
dat$neuro_hyperactivity_stage3_binary <- NA
dat$neuro_hyperactivity_stage3_binary[dat$neuro_hyperactivity_stage3>=7]<-1
dat$neuro_hyperactivity_stage3_binary[dat$neuro_hyperactivity_stage3<7]<-0

#Emotional symptoms (SDQ) - maternal report, continuous and dichotomised at >=5
#Stage 2
dat$neuro_emotional_stage2<-raw_dat$bdemota0
dat$neuro_emotional_stage2[raw_dat$bdemota0<0]<-NA
dat$neuro_emotional_stage2_zscore <- scale(dat$neuro_emotional_stage2)
dat$neuro_emotional_stage2_binary <- NA
dat$neuro_emotional_stage2_binary[dat$neuro_emotional_stage2>=5]<-1
dat$neuro_emotional_stage2_binary[dat$neuro_emotional_stage2<5]<-0
#Stage 3
dat$neuro_emotional_stage3<-raw_dat$ddemota0
dat$neuro_emotional_stage3[raw_dat$ddemota0<0]<-NA
dat$neuro_emotional_stage3_zscore <- scale(dat$neuro_emotional_stage3)
dat$neuro_emotional_stage3_binary <- NA
dat$neuro_emotional_stage3_binary[dat$neuro_emotional_stage3>=5]<-1
dat$neuro_emotional_stage3_binary[dat$neuro_emotional_stage3<5]<-0

#Conduct problems (SDQ) - maternal report, continuous and dichotomised at >=4
#Stage 2
dat$neuro_conduct_stage2<-raw_dat$bdconda0
dat$neuro_conduct_stage2[raw_dat$bdconda0<0]<-NA
dat$neuro_conduct_stage2_zscore <- scale(dat$neuro_conduct_stage2)
dat$neuro_conduct_stage2_binary <- NA
dat$neuro_conduct_stage2_binary[dat$neuro_conduct_stage2>=4]<-1
dat$neuro_conduct_stage2_binary[dat$neuro_conduct_stage2<4]<-0
#Stage 3
dat$neuro_conduct_stage3<-raw_dat$ddconda0
dat$neuro_conduct_stage3[raw_dat$ddconda0<0]<-NA
dat$neuro_conduct_stage3_zscore <- scale(dat$neuro_conduct_stage3)
dat$neuro_conduct_stage3_binary <- NA
dat$neuro_conduct_stage3_binary[dat$neuro_conduct_stage3>=4]<-1
dat$neuro_conduct_stage3_binary[dat$neuro_conduct_stage3<4]<-0

#Peer problems (SDQ) - maternal report, continuous and dichotomised at >=4
#Stage 2
dat$neuro_peer_stage2<-raw_dat$bdpeera0
dat$neuro_peer_stage2[raw_dat$bdpeera0<0]<-NA
dat$neuro_peer_stage2_zscore <- scale(dat$neuro_peer_stage2)
dat$neuro_peer_stage2_binary <- NA
dat$neuro_peer_stage2_binary[dat$neuro_peer_stage2>=4]<-1
dat$neuro_peer_stage2_binary[dat$neuro_peer_stage2<4]<-0
#Stage 3
dat$neuro_peer_stage3<-raw_dat$ddpeera0
dat$neuro_peer_stage3[raw_dat$ddpeera0<0]<-NA
dat$neuro_peer_stage3_zscore <- scale(dat$neuro_peer_stage3)
dat$neuro_peer_stage3_binary <- NA
dat$neuro_peer_stage3_binary[dat$neuro_peer_stage3>=4]<-1
dat$neuro_peer_stage3_binary[dat$neuro_peer_stage3<4]<-0

#Prosocial behaviour (SDQ) - maternal report, continuous and dichotomised at <=6
#Stage 2
dat$neuro_prosocial_stage2<-raw_dat$bdprosa0
dat$neuro_prosocial_stage2[raw_dat$bdprosa0<0]<-NA
dat$neuro_prosocial_stage2_zscore <- scale(dat$neuro_prosocial_stage2)
dat$neuro_prosocial_stage2_binary <- NA
dat$neuro_prosocial_stage2_binary[dat$neuro_prosocial_stage2<=6]<-1
dat$neuro_prosocial_stage2_binary[dat$neuro_prosocial_stage2>6]<-0
#Stage 3
dat$neuro_prosocial_stage3<-raw_dat$ddprosa0
dat$neuro_prosocial_stage3[raw_dat$ddprosa0<0]<-NA
dat$neuro_prosocial_stage3_zscore <- scale(dat$neuro_prosocial_stage3)
dat$neuro_prosocial_stage3_binary <- NA
dat$neuro_prosocial_stage3_binary[dat$neuro_prosocial_stage3<=6]<-1
dat$neuro_prosocial_stage3_binary[dat$neuro_prosocial_stage3>6]<-0

#Internalising problems (SDQ) - maternal report, combination of emotional symptoms and peer problems
#Stage 2
dat$neuro_internalising_stage2 <- rowSums(dat[,c("neuro_emotional_stage2","neuro_peer_stage2")])
dat$neuro_internalising_stage2_zscore <- scale(dat$neuro_internalising_stage2)

#Stage 3
dat$neuro_internalising_stage3 <- rowSums(dat[,c("neuro_emotional_stage3","neuro_peer_stage3")])
dat$neuro_internalising_stage3_zscore <- scale(dat$neuro_internalising_stage3)

#Externalising problems (SDQ) - maternal report, combination of hyperactivity and conduct problems
#Stage 2
dat$neuro_externalising_stage2 <- rowSums(dat[,c("neuro_emotional_stage2","neuro_peer_stage2")])
dat$neuro_externalising_stage2_zscore <- scale(dat$neuro_externalising_stage2)
#Stage 3
dat$neuro_externalising_stage3 <- rowSums(dat[,c("neuro_hyperactivity_stage3","neuro_conduct_stage3")])
dat$neuro_externalising_stage3_zscore <- scale(dat$neuro_externalising_stage3)

#SCDC (Skuse Social Communication Score) - not available, but CSBQ Child Social Behaviour Questionnaire is available - is this comparable?

dat$neuro_csbqindependence_stage3 <- raw_dat$cdcsbia0
dat$neuro_csbqindependence_stage3[dat$neuro_csbqindependence_stage3<0]<-NA
dat$neuro_csbqindependence_stage3_zscore <- scale(dat$neuro_csbqindependence_stage3)

dat$neuro_csbqemotionaldysreg_stage3 <- raw_dat$cdcsbea0
dat$neuro_csbqemotionaldysreg_stage3[dat$neuro_csbqemotionaldysreg_stage3<0]<-NA
dat$neuro_csbqemotionaldysreg_stage3_zscore <- scale(dat$neuro_csbqemotionaldysreg_stage3)

#Depressive symptoms (Moods and Feelings questionnaire - MFQ) - not available

#IQ and/or other or composite measures of intelligence/cognitive performance
# using the British Ability Scales (BAS):
#The British Ability Scales (BAS) is a battery of individually administered tests of
#cognitive abilities and educational achievements suitable for use with children and
#adolescents aged from 2 years 6 months to 7 years 11 months.

#The Naming Vocabulary is a verbal scale for children aged 2 years 6 months to 7
#years 11 months. It assesses the spoken vocabulary of young children.
#Naming Vocabulary scores may reflect:
# Expressive language skills
# Vocabulary knowledge of nouns
# Ability to attach verbal labels to pictures
# General knowledge
# General language development
# Retrieval of names from long-term memory
# Level of language stimulation.

dat$neuro_cognition_namingvocab_stage3 <- raw_dat$cdnvabil
dat$neuro_cognition_namingvocab_stage3[raw_dat$neuro_cognition_namingvocab_stage3<0]<-NA
dat$neuro_cognition_namingvocab_stage3_zscore <- scale(dat$neuro_cognition_namingvocab_stage3)

dat$neuro_cognition_namingvocab_stage2 <- raw_dat$bdbasa00
dat$neuro_cognition_namingvocab_stage2[raw_dat$neuro_cognition_namingvocab_stage2<0]<-NA
dat$neuro_cognition_namingvocab_stage2_zscore <- scale(dat$neuro_cognition_namingvocab_stage2)

# ability score for pattern construction (british ability score)
#The child constructs a design by putting together flat squares or solid cubes with
#black and yellow patterns on each side. The child’s score is based on accuracy and
#speed. This assessment tests spatial awareness but can also be used to observe
#dexterity and coordination, as well as traits like perseverance and determination.

dat$neuro_cognition_spatialawareness_stage3 <- raw_dat$cdpcabil
dat$neuro_cognition_spatialawareness_stage3[raw_dat$neuro_cognition_spatialawareness_stage3<0]<-NA
dat$neuro_cognition_spatialawareness_stage3_zscore <- scale(dat$neuro_cognition_spatialawareness_stage3)

# ability score for picture similarity (BAS)
#Children are shown a row of 4 pictures on a page and asked to place a card with a
#fifth picture under the picture most similar to it. This assessment measures children’s
#problem solving abilities.

dat$neuro_cognition_problemsolving_stage3 <- raw_dat$cdpsabil
dat$neuro_cognition_problemsolving_stage3[raw_dat$neuro_cognition_problemsolving_stage3<0]<-NA
dat$neuro_cognition_problemsolving_stage3_zscore <- scale(dat$neuro_cognition_problemsolving_stage3)

# Word Reading is an assessment from the British Ability Scales: Second Edition (BAS
# 2) which assesses children’s English reading ability.

dat$neuro_cognition_reading_stage3 <- raw_dat$dcwrab00
dat$neuro_cognition_reading_stage3[raw_dat$neuro_cognition_reading_stage3<0]<-NA
dat$neuro_cognition_reading_stage3_zscore <- scale(dat$neuro_cognition_reading_stage3)

# School Readiness (Bracken)

# The Bracken Basic Concept Scale – Revised (BBCS-R) is used to assess the basic
# concept development in children in the age range of 2 years 6 months to 7 years 11
# months. BBCS–R measures the comprehension of 308 functionally relevant
# educational concepts in 11 subtests or concept categories. Following consultation
# with advisers and piloting, only subtests 1-6 were administered by interviewers to the
# members of the cohort during the MCS2 data collection.

dat$neuro_cognition_schoolreadiness_stage2 <- raw_dat$bdbsrc00
dat$neuro_cognition_schoolreadiness_stage2[dat$neuro_cognition_schoolreadiness_stage2<0]<-NA
dat$neuro_cognition_schoolreadiness_stage2_zscore  <- scale(dat$neuro_cognition_schoolreadiness_stage2)

# Number skills
# This test was adapted from the NFER Progress in Maths test which is aimed for 7-
# year-olds and was originally developed and nationally UK standardised in 2004. The
# whole test has a maximum raw score of 28. The national mean raw score in 2004
# was 19.3 with a standard deviation of 5.3.

dat$neuro_cognition_numberskills_stage3 <- raw_dat$maths7sc
dat$neuro_cognition_numberskills_stage3[dat$neuro_cognition_numberskills_stage3<0]<-NA
dat$neuro_cognition_numberskills_stage3_zscore  <- scale(dat$neuro_cognition_numberskills_stage3)

#Educational attainment





# asthma
dat$immuno_asthma_stage2_binary <- NA
dat$immuno_asthma_stage2_binary[raw_dat$bmasmaa0 ==2 ] <- 0
dat$immuno_asthma_stage2_binary[raw_dat$bmasmaa0 ==1 ] <- 1

dat$immuno_asthma_stage3_binary <- NA
dat$immuno_asthma_stage3_binary[raw_dat$cmasmaa0 ==2 | raw_dat$dmasmaa0 ==2 ] <- 0
dat$immuno_asthma_stage3_binary[raw_dat$cmasmaa0 ==1 | raw_dat$dmasmaa0 ==1] <- 1

dat$immuno_asthma_allstages_binary <- NA
dat$immuno_asthma_allstages_binary[dat$immuno_asthma_stage2_binary==0 | dat$immuno_asthma_stage3_binary ==0 ] <- 0
dat$immuno_asthma_allstages_binary[dat$immuno_asthma_stage2_binary==1 | dat$immuno_asthma_stage3_binary ==1 ] <- 1

# wheeze
dat$immuno_wheeze_stage2_binary <- NA
dat$immuno_wheeze_stage2_binary[raw_dat$bmwhlya0 ==2 | raw_dat$bmwheea0 ==2] <- 0
dat$immuno_wheeze_stage2_binary[raw_dat$bmwhlya0 ==1 | raw_dat$bmwheea0 ==1] <- 1

dat$immuno_wheeze_stage3_binary <- NA
dat$immuno_wheeze_stage3_binary[raw_dat$cmwhlya0 ==2 | raw_dat$dmwhlya0 ==2 | raw_dat$cmwheea0 ==2 | raw_dat$dmwheea0 ==2] <- 0
dat$immuno_wheeze_stage3_binary[raw_dat$cmwhlya0  ==1 | raw_dat$dmwhlya0 ==1 |raw_dat$cmwheea0  ==1 | raw_dat$dmwheea0 ==1] <- 1

dat$immuno_wheeze_allstages_binary <- NA
dat$immuno_wheeze_allstages_binary[dat$immuno_wheeze_stage2_binary==0 | dat$immuno_wheeze_stage3_binary ==0 ] <- 0
dat$immuno_wheeze_allstages_binary[dat$immuno_wheeze_stage2_binary==1 | dat$immuno_wheeze_stage3_binary ==1 ] <- 1

#eczema (question for stage 2 was about eczema OR hayfever, so have dropped this question)
dat$immuno_eczema_stage3_binary <- NA
dat$immuno_eczema_stage3_binary[raw_dat$cmeczma0 ==2 | raw_dat$dmeczma0 ==2 ] <- 0
dat$immuno_eczema_stage3_binary[raw_dat$cmeczma0  ==1 | raw_dat$dmeczma0 ==1] <- 1

dat$immuno_eczema_allstages_binary <- dat$immuno_eczema_stage3_binary

#allergy

dat$immuno_allergy_hay_stage3_binary <- NA
dat$immuno_allergy_hay_stage3_binary[raw_dat$cmhafva0 ==2 | raw_dat$dmhafva0 ==2 ] <- 0
dat$immuno_allergy_hay_stage3_binary[raw_dat$cmhafva0  ==1 | raw_dat$dmhafva0 ==1] <- 1

dat$immuno_allergy_hay_allstages_binary <- dat$immuno_allergy_hay_stage3_binary





dat$covs_ethnicity_mother<- NA
dat$covs_ethnicity_mother[raw_dat$amdeea00%in%c(1,2,3)]<-"white"
dat$covs_ethnicity_mother[raw_dat$amdeea00%in%c(4,5,6,7,95)]<-"mixed or other"
dat$covs_ethnicity_mother[raw_dat$amdeea00%in%c(8,9,10,11,15)]<-"asian"
dat$covs_ethnicity_mother[raw_dat$amdeea00%in%c(12,13,14)]<-"black"

dat$covs_ethnicity_mother_binary <- NA
dat$covs_ethnicity_mother_binary[dat$covs_ethnicity_mother%in%c("white")]<-"white"
dat$covs_ethnicity_mother_binary[dat$covs_ethnicity_mother%in%c("asian","black","mixed or other")]<-"not white"

dat$covs_ethnicity_father<- NA
dat$covs_ethnicity_father[raw_dat$apdeea00%in%c(1,2,3)]<-"white"
dat$covs_ethnicity_father[raw_dat$apdeea00%in%c(4,5,6,7,95)]<-"mixed or other"
dat$covs_ethnicity_father[raw_dat$apdeea00%in%c(8,9,10,11,15)]<-"asian"
dat$covs_ethnicity_father[raw_dat$apdeea00%in%c(12,13,14)]<-"black"

dat$covs_ethnicity_father_binary <- NA
dat$covs_ethnicity_father_binary[dat$covs_ethnicity_father%in%c("white")]<-"white"
dat$covs_ethnicity_father_binary[dat$covs_ethnicity_father%in%c("asian","black","mixed or other")]<-"not white"

dat$covs_ethnicity_child<- NA
dat$covs_ethnicity_child[raw_dat$adceeaa0%in%c(1,2,3)]<-"white"
dat$covs_ethnicity_child[raw_dat$adceeaa0%in%c(4,5,6,7,95)]<-"mixed or other"
dat$covs_ethnicity_child[raw_dat$adceeaa0%in%c(8,9,10,11,15)]<-"asian"
dat$covs_ethnicity_child[raw_dat$adceeaa0%in%c(12,13,14)]<-"black"

dat$covs_ethnicity_child_binary <- NA
dat$covs_ethnicity_child_binary[dat$covs_ethnicity_child%in%c("white")]<-"white"
dat$covs_ethnicity_child_binary[dat$covs_ethnicity_child%in%c("asian","black","mixed or other")]<-"not white"

dat$covs_age_mother_delivery <- raw_dat$amdagb00
dat$covs_age_mother_delivery[dat$covs_age_mother_delivery<0]<-NA

dat$covs_age_father_delivery <- raw_dat$apdagb00
dat$covs_age_father_delivery[dat$covs_age_father_delivery<0]<-NA

# for education, vocational qualifications were mapped to the academic quals listed below
dat$covs_edu_mother<-NA
dat$covs_edu_mother[raw_dat$amdnvq00 %in% c(4,5)]<-3 #degree, HE diploma
dat$covs_edu_mother[raw_dat$amdnvq00==3]<-2 # A level,
dat$covs_edu_mother[raw_dat$amdnvq00%in%c(1,2)]<-1 #O level or GCSE
dat$covs_edu_mother[raw_dat$amdnvq00==96]<-0 #None of these

dat$covs_edu_father<-NA
dat$covs_edu_father[raw_dat$apdnvq00 %in% c(4,5)]<-3 #degree, HE diploma
dat$covs_edu_father[raw_dat$apdnvq00==3]<-2 # A level,
dat$covs_edu_father[raw_dat$apdnvq00%in%c(1,2)]<-1 #O level or GCSE
dat$covs_edu_father[raw_dat$apdnvq00==96]<-0 #None of these

dat$covs_occup_mother <- NA
dat$covs_occup_mother[raw_dat$amd05s00==1]<-3 #professional or managerial
dat$covs_occup_mother[raw_dat$amd05s00%in%c(2,3)]<-2 #intermediate and small employer and self-employed
dat$covs_occup_mother[raw_dat$amd05s00==4]<-1 #low supervisory and technical
dat$covs_occup_mother[raw_dat$amd05s00==5]<-0 #semi-routine or routine

dat$covs_occup_father <- NA
dat$covs_occup_father[raw_dat$apd05s00==1]<-3 #professional or managerial
dat$covs_occup_father[raw_dat$apd05s00%in%c(2,3)]<-2 #intermediate and small employer and self-employed
dat$covs_occup_father[raw_dat$apd05s00==4]<-1 #low supervisory and technical
dat$covs_occup_father[raw_dat$apd05s00==5]<-0 #semi-routine or routine

dat$covs_edu_father_highestlowest_binary <- NA
dat$covs_edu_father_highestlowest_binary[dat$covs_edu_father==0] <- 0
dat$covs_edu_father_highestlowest_binary[dat$covs_edu_father==3] <- 1

dat$covs_edu_mother_highestlowest_binary <- NA
dat$covs_edu_mother_highestlowest_binary[dat$covs_edu_mother==0] <- 0
dat$covs_edu_mother_highestlowest_binary[dat$covs_edu_mother==3] <- 1

dat$covs_occup_mother_highestlowest_binary <- NA
dat$covs_occup_mother_highestlowest_binary[dat$covs_occup_mother==0] <- 0
dat$covs_occup_mother_highestlowest_binary[dat$covs_occup_mother==3] <- 1

dat$covs_occup_father_highestlowest_binary <- NA
dat$covs_occup_father_highestlowest_binary[dat$covs_occup_father==0] <- 0
dat$covs_occup_father_highestlowest_binary[dat$covs_occup_father==3] <- 1




dat$covs_partner_lives_with_mother_prenatal<-NA
dat$covs_partner_lives_with_mother_prenatal[raw_dat$adrelp00%in%c(1,2)]<-1 #15228 (parents married or co-habiting)
dat$covs_partner_lives_with_mother_prenatal[raw_dat$adrelp00==3]<-0 # 18 (neither)

dat$covs_married_mother_binary<-NA
dat$covs_married_mother_binary[raw_dat$adrelp00%in%c(2,3)]<-0
dat$covs_married_mother_binary[raw_dat$adrelp00==1]<-1

dat$covs_married_father_binary<-dat$covs_married_mother_binary





dat$covs_asthma_mother_binary <- NA
dat$covs_asthma_mother_binary[raw_dat$amasth00==1]<-1
dat$covs_asthma_mother_binary[raw_dat$amasth00==2]<-0

dat$covs_asthma_father_binary <- NA
dat$covs_asthma_father_binary[raw_dat$apasth00==1]<-1
dat$covs_asthma_father_binary[raw_dat$apasth00==2]<-0

dat$covs_eczema_mother_binary <- NA
dat$covs_eczema_mother_binary[raw_dat$ameczm00==1]<-1
dat$covs_eczema_mother_binary[raw_dat$ameczm00==2]<-0

dat$covs_eczema_father_binary <- NA
dat$covs_eczema_father_binary[raw_dat$apeczm00==1]<-1
dat$covs_eczema_father_binary[raw_dat$apeczm00==2]<-0

dat$covs_diabetes_mother_binary <- NA
dat$covs_diabetes_mother_binary[raw_dat$amdiab00==1 & raw_dat$amdiwt0a!=1]<-1
dat$covs_diabetes_mother_binary[raw_dat$amdiab00==2 | raw_dat$amdiwt0a==1]<-0

dat$covs_diabetes_father_binary <- NA
dat$covs_diabetes_father_binary[raw_dat$apdiab00==1]<-1
dat$covs_diabetes_father_binary[raw_dat$apdiab00==2]<-0

#Do you have a longstanding illness, disability or infirmity. By longstanding I mean anything that has troubled you over a period of time or that is likely to affect you over a period of time?
dat$covs_mother_illness_binary <- NA
dat$covs_mother_illness_binary[raw_dat$amloil00==1]<-1
dat$covs_mother_illness_binary[raw_dat$amloil00==2]<-0

dat$covs_father_illness_binary <- NA
dat$covs_father_illness_binary[raw_dat$aploil00==1]<-1
dat$covs_father_illness_binary[raw_dat$aploil00==2]<-0

dat$covs_mother_depression_binary <- NA
dat$covs_mother_depression_binary[raw_dat$amdean00==1]<-1
dat$covs_mother_depression_binary[raw_dat$amdean00==2]<-0

dat$covs_father_depression_binary <- NA
dat$covs_father_depression_binary[raw_dat$apdean00==1]<-1
dat$covs_father_depression_binary[raw_dat$apdean00==2]<-0

dat$covs_height_mother <-raw_dat$amhgtm00
dat$covs_weight_mother <-raw_dat$amwgbk00 # weight in kilos before baby born
dat$covs_height_mother[raw_dat$amhgtm00<0.1] <- NA
dat$covs_weight_mother[raw_dat$amwgbk00<20] <- NA
dat$covs_bmi_mother <- dat$covs_weight_mother/(dat$covs_height_mother^2)
dat$covs_bmi_mother_zscore <-scale(dat$covs_bmi_mother)

dat$covs_height_father <-raw_dat$aphgtm00
dat$covs_weight_father <-raw_dat$apwgtk00 # weight in kilos at time of interview
dat$covs_height_father[raw_dat$aphgtm00<0.1] <- NA
dat$covs_weight_father[raw_dat$apwgtk00<20] <- NA
dat$covs_bmi_father <- dat$covs_weight_father/(dat$covs_height_father^2)
dat$covs_bmi_father_zscore <-scale(dat$covs_bmi_father)




dat$covs_hdp_binary<-NA
dat$covs_hdp_binary[raw_dat$amilpr00%in% c(1,2)]<-0
dat$covs_hdp_binary[raw_dat$amilwm0a==5|raw_dat$amilwm0b==5|raw_dat$amilwm0c==5|raw_dat$amilwm0d==5|raw_dat$amilwm0e==5|raw_dat$amilwm0f==5|raw_dat$amilwm0g==5]<-1

#existing or gestational diabetes (named glycosuria to match alspac)
dat$covs_glycosuria_binary<-NA
dat$covs_glycosuria_binary[raw_dat$amilpr00%in% c(1,2)]<-0
dat$covs_glycosuria_binary[raw_dat$amilwm0a==7|raw_dat$amilwm0b==7|raw_dat$amilwm0c==7|raw_dat$amilwm0d==7|raw_dat$amilwm0e==7|raw_dat$amilwm0f==7|raw_dat$amilwm0g==7]<-1
dat$covs_glycosuria_binary[dat$covs_diabetes_mother_binary==1]<-1



#Gestage
dat$covs_gestage <- raw_dat$adgesta0
dat$covs_gestage[dat$covs_gestage <0]<-NA
dat$covs_gestage <- dat$covs_gestage/7

dat$covs_preterm_binary <- NA
dat$covs_preterm_binary[dat$covs_gestage<37]<-1
dat$covs_preterm_binary[dat$covs_gestage>=37]<-0

#Duration of breastfeeding

dat$covs_breastfeeding_ordinal <- NA
dat$covs_breastfeeding_ordinal[raw_dat$ambfeva0==2 | raw_dat$ambfeaa0==1] <-0 #never tried
dat$covs_breastfeeding_ordinal[raw_dat$ambfeaa0==2 | raw_dat$ambfeda0 %in% 1:89 | raw_dat$ambfewa0 %in% 1:11 | raw_dat$ambfema0 %in% 1:2 | raw_dat$cmbfema0%in% 1:2] <-1 #less than 3 months (variables are less than 1 day, duration in days, duration in weeks, duration in months)
dat$covs_breastfeeding_ordinal[raw_dat$ambfeda0 %in% 90:180 | raw_dat$ambfewa0 %in% 12:23 | raw_dat$ambfema0 %in% 3:5 | raw_dat$cmbfema0%in% 3:5] <-2 #3- <6 months
dat$covs_breastfeeding_ordinal[raw_dat$ambfeda0 %in% 180:10000| raw_dat$ambfewa0 %in% 24:10000 | raw_dat$ambfema0 %in% 6:10000|
                              raw_dat$cmbfema0%in% 6:10000 | raw_dat$cmbfeya0>=1  | raw_dat$bmbfeaa0==3 | raw_dat$cmbfeaa0==3 ] <-3 #6+ months (duration in days, duration in weeks, duration in months, years, still breastfeeding))

#Child’s exposure to passive smoke

dat$covs_passivesmk_child_stage0_binary <- NA
dat$covs_passivesmk_child_stage0_binary[raw_dat$amsmkr00==2] <- 0
dat$covs_passivesmk_child_stage0_binary[raw_dat$amsmkr00==1] <- 1

dat$covs_passivesmk_child_stage2_binary <- NA
dat$covs_passivesmk_child_stage2_binary[raw_dat$bmsmkr00==2] <- 0
dat$covs_passivesmk_child_stage2_binary[raw_dat$bmsmkr00==1] <- 1

dat$covs_passivesmk_child_stage3_binary <- NA
dat$covs_passivesmk_child_stage3_binary[raw_dat$cmsmkr00==2|raw_dat$dmsmkr00==2] <- 0
dat$covs_passivesmk_child_stage3_binary[raw_dat$cmsmkr00==1|raw_dat$dmsmkr00==1] <- 1




saveRDS(dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno.rds")


