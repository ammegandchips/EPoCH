# define child age at outcome where necessary

## ALSPAC
if(cohort=="ALSPAC"|cohort=="alspac"){
#all anthro outcomes taken from CIF, F7 or F9 clinics:
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 1 to 2"))] <-names(dat[grep(names(dat),pattern="stage1_cif|covs_stage1_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="stage2_cif|covs_stage2_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="stage3_f7|covs_stage3_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 8 to 11"))] <-names(dat[grep(names(dat),pattern="stage4_f9|covs_stage4_timepoint")])

#all sdq outcomes taken from J, KQ or KU questionnaires:
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="stage2_j|covs_stage2_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="stage3_kq|covs_stage3_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 8 to 11"))] <-names(dat[grep(names(dat),pattern="stage4_kq|covs_stage4_timepoint")])

#all cognitive outcomes taken from CIF or F8 clinics:
key$child_age_covariates[which(key$outcome%in%c(cognitive_outcomes)&key$outcome_time=="age 3 to 4")] <-names(dat[grep(names(dat),pattern="stage2_cif|covs_stage2_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cognitive_outcomes)&key$outcome_time=="age 8 to 11")] <-names(dat[grep(names(dat),pattern="stage4_f8|covs_stage4_timepoint")])

#all mfq (depressive symptoms) outcomes taken from F10 clinic:
key$child_age_covariates[which(key$outcome%in%c(depression_outcomes)&key$outcome_time=="age 8 to 11")] <-names(dat[grep(names(dat),pattern="stage4_f10|covs_stage4_timepoint")])

#all scdc (autistic traits) outcomes taken from KR questionnaire:
key$child_age_covariates[which(key$outcome%in%c(scdc_outcomes)&key$outcome_time=="age 5 to 7")] <-names(dat[grep(names(dat),pattern="stage3_kr|covs_stage3_timepoint")])

#all cardio outcomes taken from CIF, F7 or F9 clinics:
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 1 to 2")] <-names(dat[grep(names(dat),pattern="stage1_cif|covs_stage1_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 3 to 4")] <-names(dat[grep(names(dat),pattern="stage2_cif|covs_stage2_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 5 to 7")] <-names(dat[grep(names(dat),pattern="stage3_f7|covs_stage3_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 8 to 11")] <-names(dat[grep(names(dat),pattern="stage4_f9|covs_stage4_timepoint")])

}

## MCS
if(cohort=="MCS"|cohort=="mcs"){
# anthro stage 3 was c
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="first year"))] <-names(dat[grep(names(dat),pattern="age_child_stage0")])
key$child_age_covariates[which((key$outcome=="anthro_weight_stage0")&(key$outcome_time=="first year"))] <-names(dat[grep(names(dat),pattern="age_child_stage0wt")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="age_child_stage2")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3c")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 8 to 11"))] <-names(dat[grep(names(dat),pattern="age_child_stage4")])

# sdq stage 3 was d
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="age_child_stage2")])
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3d")])

# csbq stage 3 was c
key$child_age_covariates[which((key$outcome=="neuro_csbqindependence_stage3")&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3c")])
key$child_age_covariates[which((key$outcome=="neuro_csbqemotionaldysreg_stage3")&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3c")])

# naming vocab, spatial awareness, problemsolving stage 3 was c
key$child_age_covariates[which((key$outcome%in%c(cognitive_outcomes))&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="age_child_stage2")])
key$child_age_covariates[which((key$outcome%in%c(cognitive_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3c")])

# school readiness (b)
key$child_age_covariates[which((key$outcome=="neuro_cognition_schoolreadiness_stage2")&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="age_child_stage2")])

# reading and number skills stage 3 was d
key$child_age_covariates[which((key$outcome=="neuro_cognition_numberskills_stage3")&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3d")])
key$child_age_covariates[which((key$outcome=="neuro_cognition_reading_stage3")&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="age_child_stage3d")])

}

if(cohort=="BIB"|cohort=="bib"|cohort=="BiB"){
  
  key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="first year"))] <-names(dat[grep(names(dat),pattern="covs_age_stage0_growthtimepoint")])
  key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 1 to 2"))] <-names(dat[grep(names(dat),pattern="covs_age_stage1_growthtimepoint")])
  key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 3 to 4"))] <-names(dat[grep(names(dat),pattern="covs_age_stage2_growthtimepoint")])
  key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="covs_age_stage3_growthtimepoint")])
  key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 8 to 11"))] <-names(dat[grep(names(dat),pattern="covs_age_stage4_growthtimepoint")])

  key$child_age_covariates[which((key$outcome%in%c(biomarker_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="covs_age_stage3_bloodtesttimepoint")])
  key$child_age_covariates[which((key$outcome%in%c(biomarker_outcomes))&(key$outcome_time=="age 8 to 11"))] <-names(dat[grep(names(dat),pattern="covs_age_stage4_bloodtesttimepoint")])
  
  key$child_age_covariates[which((key$outcome%in%c(bp_outcomes))&(key$outcome_time=="age 5 to 7"))] <-names(dat[grep(names(dat),pattern="covs_age_stage3_bptimepoint")])
  key$child_age_covariates[which((key$outcome%in%c(bp_outcomes))&(key$outcome_time=="age 8 to 11"))] <-names(dat[grep(names(dat),pattern="covs_age_stage4_bptimepoint")])
}






