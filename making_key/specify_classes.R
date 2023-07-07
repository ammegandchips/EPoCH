## NEED TO SORT OUT THE AUTISM VARIABLES STILL

# Specify classes and other information for each exposure/outcome 

## exposure class
key$exposure_class[key$exposure %in% diet_exposures]<-"diet"
key$exposure_class[key$exposure %in% sep_exposures]<-"socioeconomic position"
key$exposure_class[key$exposure %in% smoking_exposures]<-"smoking"
key$exposure_class[key$exposure %in% alcohol_exposures]<-"alcohol consumption"
key$exposure_class[key$exposure %in% caffeine_exposures]<-"caffeine consumption"
key$exposure_class[key$exposure %in% physact_exposures]<-"physical activity"

## exposure subclass
key$exposure_subclass <-"basic"
key$exposure_subclass[key$exposure %in% smoking_exposures] <-"active smoking"
key$exposure_subclass[key$exposure %in% alcohol_exposures] <-"any drinking"
key$exposure_subclass[key$exposure %in% caffeine_exposures] <-"any source"
key$exposure_subclass[key$exposure %in% meddiet_rmed]<-"mediterranean diet rmed"
key$exposure_subclass[key$exposure %in% meddiet_rmed2]<-"mediterranean diet rmed2"
key$exposure_subclass[grep("covs_edu_father|covs_edu_mother",key$exposure)]<-"highest education"
key$exposure_subclass[grep("covs_occup_father|covs_occup_mother",key$exposure)]<-"occupation"
key$exposure_subclass[key$exposure %in% coffee_exposures]<-"coffee"
key$exposure_subclass[key$exposure %in% tea_exposures]<-"tea"
key$exposure_subclass[key$exposure %in% cola_exposures]<-"cola"
key$exposure_subclass[key$exposure %in% binge_alcohol_exposures]<-"binge drinking"
key$exposure_subclass[key$exposure %in% passive_smoking_exposures]<-"passive smoke exposure"
key$exposure_subclass[key$exposure %in% prs_exposures]<-"polygenic risk score"

## timing of exposure
key$exposure_time[grep(key$exposure,pattern="edu|occup")]<-"at study recruitment"
key$exposure_time[grep(key$exposure,pattern="before11")]<-"early onset"
key$exposure_time[grep(key$exposure,pattern="life")]<-"ever in life"
key$exposure_time[grep(key$exposure,pattern="ever_pregnancy|bingepreg|mother_passive")]<-"ever in pregnancy"
key$exposure_time[grep(key$exposure,pattern="preconception|startpregnancy")]<-"preconception"
key$exposure_time[grep(key$exposure,pattern="firsttrim|binge1")]<-"first trimester"
key$exposure_time[grep(key$exposure,pattern="secondtrim|binge2")]<-"second trimester"
key$exposure_time[grep(key$exposure,pattern="thirdtrim|binge3")]<-"third trimester"
key$exposure_time[grep(key$exposure,pattern="postnatal")]<-"first two postnatal years"
key$exposure_time[grep(key$exposure,pattern="initiation")]<-"initiation"
key$exposure_time[grep(key$exposure,pattern="age_init")]<-"age at initiation"
key$exposure_time[grep(key$exposure,pattern="cessation")]<-"cessation"
key$exposure_time[grep(key$exposure,pattern="cigs_pd")]<-"heaviness"
key$exposure_time[grep(key$exposure,pattern="score_father_caff|score_mother_caff")]<-"caffeine"
key$exposure_time[grep(key$exposure,pattern="score_father_alcohol|score_mother_alcohol")]<-"alcohol"
key$exposure_time[grep(key$exposure,pattern="_pa_")]<-"physical activity"

## person exposed
key$person_exposed <- "mother"
key$person_exposed[grep(key$exposure,pattern="father")]<-"partner"
 
## source of information on paternal data
key$exposure_source <- "self-reported"
key$exposure_source[grep(key$exposure,pattern="mreport")]<-"reported by study mother"
key$exposure_source[grep(key$exposure,pattern="anyreport")]<-"reported by self or study mother"
 
## type of exposure variable
key$exposure_type <- "continuous"
key$exposure_type[grep(key$exposure,pattern="ordinal")]<-"ordinal"
key$exposure_type[grep(key$exposure,pattern="binary")]<-"binary"
 
## class of outcome
key$outcome_class[key$outcome %in% anthro_outcomes]<-"body size and composition"
key$outcome_class[key$outcome %in% neuro_outcomes]<-"psychosocial and cognitive"
key$outcome_class[key$outcome %in% immuno_outcomes]<-"immunological"
key$outcome_class[key$outcome %in% negcon_outcomes]<-"negative control outcomes"
key$outcome_class[key$outcome %in% biomarker_outcomes]<-"serum biomarkers"
key$outcome_class[key$outcome %in% bp_outcomes]<-"blood pressure"
key$outcome_class[key$outcome %in% peri_outcomes]<-"perinatal survival"
 
## subclass of outcome (level 1)
key$outcome_subclass1[grep(pattern="survive_one_year",key$outcome)]<-"alive at 1y"
key$outcome_subclass1[grep(pattern="live_birth",key$outcome)]<-"live birth"
key$outcome_subclass1[grep(pattern="miscarriage",key$outcome)]<-"miscarriage" #before 20 weeks
key$outcome_subclass1[grep(pattern="fetal_death",key$outcome)]<-"fetal death >20 wks" #after 20 weeks

key$outcome_subclass1[key$outcome %in% asthma_outcomes] <-"asthma"
key$outcome_subclass1[key$outcome %in% eczema_outcomes] <-"eczema"
key$outcome_subclass1[key$outcome %in% wheeze_outcomes] <-"wheezing"
key$outcome_subclass1[key$outcome %in% allergy_outcomes] <-"allergy"

key$outcome_subclass1[key$outcome %in% bmi_outcomes] <-"BMI"
key$outcome_subclass1[key$outcome %in% overweight_outcomes] <-"BMI"
key$outcome_subclass1[key$outcome %in% obese_outcomes] <-"BMI"
key$outcome_subclass1[key$outcome %in% waist_outcomes] <-"waist circumference"
key$outcome_subclass1[key$outcome %in% weight_outcomes] <-"weight"
key$outcome_subclass1[key$outcome %in% height_outcomes] <-"height"
key$outcome_subclass1[key$outcome %in% birthweight_outcomes] <-"birthweight"
key$outcome_subclass1[key$outcome %in% birthlength_outcomes] <-"birthlength"
key$outcome_subclass1[key$outcome %in% headcirc_outcomes] <-"head circumference"
key$outcome_subclass1[key$outcome %in% fatmass_outcomes] <-"fat mass"

key$outcome_subclass1[key$outcome %in% c(depression_outcomes, sdq_outcomes,aggression_outcomes,cbcl_outcomes,hyperactivity_outcomes,csbq_outcomes)] <-"behaviour and affect"
key$outcome_subclass1[key$outcome %in% c(cognitive_outcomes,cognitive_schoolreadiness_outcomes)] <-"cognitive ability and school readiness"
key$outcome_subclass1[key$outcome %in% c(autistic_trait_outcomes,asq_socialcomm_outcomes)] <-"autistic traits and social communication"

key$outcome_subclass1[key$outcome %in% mice_outcomes] <-"home invaded by mice"
key$outcome_subclass1[key$outcome %in% pigeon_outcomes] <-"home invaded by pigeons"
key$outcome_subclass1[key$outcome %in% lefthand_outcomes] <-"child can draw well with left hand"

key$outcome_subclass1[key$outcome %in% sbp_outcomes] <-"systolic blood pressure"
key$outcome_subclass1[key$outcome %in% dbp_outcomes] <-"diastolic blood pressure"

key$outcome_subclass1[key$outcome %in% ldl_outcomes] <-"LDL cholesterol"
key$outcome_subclass1[key$outcome %in% hdl_outcomes] <-"HDL cholesterol"
key$outcome_subclass1[key$outcome %in% chol_outcomes] <-"total cholesterol"
key$outcome_subclass1[key$outcome %in% apoa_outcomes] <-"apo A1"
key$outcome_subclass1[key$outcome %in% apob_outcomes] <-"apo B"
key$outcome_subclass1[key$outcome %in% il6_outcomes] <-"IL6"
key$outcome_subclass1[key$outcome %in% crp_outcomes] <-"CRP"
key$outcome_subclass1[key$outcome %in% glucose_outcomes] <-"glucose"
key$outcome_subclass1[key$outcome %in% insulin_outcomes] <-"insulin"
key$outcome_subclass1[key$outcome %in% trig_outcomes] <-"triglycerides"

## subclass of outcome (level 2)
key$outcome_subclass2<-key$outcome_subclass1

key$outcome_subclass2[key$outcome %in% overweight_outcomes] <-"BMI >25"
key$outcome_subclass2[key$outcome %in% obese_outcomes] <-"BMI >30"
key$outcome_subclass2[grep(key$outcome,pattern="sds")] <-"age and sex adjusted BMI"
key$outcome_subclass2[grep(key$outcome,pattern="sga")] <-"small for gestational age"
key$outcome_subclass2[grep(key$outcome,pattern="lga")] <-"large for gestational age"
key$outcome_subclass2[grep(key$outcome,pattern="birthweight_low")] <-"birthweight <2500g"
key$outcome_subclass2[grep(key$outcome,pattern="birthweight_high")] <-"birthweight >4500g"
key$outcome_subclass2[grep(key$outcome,pattern="fmi")] <-"fat mass index"
key$outcome_subclass2[grep(key$outcome,pattern="fatpc")] <-"fat mass percentage"

key$outcome_subclass2[key$outcome %in% scdc_outcomes] <-"social and communication disorder (SCDC)" #social and communications disorders (SCDC) scale
key$outcome_subclass2[key$outcome %in% asq_socialcomm_outcomes]<-"social and communication development (ASQ)" #ages and stages questionnaire (ASQ)
key$outcome_subclass2[key$outcome %in% cbcl_outcomes] <-"total behavioural score (CBCL)"
key$outcome_subclass2[key$outcome %in% csbqindependence_outcomes] <-"social behaviour: independence"
key$outcome_subclass2[key$outcome %in% csbqemotional_outcomes] <-"social behaviour: emotional dysregulation"
key$outcome_subclass2[key$outcome %in% autism_outcomes] <-"autism"

key$outcome_subclass2[key$outcome %in% hyperactivity_outcomes] <-"hyperactivity/inattention"
key$outcome_subclass2[key$outcome %in% emotional_outcomes] <-"emotional symptoms"
key$outcome_subclass2[key$outcome %in% conduct_outcomes] <-"conduct problems"
key$outcome_subclass2[key$outcome %in% peer_outcomes] <-"peer relationship problems"
key$outcome_subclass2[key$outcome %in% prosocial_outcomes] <-"prosocial behaviour"
key$outcome_subclass2[key$outcome %in% totalsdq_outcomes] <-"total difficulties (SDQ)"
key$outcome_subclass2[key$outcome %in% internalising_outcomes] <-"internalising traits"
key$outcome_subclass2[key$outcome %in% externalising_outcomes] <-"externalising traits"
key$outcome_subclass2[key$outcome %in% aggression_outcomes] <-"aggression"

key$outcome_subclass2[key$outcome %in% cognitive_performance_outcomes] <-"performance intelligence"
key$outcome_subclass2[key$outcome %in% cognitive_verbal_outcomes] <-"verbal intelligence"
key$outcome_subclass2[key$outcome %in% cognitive_total_outcomes] <-"total intelligence"
key$outcome_subclass2[key$outcome %in% cognitive_numberskills_outcomes] <-"number skills"
key$outcome_subclass2[key$outcome %in% cognitive_namingvocab_outcomes] <-"naming vocabulary"
key$outcome_subclass2[key$outcome %in% cognitive_reading_outcomes] <-"reading skills"
key$outcome_subclass2[key$outcome %in% cognitive_problemsolving_outcomes] <-"problem solving"
key$outcome_subclass2[key$outcome %in% cognitive_spatialawareness_outcomes] <-"spatial awareness"
key$outcome_subclass2[key$outcome %in% cognitive_schoolreadiness_outcomes] <-"school readiness" 


key$outcome_subclass2[key$outcome %in% dog_allergy_outcomes] <-"dog allergy"
key$outcome_subclass2[key$outcome %in% cat_allergy_outcomes] <-"cat allergy"
key$outcome_subclass2[key$outcome %in% pet_allergy_outcomes] <-"pet allergy"
key$outcome_subclass2[key$outcome %in% food_allergy_outcomes] <-"food allergy"
key$outcome_subclass2[key$outcome %in% dust_allergy_outcomes] <-"dustmite allergy"
key$outcome_subclass2[key$outcome %in% pollen_allergy_outcomes] <-"pollen/hay allergy"
key$outcome_subclass2[key$outcome %in% insect_allergy_outcomes] <-"insect allergy"
key$outcome_subclass2[key$outcome %in% any_allergy_outcomes] <-"any allergy"
 
## timing of outcome
key$outcome_time[grep(key$outcome,pattern="birth")]<-"delivery"
key$outcome_time[grep(pattern="survive_one_year",key$outcome)]<-"first year"
key$outcome_time[grep(pattern="miscarriage",key$outcome)]<-"pregnancy" #before 20 weeks
key$outcome_time[grep(pattern="fetal_death",key$outcome)]<-"pregnancy" #after 20 weeks

key$outcome_time[grep(key$outcome,pattern="stage0")]<-"first year"
key$outcome_time[grepl(key$outcome,pattern="stage0")&key$outcome_class=="serum biomarkers"]<-"delivery"
key$outcome_time[grep(key$outcome,pattern="stage1")]<-"age 1 to 2"
key$outcome_time[grep(key$outcome,pattern="stage2")]<-"age 3 to 4"
key$outcome_time[grep(key$outcome,pattern="stage3")]<-"age 5 to 7"
key$outcome_time[grep(key$outcome,pattern="stage4")]<-"age 8 to 11"
key$outcome_time[grep(key$outcome,pattern="allstages|negcon")]<-"any time in childhood"
 
## type of outcome variable
key$outcome_type <- "continuous"
key$outcome_type[grep(key$outcome,pattern="ordinal")]<-"ordinal"
key$outcome_type[grep(key$outcome,pattern="binary")]<-"binary"
 