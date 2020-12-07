# define child age at outcome where necessary

## add extra lines for names of variables in other cohorts

#all anthro outcomes taken from CIF, F7 or F9 clinics:
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 1 or 2"))] <-names(dat[grep(names(dat),pattern="stage1_cif|covs_stage1_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 3 or 4"))] <-names(dat[grep(names(dat),pattern="stage2_cif|covs_stage2_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 5, 6 or 7"))] <-names(dat[grep(names(dat),pattern="stage3_f7|covs_stage3_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(anthro_outcomes))&(key$outcome_time=="age 8, 9 or 10"))] <-names(dat[grep(names(dat),pattern="stage4_f9|covs_stage4_timepoint")])

#all sdq outcomes taken from J, KQ or KU questionnaires:
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 3 or 4"))] <-names(dat[grep(names(dat),pattern="stage2_j|covs_stage2_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 5, 6 or 7"))] <-names(dat[grep(names(dat),pattern="stage3_kq|covs_stage3_timepoint")])
key$child_age_covariates[which((key$outcome%in%c(sdq_outcomes))&(key$outcome_time=="age 8, 9 or 10"))] <-names(dat[grep(names(dat),pattern="stage4_kq|covs_stage4_timepoint")])

#all cognitive outcomes taken from CIF or F8 clinics:
key$child_age_covariates[which(key$outcome%in%c(cognitive_outcomes)&key$outcome_time=="age 3 or 4")] <-names(dat[grep(names(dat),pattern="stage2_cif49|covs_stage2_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cognitive_outcomes)&key$outcome_time=="age 8, 9 or 10")] <-names(dat[grep(names(dat),pattern="stage4_f8|covs_stage4_timepoint")])

#all mfq (depressive symptoms) outcomes taken from F10 clinic:
key$child_age_covariates[which(key$outcome%in%c(depression_outcomes)&key$outcome_time=="age 8, 9 or 10")] <-names(dat[grep(names(dat),pattern="stage4_f10|covs_stage4_timepoint")])

#all scdc (autistic traits) outcomes taken from KR questionnaire:
key$child_age_covariates[which(key$outcome%in%c(social_outcomes)&key$outcome_time=="age 5, 6 or 7")] <-names(dat[grep(names(dat),pattern="stage3_kr|covs_stage3_timepoint")])

#all cardio outcomes taken from CIF, F7 or F9 clinics:
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 1 or 2")] <-names(dat[grep(names(dat),pattern="stage1_cif|covs_stage1_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 3 or 4")] <-names(dat[grep(names(dat),pattern="stage2_cif|covs_stage2_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 5, 6 or 7")] <-names(dat[grep(names(dat),pattern="stage3_f7|covs_stage3_timepoint")])
key$child_age_covariates[which(key$outcome%in%c(cardio_outcomes)&key$outcome_time=="age 8, 9 or 10")] <-names(dat[grep(names(dat),pattern="stage4_f9|covs_stage4_timepoint")])
