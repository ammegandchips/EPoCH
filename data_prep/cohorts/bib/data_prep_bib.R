
#Handy way in R to download many packages at once)
packages <- c("dplyr", "purrr", "data.table","tidyverse","tinytex","rmarkdown")
lapply(packages, require, character.only=T)



#Read in data
fathers_baseline <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Father_Baseline_Questionnaire_v7_fbqall_Data.Rdata"))
mothers_baseline <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Mother_Baseline_Questionnaire_v7_mbqall_Data.Rdata"))

preg_birth_eclprg <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Pregnancy_and_Birth_v7_eclprg_Data.Rdata"))
preg_birth_eclbby <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Pregnancy_and_Birth_v7_eclbby_Data.Rdata"))
preg_birth_prninf <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Pregnancy_and_Birth_v7_prninf_Data.Rdata"))
preg_birth_prnprg <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Pregnancy_and_Birth_v7_prnprg_Data.Rdata"))

child_follow_up_b6mtab <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_b6mtab_Data.Rdata"))
child_follow_up_b12tab <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_b12tab_Data.Rdata"))
child_follow_up_b18tab <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_b18tab_Data.Rdata"))
child_follow_up_b24tab <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_b24tab_Data.Rdata"))
child_follow_up_b36tab <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_b36tab_Data.Rdata"))

child_follow_up_chgcom <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_chgcom_Data.Rdata"))
child_follow_up_schlbp <- get(load("/Volumes/MRC-IEU-research/data/bib/_latest/BIB_Phenotypes/data/rdata/Follow-up_v7_schlbp_Data.Rdata"))

# merge together raw data (note that we don't want loads of instances of MotherID and FatherID (and ChildID when we're adding child-level variables) so we take those out of the data frames as we merge them (all other variable names should be unique):

# First merge anything at the pregnancy level (data mums, dads and pregnancies) by PregnancyID
raw_dat_parents <- merge(mothers_baseline,fathers_baseline[,-which(colnames(fathers_baseline) %in% c("MotherID","FatherID"))],by="PregnancyID",all=TRUE)
raw_dat_parents <- merge(raw_dat_parents,preg_birth_eclprg[,-which(colnames(preg_birth_eclprg) %in% c("MotherID","FatherID"))],by="PregnancyID",all=TRUE)
raw_dat_parents <- merge(raw_dat_parents,preg_birth_prnprg[,-which(colnames(preg_birth_prnprg) %in% c("MotherID","FatherID"))],by="PregnancyID",all=TRUE)

# Next merge anything at the child level (data on children) by ChildID
raw_dat_child <- merge(preg_birth_eclbby,preg_birth_prninf[,-which(colnames(preg_birth_prninf) %in% c("MotherID","FatherID","PregnancyID"))],by="ChildID",all=TRUE)
raw_dat_child <- merge(raw_dat_child,child_follow_up_b6mtab[,-which(colnames(child_follow_up_b6mtab) %in% c("MotherID","FatherID","PregnancyID","has_bib1kc"))],by="ChildID",all=TRUE)
raw_dat_child <- merge(raw_dat_child,child_follow_up_b12tab[,-which(colnames(child_follow_up_b12tab) %in% c("MotherID","FatherID","PregnancyID","has_bib1kc"))],by="ChildID",all=TRUE)
raw_dat_child <- merge(raw_dat_child,child_follow_up_b18tab[,-which(colnames(child_follow_up_b18tab) %in% c("MotherID","FatherID","PregnancyID","has_bib1kc"))],by="ChildID",all=TRUE)
raw_dat_child <- merge(raw_dat_child,child_follow_up_b24tab[,-which(colnames(child_follow_up_b24tab) %in% c("MotherID","FatherID","PregnancyID","has_bib1kc"))],by="ChildID",all=TRUE)
raw_dat_child <- merge(raw_dat_child,child_follow_up_b36tab[,-which(colnames(child_follow_up_b36tab) %in% c("MotherID","FatherID","PregnancyID","has_bib1kc"))],by="ChildID",all=TRUE)
raw_dat_child <- merge(raw_dat_child,child_follow_up_schlbp[,-which(colnames(child_follow_up_schlbp) %in% c("MotherID","FatherID","PregnancyID","has_bib1kc"))],by="ChildID",all=TRUE)

# The dataset child_follow_up_chgcom is in long format and we want it in wide format. Also it sometimes has multiple observations per child at each timepoint, so we need to take an average of those.
# I adapted this code from the code they are using in lifecycle to do this. First I made a function to take a variable, group it by child ID and age (in months) at growth measurement, calculate a mean for each child at each growth measurement month, and put it into wide format using the 'spread' function.
spread_chgcom <- function(variable){
Var <- child_follow_up_chgcom %>% group_by(ChildID, agecm_cgrowth) %>%
                             summarise(Value = mean(get(variable), na.rm = T))
Var <- Var %>% rename(X_ = agecm_cgrowth)
Var$Value[is.nan(Var$Value)] <- NA
Var <- Var %>% spread(X_, Value, sep = "")
colnames(Var) <- str_replace_all(colnames(Var), "X_", paste0(variable,"_"))
Var
}
# Then I just applied this function to all the variables we're interested in from this file and combined them all together into one dataset in wide format.
child_follow_up_chgcom_wide <- lapply(c("cabdo","cbmi","chead","cheight","cweight","czbmiuk90","czbmiwho06","czweiwho06"),
                                      spread_chgcom)
child_follow_up_chgcom_wide <- bind_cols(child_follow_up_chgcom_wide)
child_follow_up_chgcom_wide <- child_follow_up_chgcom_wide[-grep("ChildID",names(child_follow_up_chgcom_wide))[-1]]
# Finally, I took out any variables that are completely NA (i.e. if no children were measured in a particular month)
child_follow_up_chgcom_wide <- child_follow_up_chgcom_wide[colSums(!is.na(child_follow_up_chgcom_wide)) > 0]

# This could then be merged with the other child-level data:
raw_dat_child <- merge(raw_dat_child,child_follow_up_chgcom_wide,by="ChildID",all=TRUE)

# merge pregnancy level data with child level data:
raw_dat <- merge(raw_dat_parents,raw_dat_child[,-which(colnames(raw_dat_child) %in% c("MotherID","FatherID","has_bib1kc"))],by="PregnancyID",all=TRUE)

#set up new dat object:
dat<-raw_dat[,c("MotherID","FatherID","PregnancyID","ChildID")]




dat$live_birth<-NA
dat$live_birth[raw_dat$prnbibirthoutc=="Live birth"]<-1
dat$live_birth[raw_dat$prnbibirthoutc%in%c("Miscarriage","Still birth")]<-0



dat$smoking_mother_ever_life_binary<-NA
dat$smoking_mother_ever_life_binary[which(raw_dat$smk0nowsmk=="No" | raw_dat$smk0regsmk=="No")]<-0
dat$smoking_mother_ever_life_binary[which(raw_dat$smk0nowsmk=="Yes" | raw_dat$smk0regsmk%in%c("Yes, more than 1 year","Yes, less than 1 year","Yes, not specified"))]<-1



dat$smoking_mother_before11_binary<-NA
dat$smoking_mother_before11_binary[raw_dat$smk0agestr<=11]<-1
dat$smoking_mother_before11_binary[raw_dat$smk0agestr>11]<-0



dat$smoking_mother_preconception_binary<-NA
dat$smoking_mother_preconception_binary[raw_dat$smk03mthb4=="None" | raw_dat$smk0regsmk=="No"]<-0
dat$smoking_mother_preconception_binary[raw_dat$smk03mthb4%in%c("1-5 a day","6-10 a day","11-20 a day","Over 20 a day")]<-1



dat$smoking_mother_preconception_ordinal<-NA
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4=="None"| raw_dat$smk0regsmk=="No"]<-"None"
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4%in%c("1-5 a day","6-10 a day")]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4=="11-20 a day"]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_preconception_ordinal[raw_dat$smk03mthb4=="Over 20 a day"]<-"Heavy" #i.e. >20
dat$smoking_mother_preconception_ordinal<-factor(dat$smoking_mother_preconception_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)



dat$smoking_mother_firsttrim_ordinal<-NA
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth=="None"| raw_dat$smk0regsmk=="No"]<-"None"
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth%in%c("1-5 a day","6-10 a day")]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth=="11-20 a day"]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_firsttrim_ordinal[raw_dat$smk0fr3mth=="Over 20 a day"]<-"Heavy" #i.e. >20
dat$smoking_mother_firsttrim_ordinal<-factor(dat$smoking_mother_firsttrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)



dat$smoking_mother_firsttrim_binary <- NA
dat$smoking_mother_firsttrim_binary[raw_dat$smk0fr3mth=="None"| raw_dat$smk0regsmk=="No"]<-0
dat$smoking_mother_firsttrim_binary[raw_dat$smk0fr3mth%in%c("1-5 a day","6-10 a day","11-20 a day","Over 20 a day")]<-1



dat$smoking_mother_secondtrim_binary<-NA
dat$smoking_mother_secondtrim_binary[raw_dat$smk04thmth=="None"| raw_dat$smk0regsmk=="No"]<-0
dat$smoking_mother_secondtrim_binary[raw_dat$smk04thmth%in%c("1-5 a day","6-10 a day","11-20 a day","Over 20 a day")]<-1



dat$smoking_mother_thirdtrim_binary<-NA
dat$smoking_mother_thirdtrim_binary[raw_dat$smk04thmth=="None"| raw_dat$smk0regsmk=="No"]<-0
dat$smoking_mother_thirdtrim_binary[raw_dat$smk04thmth%in%c("1-5 a day","6-10 a day","11-20 a day","Over 20 a day")]<-1



dat$smoking_mother_secondtrim_ordinal<-NA
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth=="None"| raw_dat$smk0regsmk=="No"]<-"None"
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth%in%c("1-5 a day","6-10 a day")]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth=="11-20 a day"]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_secondtrim_ordinal[raw_dat$smk04thmth=="Over 20 a day"]<-"Heavy" #i.e. >20
dat$smoking_mother_secondtrim_ordinal<-factor(dat$smoking_mother_secondtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)



dat$smoking_mother_thirdtrim_ordinal<-NA
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth=="None"| raw_dat$smk0regsmk=="No"]<-"None"
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth%in%c("1-5 a day","6-10 a day")]<-"Light" #i.e. <=10 but not 0
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth=="11-20 a day"]<-"Moderate" #i.e. >10, <=20
dat$smoking_mother_thirdtrim_ordinal[raw_dat$smk04thmth=="Over 20 a day"]<-"Heavy" #i.e. >20
dat$smoking_mother_thirdtrim_ordinal<-factor(dat$smoking_mother_thirdtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)



dat$smoking_mother_ever_pregnancy_binary<-NA
dat$smoking_mother_ever_pregnancy_binary[raw_dat$smk0smkprg=="Yes"]<-1
dat$smoking_mother_ever_pregnancy_binary[raw_dat$smk0smkprg=="No"]<-0



dat$smoking_mother_passive_binary<-NA
dat$smoking_mother_passive_binary[raw_dat$smk0expcig%in%c("Yes","Less than 1 hour per day")]<-1
dat$smoking_mother_passive_binary[raw_dat$smk0expcig=="No"]<-0



dat$smoking_father_thirdtrim_binary<-NA
dat$smoking_father_thirdtrim_binary[raw_dat$fbqsmokes=="No"]<-0
dat$smoking_father_thirdtrim_binary[raw_dat$fbqsmokes=="Yes"]<-1



dat$smoking_father_thirdtrim_ordinal<-NA
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokes=="No"]<-"None"
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokesamt%in%c("Less than 1 a day","1-5","6-10")]<-"Light" #i.e. <=10 but not 0
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokesamt=="11-20"]<-"Moderate" #i.e. >10, <=20
dat$smoking_father_thirdtrim_ordinal[raw_dat$fbqsmokesamt=="Over 20"]<- "Heavy" #i.e. >20
dat$smoking_father_thirdtrim_ordinal<-factor(dat$smoking_father_thirdtrim_ordinal, levels=c("None","Light","Moderate","Heavy"),ordered=T)



dat$smoking_father_ever_pregnancy_binary<-NA
dat$smoking_father_ever_pregnancy_binary[raw_dat$fbqsmokes=="No"]<-0
dat$smoking_father_ever_pregnancy_binary[raw_dat$fbqsmokes=="Yes"]<-1



#Drank alcohol 3 months before pregnancy (binary)
dat$alcohol_mother_preconception_binary<-NA
dat$alcohol_mother_preconception_binary[raw_dat$alc0dr3mb4=="No"]<-0
dat$alcohol_mother_preconception_binary[raw_dat$alc0dr3mb4%in%c("Yes, once a week", "Yes, occasionally","Yes, not specified" )]<-1

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
dat$alcohol_mother_firsttrim_binary[raw_dat$alc0drfr3m=="No"]<-0
dat$alcohol_mother_firsttrim_binary[raw_dat$alc0drfr3m%in%c("Yes, once a week","Yes, occasionally","Yes, not specified")]<-1

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
dat$alcohol_mother_firsttrim_ordinal <-NA
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous==0|dat$alcohol_mother_firsttrim_binary==0]<-"None"
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous>0 & raw_dat$alcohol_mother_firsttrim_continuous <=2]<-"Light" #<1 glass per week
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous >2 & raw_dat$alcohol_mother_firsttrim_continuous <=13]<-"Moderate" #1+glasses pwk, but not daily (12 units)
dat$alcohol_mother_firsttrim_ordinal[raw_dat$alcohol_mother_firsttrim_continuous >13]<-"Heavy" #daily drinking
dat$alcohol_mother_firsttrim_ordinal<-factor(dat$alcohol_mother_firsttrim_ordinal, levels=c("None", "Light","Moderate","Heavy"), ordered=T)


#drank alcohol in second trimester (binary)
#(The second are third timester variables are identical, due to how the question was asked "since 4th month of pregnancy")
dat$alcohol_mother_secondtrim_binary<-NA
dat$alcohol_mother_secondtrim_binary[raw_dat$alc0dr4thm=="No"]<-0
dat$alcohol_mother_secondtrim_binary[raw_dat$alc0dr4thm%in%c("Yes, once a week","Yes, occasionally","Yes, not specified")]<-1

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

dat$alcohol_mother_secondtrim_ordinal <-NA
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont==0|dat$alcohol_mother_secondtrim_binary==0]<-"None"
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont>0 & raw_dat$alcohol_mother_pw_since4thmonth_cont <=2]<-"Light" #<1 glass per week
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont >2 & raw_dat$alcohol_mother_pw_since4thmonth_cont <=13]<-"Moderate" #1+glasses pwk, but not daily (12 units)
dat$alcohol_mother_secondtrim_ordinal[raw_dat$alcohol_mother_pw_since4thmonth_cont >13]<-"Heavy" #daily drinking
dat$alcohol_mother_secondtrim_ordinal<-factor(dat$alcohol_mother_secondtrim_ordinal, levels=c("None", "Light","Moderate","Heavy"), ordered=T)



#NOTE: The second are third timester variables are identical, due to how the question was asked "since 4th month of pregnancy"
dat$alcohol_mother_thirdtrim_ordinal <- dat$alcohol_mother_secondtrim_ordinal
dat$alcohol_mother_thirdtrim_binary <- dat$alcohol_mother_secondtrim_binary



dat$alcohol_mother_binge1_binary <-NA
dat$alcohol_mother_binge1_binary[raw_dat$alc05ufr3m%in%c("Everyday","Nearly everyday","1-4 times/week","1-3 times a month","Rarely")]<-1
dat$alcohol_mother_binge1_binary[raw_dat$alc05ufr3m%in%c("Never")|raw_dat$alc0drfr3m=="No"]<-0

dat$alcohol_mother_binge2_binary <-NA
dat$alcohol_mother_binge2_binary[raw_dat$alc05u4thm%in%c("Everyday","Nearly everyday","1-4 times/week","1-3 times a month","Rarely")]<-1
dat$alcohol_mother_binge2_binary[raw_dat$alc05u4thm%in%c("Never")|raw_dat$alc0dr4thm=="No"]<-0

dat$alcohol_mother_binge3_binary <- dat$alcohol_mother_binge2_binary

dat$alcohol_mother_bingepreg_binary <- NA
dat$alcohol_mother_bingepreg_binary[dat$alcohol_mother_binge1_binary==0 & dat$alcohol_mother_binge2_binary==0] <-0
dat$alcohol_mother_bingepreg_binary[dat$alcohol_mother_binge1_binary==1 | dat$alcohol_mother_binge2_binary==1] <-1

dat$alcohol_mother_ever_pregnancy_binary<-NA
dat$alcohol_mother_ever_pregnancy_binary[dat$alcohol_mother_firsttrim_binary==0 &dat$alcohol_mother_secondtrim_binary==0 & dat$alcohol_mother_thirdtrim_binary == 0] <-0
dat$alcohol_mother_ever_pregnancy_binary[dat$alcohol_mother_firsttrim_binary==1 |dat$alcohol_mother_secondtrim_binary ==1 |dat$alcohol_mother_thirdtrim_binary ==1] <-1

#Any drinking vs no drinking at any time during pregnancy
#To note, the question asked was 'do you drink alcohol', this therefore could have been answered for pre-pregnancy drinking.
dat$alcohol_father_ever_pregnancy_binary<-NA
dat$alcohol_father_ever_pregnancy_binary[raw_dat$fbqalcohol=="No"]<-0
dat$alcohol_father_ever_pregnancy_binary[raw_dat$fbqalcohol=="Yes"]<-1

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



# Cups of coffee per day, mg/pd

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

# Cups of caffeinated herbal tea per day, mg/pd
#raw_dat$caffeine_mother_herbaltea_preg_cont<-raw_dat$cdr0htcfpd
# cups of herbal tea multiplied by 27 (mg caffeine in 1 cup tea)
#raw_dat$caffeine_mother_herbaltea_preg_cont<-raw_dat$caffeine_mother_herbaltea_preg_cont*27 #tranform cups to mg per day

# Add together standard tea and herbal tea (if we happy that the mg in herbal are roughly similar)
#dat$caffeine_mother_tea_thirdtrim_continuous<-rowSums(raw_dat[,c("caffeine_mother_blacktea_thirdtrim_cont","caffeine_mother_herbaltea_preg_cont")],na.rm=TRUE)

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



# At birth:
# Birthweight
dat$anthro_birthweight <-raw_dat$eclbirthwt
dat$anthro_birthweight_zscore <-scale(dat$anthro_birthweight)

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
dat$anthro_birthweight_sga_binary[raw_dat$eclsgaukwho=="No"]<-0
dat$anthro_birthweight_sga_binary[raw_dat$eclsgaukwho=="Yes"]<-1
#	LGA
dat$anthro_birthweight_lga_binary <- NA
dat$anthro_birthweight_lga_binary[raw_dat$ecllgaukwho=="No"]<-0
dat$anthro_birthweight_lga_binary[raw_dat$ecllgaukwho=="Yes"]<-1

#Head circumference at birth (cm)
dat$anthro_head_circ_birth<-raw_dat$eclheadcir
dat$anthro_head_circ_birth_zscore <-scale(dat$anthro_head_circ_birth)

#birth length (crown-heel) taken as height at birth
dat$anthro_crown_heel_birth <- raw_dat$cheight_0
dat$anthro_crown_heel_birth_zscore <-scale(dat$anthro_crown_heel_birth)

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
timepoint<-str_remove(timepoint,prefix)
list(oldest_measure,timepoint)
}

dat$anthro_height_stage1 <- select_oldest_measure("cheight_",stage1_mintime,stage1_maxtime)[[1]]
dat$covs_stage1_timepoint <- select_oldest_measure("cheight_",stage1_mintime,stage1_maxtime)[[2]]

dat$anthro_height_stage2 <- select_oldest_measure("cheight_",stage2_mintime,stage2_maxtime)[[1]]
dat$covs_stage2_timepoint <- select_oldest_measure("cheight_",stage2_mintime,stage2_maxtime)[[2]]

dat$anthro_height_stage3 <- select_oldest_measure("cheight_",stage3_mintime,stage3_maxtime)[[1]]
dat$covs_stage3_timepoint <- select_oldest_measure("cheight_",stage3_mintime,stage3_maxtime)[[2]]

dat$anthro_weight_stage1 <- select_oldest_measure("cweight_",stage1_mintime,stage1_maxtime)[[1]]
dat$covs_stage1_timepoint <- select_oldest_measure("cweight_",stage1_mintime,stage1_maxtime)[[2]]

dat$anthro_weight_stage2 <- select_oldest_measure("cweight_",stage2_mintime,stage2_maxtime)[[1]]
dat$covs_stage2_timepoint <- select_oldest_measure("cweight_",stage2_mintime,stage2_maxtime)[[2]]

dat$anthro_weight_stage3 <- select_oldest_measure("cweight_",stage3_mintime,stage3_maxtime)[[1]]
dat$covs_stage3_timepoint <- select_oldest_measure("cweight_",stage3_mintime,stage3_maxtime)[[2]]

dat$anthro_head_circ_stage1 <- select_oldest_measure("chead_",stage1_mintime,stage1_maxtime)[[1]]

dat$anthro_head_circ_stage2 <- select_oldest_measure("chead_",stage2_mintime,stage2_maxtime)[[1]]

dat$anthro_bmi_stage1 <- select_oldest_measure("cbmi_",stage1_mintime,stage1_maxtime)[[1]]
dat$anthro_bmi_stage2 <- select_oldest_measure("cbmi_",stage2_mintime,stage2_maxtime)[[1]]
dat$anthro_bmi_stage3 <- select_oldest_measure("cbmi_",stage3_mintime,stage3_maxtime)[[1]]


dat$anthro_waist_stage1 <- select_oldest_measure("cabdo_",stage1_mintime,stage1_maxtime)[[1]]
dat$anthro_waist_stage2 <- select_oldest_measure("cabdo_",stage2_mintime,stage2_maxtime)[[1]]

dat$anthro_bmi_stage1_sds <- select_oldest_measure("czbmiwho06_",stage1_mintime,stage1_maxtime)[[1]]

dat$anthro_bmi_stage2_sds <- select_oldest_measure("czbmiwho06_",stage2_mintime,stage2_maxtime)[[1]]

dat$anthro_bmi_stage3_sds <- select_oldest_measure("czbmiwho06_",stage3_mintime,stage3_maxtime)[[1]]

#who categories of overweight and obesity
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

#scaled
dat$anthro_height_stage1_zscore <-scale(dat$anthro_height_stage1)
dat$anthro_height_stage2_zscore <-scale(dat$anthro_height_stage2)
dat$anthro_height_stage3_zscore <-scale(dat$anthro_height_stage3)

dat$anthro_weight_stage1_zscore <-scale(dat$anthro_weight_stage1)
dat$anthro_weight_stage2_zscore <-scale(dat$anthro_weight_stage2)
dat$anthro_weight_stage3_zscore <-scale(dat$anthro_weight_stage3)

dat$anthro_bmi_stage1_zscore <-scale(dat$anthro_bmi_stage1)
dat$anthro_bmi_stage2_zscore <-scale(dat$anthro_bmi_stage2)
dat$anthro_bmi_stage3_zscore <-scale(dat$anthro_bmi_stage3)

dat$anthro_head_circ_stage1_zscore <-scale(dat$anthro_head_circ_stage1)
dat$anthro_head_circ_stage2_zscore <-scale(dat$anthro_head_circ_stage2)

dat$anthro_waist_stage1_zscore <-scale(dat$anthro_waist_stage1)
dat$anthro_waist_stage2_zscore <-scale(dat$anthro_waist_stage2)




#glycosuria, existing diabetes or gestational diabetes vs no glycosuria or diabetes
dat$covs_glycosuria_binary<-NA
dat$covs_glycosuria_binary[raw_dat$drvgesdiab=="No"&raw_dat$bkfdiabete=="No"]<-0
dat$covs_glycosuria_binary[raw_dat$drvgesdiab=="Yes"|raw_dat$bkfdiabete=="Yes"]<-1
dat$covs_glycosuria_binary[raw_dat$prnprexcont1dm=="Yes"]<-1
dat$covs_glycosuria_binary[raw_dat$prnprexcont2dm=="Yes"]<-1

# preeclampsia or pregnancy induced HT
dat$covs_hdp_binary<-NA
dat$covs_hdp_binary[raw_dat$bkfhyperpi=="No"&raw_dat$bkfpreeclm=="No"]<-0
dat$covs_hdp_binary[raw_dat$bkfhyperpi=="Mild to moderate"|raw_dat$bkfhyperpi== "Severe"|raw_dat$bkfhyperpi=="Yes, not classified"|raw_dat$bkfpreeclm=="Yes"]<-1



# gender
dat$covs_sex<-NA
dat$covs_sex[raw_dat$eclbabysex=="Male"]<-"male"
dat$covs_sex[raw_dat$eclbabysex=="Female"]<-"female"

# Maternal age
# this was measured during pregnancy. I've used in years, but months is also available (agemm_mbagtt)
dat$covs_age_mother_conception<-raw_dat$agemy_mbqall

# Paternal age
dat$covs_age_father_pregnancy<-raw_dat$agefy_fbqall

#Parity
dat$covs_parity_mother_binary<-NA
dat$covs_parity_mother_binary[raw_dat$eclregpart==0]<-0
dat$covs_parity_mother_binary[raw_dat$eclregpart>0]<-1

# Maternal ethnicity
dat$covs_ethnicity_mother_binary<-NA
dat$covs_ethnicity_mother_binary[raw_dat$eth0eth9gp%in%c("White British","White other")]<-"white"
dat$covs_ethnicity_mother_binary[raw_dat$eth0eth9gp%in%c("Mixed-White and Black", "Mixed-White and South Asian", "Black", "Indian", "Pakistani", "Bangladeshi", "Other")]<-"not white"

dat$covs_ethnicityBIB_mother_binary <-NA
dat$covs_ethnicityBIB_mother_binary[raw_dat$eth0eth3gp=="White British"]<-"white british"
dat$covs_ethnicityBIB_mother_binary[raw_dat$eth0eth3gp=="Pakistani"]<-"pakistani"
dat$covs_ethnicityBIB_mother_binary[raw_dat$eth0eth3gp=="Other"]<-"other"

# Paternal ethncity
dat$covs_ethnicity_father_binary<-NA
dat$covs_ethnicity_father_binary[raw_dat$fbqethnicgrp=="White"]<-"white"
dat$covs_ethnicity_father_binary[raw_dat$fbqethnicgrp%in%c("Mixed","Black/Black British", "Asian/Asian British","Chinese", "Other")]<-"not white"

# Maternal education (other/don't know/foreign unknown all coded as NA)
dat$covs_edu_mother<-NA
dat$covs_edu_mother[raw_dat$edu0mumede=="<5 GCSE equivalent"] <-0
dat$covs_edu_mother[raw_dat$edu0mumede=="5 GCSE equivalent"] <-1
dat$covs_edu_mother[raw_dat$edu0mumede=="A-level equivalent"] <-2
dat$covs_edu_mother[raw_dat$edu0mumede=="Higher than A-level"] <-3

# Paternal education
dat$covs_edu_father<-NA
dat$covs_edu_father[raw_dat$edu0fthede=="<5 GCSE equivalent"] <-0
dat$covs_edu_father[raw_dat$edu0fthede=="5 GCSE equivalent"] <-1
dat$covs_edu_father[raw_dat$edu0fthede=="A-level equivalent"] <-2
dat$covs_edu_father[raw_dat$edu0fthede=="Higher than A-level"] <-3

# Maternal occupation
# mother's occupation not recorded in the data currently in Bristol. Lifecycle have used variables 	bib6f06 (etc) from the BiB1000 sub study and all24e7 etc (from ALL-IN sub study). We have employment status, but this isn't the same as occupation and can't be used in its place.

# Paternal occupation
dat$covs_occup_father <- NA
dat$covs_occup_father[raw_dat$job0fthwrk %in% c("Modern professional occupations","Senior managers or administrators","Traditional professional occupations")] <- 3 #professional or managerial
dat$covs_occup_father[raw_dat$job0fthwrk %in% c("Clerical and intermediate occupations","Middle or junior managers")] <- 2 #skilled non-manual
dat$covs_occup_father[raw_dat$job0fthwrk %in% c("Technical and craft occupations","Semi-rountine manual and service occupations")] <- 1 #skilled manual
dat$covs_occup_father[raw_dat$job0fthwrk %in% c("Rountine manual and service occupations")] <- 0 #semi-skilled or unskilled




# Living with partner
dat$covs_partner_lives_with_mother_prenatal<-NA
dat$covs_partner_lives_with_mother_prenatal[raw_dat$hhd0cohabt%in%c("Living with baby's father","Living with another partner")]<- 1
dat$covs_partner_lives_with_mother_prenatal[raw_dat$hhd0cohabt=="Not living with a partner"]<- 0

# mum married (or not separated)
dat$covs_married_mother_binary<-NA
dat$covs_married_mother_binary[raw_dat$hhd0martst%in%c("Married (1st marriage)","Re-married")]<-1
dat$covs_married_mother_binary[raw_dat$hhd0martst%in%c("Separated (still legally married","Divorced","Widowed","Single (never married)")]<-0





#Mother's asthma (lots of missingness)
dat$covs_asthma_mother <- NA
dat$covs_asthma_mother[raw_dat$prnprexconasthma=="Yes"]<-1
dat$covs_asthma_mother[raw_dat$prnprexconasthma=="No"]<-0

#Mother's mental illness (lots of missingness)
dat$covs_mentalhealthdisorder_mother <- NA
dat$covs_mentalhealthdisorder_mother[raw_dat$prnprexconmentheal=="Yes"]<-1
dat$covs_mentalhealthdisorder_mother[raw_dat$prnprexconmentheal=="No"]<-0

#Maternal supplements during pregnancy (last 4 weeks)
dat$covs_supplements_mother_binary <-NA
dat$covs_supplements_mother_binary[raw_dat$vit0vitipr=="Yes"]<-1
dat$covs_supplements_mother_binary[raw_dat$vit0vitipr=="No"]<-0

#Drugs in pregnancy
dat$covs_drugs_mother_binary <-NA
dat$covs_drugs_mother_binary[raw_dat$drg0drguse=="Yes"]<-1
dat$covs_drugs_mother_binary[raw_dat$drg0drguse=="No"]<-0

# Maternal height
dat$covs_height_mother<-raw_dat$mms0height

# Paternal height
dat$covs_height_father<-raw_dat$fbqheight
dat$covs_height_father[dat$covs_height_father<quantile(dat$covs_height_father,na.rm=T,probs=0.01)|dat$covs_height_father>quantile(dat$covs_height_father,na.rm=T,probs=0.99)]<-NA

# Maternal weight
dat$covs_weight_mother<-raw_dat$mms0weight

# Paternal weight
dat$covs_weight_father<-raw_dat$fbqweight
dat$covs_weight_father[dat$covs_weight_father<quantile(dat$covs_weight_father,na.rm=T,probs=0.01)|dat$covs_weight_father>quantile(dat$covs_weight_father,na.rm=T,probs=0.99)]<-NA

# Maternal bmi
dat$covs_bmi_mother<-raw_dat$mms0mbkbmi
dat$covs_bmi_mother_zscore <- scale(dat$covs_bmi_mother)

# Paternal bmi
dat$covs_bmi_father <- dat$covs_weight_father/(dat$covs_height_father/100)^2
dat$covs_bmi_father_zscore <-scale(dat$covs_bmi_father)



dat$covs_gestage <- raw_dat$eclgestday/7

dat$covs_preterm_binary <- NA
dat$covs_preterm_binary[dat$covs_gestage<37]<-1
dat$covs_preterm_binary[dat$covs_gestage>=37]<-0




saveRDS(dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_pheno.rds")


