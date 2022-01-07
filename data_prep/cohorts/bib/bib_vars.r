######################################################################
## Code to create bib_pheno_raw.rds                                 ##
######################################################################

require(tidyverse)
require(haven)

#Read in data

father_cohort_info <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_CohortInfo/p6_linkage_v1-14-1_BiB_CohortInfo.father_info.dta")
mother_cohort_info <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_CohortInfo/p6_linkage_v1-14-1_BiB_CohortInfo.mother_info.dta")
child_cohort_info <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_CohortInfo/p6_linkage_v1-14-1_BiB_CohortInfo.child_info.dta")
preg_cohort_info <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_CohortInfo/p6_linkage_v1-14-1_BiB_CohortInfo.preg_info.dta")
person_cohort_info <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_CohortInfo/p6_linkage_v1-14-1_BiB_CohortInfo.person_info.dta")

fathers_baseline <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Baseline/p2_father_baseline_v1-14-1_BiB_Baseline.base_f_survey.dta")
mothers_baseline <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Baseline/p1_mother_baseline_v1-14-1_BiB_Baseline.base_m_survey.dta")
mothers_baseline_derived <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Baseline/p1_mother_baseline_v1-14-1_BiB_CohortInfo.m_derived_info.dta")

b1000_6m <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_1000/p5_follow_up_v1-14-1_BiB_1000.bib1000_6m_main.dta")
b1000_12m <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_1000/p5_follow_up_v1-14-1_BiB_1000.bib1000_12m_main.dta")
b1000_18m <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_1000/p5_follow_up_v1-14-1_BiB_1000.bib1000_18m_main.dta")
b1000_24m <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_1000/p5_follow_up_v1-14-1_BiB_1000.bib1000_24m_main.dta")
b1000_36m <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_1000/p5_follow_up_v1-14-1_BiB_1000.bib1000_36m_main.dta")

bioimpedence <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_ChildGrowth/p5_follow_up_v1-14-1_BiB_ChildGrowth.bioimpedance.dta")
growth <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_ChildGrowth/p5_follow_up_v1-14-1_BiB_ChildGrowth.growth_anthro.dta")

GU_adult <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_GrowingUp/p5_follow_up_v1-14-1_BiB_GrowingUp.adult_survey.dta")

GU_child <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_GrowingUp/p5_follow_up_v1-14-1_BiB_GrowingUp.child_survey_adult_comp.dta")
GU_bloodp <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_GrowingUp/p5_follow_up_v1-14-1_BiB_GrowingUp.blood_pressure.dta")

GU_bloodt <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_GrowingUp/p5_follow_up_v1-14-1_BiB_GrowingUp.blood_tests.dta")

#GU_ppathway <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_GrowingUp/p5_follow_up_v1-14-1_BiB_GrowingUp.participant_pathway.dta")

medall_quest <-read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_MeDALL/p5_follow_up_v1-14-1_BiB_MeDALL.medall_quest.dta")

preg_eclprg <-read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Pregnancy/p3_preg_birth_v1-14-1_BiB_Pregnancy.eclipse_preg.dta")
preg_matrecs_preg <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Pregnancy/p3_preg_birth_v1-14-1_BiB_Pregnancy.matrecs_bib_preg.dta")
preg_matrecs_mum <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Pregnancy/p3_preg_birth_v1-14-1_BiB_Pregnancy.matrecs_bib_mum.dta")

preg_matrecs_inf <- read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Pregnancy/p3_preg_birth_v1-14-1_BiB_Pregnancy.matrecs_bib_inf.dta")
preg_eclbby <-read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Pregnancy/p3_preg_birth_v1-14-1_BiB_Pregnancy.eclipse_baby.dta")
preg_cordblood <-read_dta("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2021-07-21/data/stata/BiB_Pregnancy/p3_preg_birth_v1-14-1_BiB_Pregnancy.cord_bloods.dta")

# create child's data at the child level (with mum and dads IDs)
children <- person_cohort_info[person_cohort_info$ParticipantType=="Child",]
children <- left_join(children,b1000_6m,by="BiBPersonID")
children <- left_join(children,b1000_12m,by="BiBPersonID")
children <- left_join(children,b1000_18m,by="BiBPersonID")
children <- left_join(children,b1000_24m,by="BiBPersonID")
children <- left_join(children,b1000_36m,by="BiBPersonID")
children <- left_join(children,GU_child,by="BiBPersonID")
children <- left_join(children,medall_quest,by="BiBPersonID")
children <- left_join(children,preg_cordblood,by="BiBPersonID")
children <- left_join(children,preg_matrecs_inf,by="BiBPersonID")
children <- left_join(children,preg_eclbby,by="BiBPersonID")

GU_bloodt <- GU_bloodt[GU_bloodt$BiBPersonID %in% children$BiBPersonID,]

# Some child datasets are in long format and we want them in wide format. Also they sometimes have multiple observations per child at each timepoint, so we need to take an average of those. 
# I adapted this code from the code they are using in lifecycle to do this. First I made a function to take a variable, group it by child ID and age (in months) at growth measurement, calculate a mean for each child at each growth measurement month, and put it into wide format using the 'spread' function.
spread_data <- function(variable,dataset,agevar){
  colnames(dataset)[colnames(dataset)==agevar]<-"agevar"
  dataset$agevar <- round(dataset$agevar,0)
  Var <- dataset %>% group_by(BiBPersonID, agevar) %>%
    summarise(Value = mean(get(variable), na.rm = T))
  Var <- Var %>% rename(X_ = agevar)
  Var$Value[is.nan(Var$Value)] <- NA
  Var <- Var %>% spread(X_, Value, sep = "")
  colnames(Var) <- str_replace_all(colnames(Var), "X_", paste0(variable,"_"))
  Var
}
# Then I just applied this function to all the variables we're interested in from this file and combined them all together into one dataset in wide format.
GU_bloodt_wide <- lapply(c("triglycerides","cholesterol","hdl","ldl","cholhdl_ratio","nonhdlchol"),spread_data,dataset=GU_bloodt,agevar="AgeInMonths")
GU_bloodt_wide <- bind_cols(GU_bloodt_wide)
GU_bloodt_wide <- GU_bloodt_wide[-grep("BiBPersonID",names(GU_bloodt_wide))[-1]] #remove duplicate ID columns
colnames(GU_bloodt_wide)[grep("BiBPersonID",colnames(GU_bloodt_wide))]<-"BiBPersonID"
GU_bloodt_wide <- GU_bloodt_wide[colSums(!is.na(GU_bloodt_wide)) > 0] # Finally, I took out any variables that are completely NA (i.e. if no children were measured in a particular month)

GU_bloodp_wide <- lapply(c("systolic","diastolic"),spread_data,dataset=GU_bloodp,agevar="agemths")
GU_bloodp_wide <- bind_cols(GU_bloodp_wide)
GU_bloodp_wide <- GU_bloodp_wide[-grep("BiBPersonID",names(GU_bloodp_wide))[-1]] #remove duplicate ID columns
colnames(GU_bloodp_wide)[grep("BiBPersonID",colnames(GU_bloodp_wide))]<-"BiBPersonID"
GU_bloodp_wide <- GU_bloodp_wide[colSums(!is.na(GU_bloodp_wide)) > 0] # Finally, I took out any variables that are completely NA (i.e. if no children were measured in a particular month)

bioimpedence_wide <- lapply(c("fatp","fatm"),spread_data,dataset=bioimpedence,agevar="agemths")
bioimpedence_wide <- bind_cols(bioimpedence_wide)
bioimpedence_wide <- bioimpedence_wide[-grep("BiBPersonID",names(bioimpedence_wide))[-1]] #remove duplicate ID columns
colnames(bioimpedence_wide)[grep("BiBPersonID",colnames(bioimpedence_wide))]<-"BiBPersonID"
bioimpedence_wide <- bioimpedence_wide[colSums(!is.na(bioimpedence_wide)) > 0] # Finally, I took out any variables that are completely NA (i.e. if no children were measured in a particular month)

growth_wide <- lapply(c("cabdo","chead","cheight","cweight","czbmiuk90"),spread_data,dataset=growth,agevar="agecm_cgrowth")
growth_wide <- bind_cols(growth_wide)
growth_wide <- growth_wide[-grep("BiBPersonID",names(growth_wide))[-1]] #remove duplicate ID columns
colnames(growth_wide)[grep("BiBPersonID",colnames(growth_wide))]<-"BiBPersonID"
growth_wide <- growth_wide[colSums(!is.na(growth_wide)) > 0] # Finally, I took out any variables that are completely NA (i.e. if no children were measured in a particular month)

children <- left_join(children,GU_bloodt_wide,by="BiBPersonID")
children <- left_join(children,GU_bloodp_wide,by="BiBPersonID")
children <- left_join(children,bioimpedence_wide,by="BiBPersonID")
children <- left_join(children,growth_wide,by="BiBPersonID")

# create mum's data and pregnancy data at pregnancy level
mums <- person_cohort_info[person_cohort_info$ParticipantType=="Mother",1]
mums <- left_join(mums,mothers_baseline,by="BiBPersonID")
mums <- left_join(mums,mothers_baseline_derived,by="BiBPersonID")
GU_adults_mums <- GU_adult[GU_adult$BiBPersonID %in% mums$BiBPersonID,]
names(GU_adults_mums)[-1]<-paste0(names(GU_adults_mums)[-1],"_mum")
mums <- left_join(mums,GU_adults_mums,by="BiBPersonID")
mums <- left_join(mums,preg_matrecs_mum,by="BiBPersonID")
mums <- left_join(mums,preg_matrecs_preg,by=c("BiBPersonID","BiBPregNumber"))
mums <- left_join(mums,preg_eclprg,by=c("BiBPersonID","BiBPregNumber"))

# create dad's data at pregnancy level
dads <- person_cohort_info[person_cohort_info$ParticipantType=="Father",1] 
dads <- left_join(dads,fathers_baseline,by="BiBPersonID")
GU_adults_dads <- GU_adult[GU_adult$BiBPersonID %in% dads$BiBPersonID,]
names(GU_adults_dads)[-1]<-paste0(names(GU_adults_dads)[-1],"_dad")
dads <- left_join(dads,GU_adults_dads,by="BiBPersonID")

# merge mums, dads and children
raw_dat <- children
raw_dat$epoch_child_id <- raw_dat$BiBPersonID
raw_dat$BiBPersonID <-NULL
raw_dat$BiBPregNumber <-as.numeric(raw_dat$BiBPregNumber)
raw_dat <- left_join(raw_dat,mums,by=c("BiBMotherID"="BiBPersonID","BiBPregNumber"))
raw_dat <- left_join(raw_dat,dads,by=c("BiBFatherID"="BiBPersonID","BiBPregNumber"))

# save raw_dat

saveRDS(raw_dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_raw_pheno.rds")
