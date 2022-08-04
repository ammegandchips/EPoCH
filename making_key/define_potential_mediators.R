# define potential mediators (gestage, birthweight, passive smoke before 2, caffeine before 2, alcohol before 2, child's PRS where exposure == PRS)

# gestational age for everything apart from sga and lga (which are already adjusted for ga)
key$potential_mediators_ga<-NA
key$potential_mediators_ga[-grep(key$outcome,pattern="sga|lga")] <-names(dat)[grep(names(dat),pattern="gestage")]

# birthweight for everything apart from birth body size outcomes
key$potential_mediators_bw<-NA
key$potential_mediators_bw[-which(key$outcome_time=="at birth"&key$outcome%in%anthro_outcomes)] <-"anthro_birthweight"

#breastfeeding for outcomes beyond birth (i.e. anything apart from birth body size outcomes and cord blood measures)
#key$potential_mediators_bf<-NA
#key$potential_mediators_bf[-which(key$outcome_time=="at birth"&key$outcome%in%c(cardio_outcomes,anthro_outcomes))]<-"covs_breastfeeding_ordinal"

#passive smoking for outcomes beyond birth (i.e. anything apart from birth body size and cord blood outcomes)
key$potential_mediators_ps<-NA
key$potential_mediators_ps[-which(key$outcome_time=="at birth"&key$outcome%in%c(anthro_outcomes,cardio_outcomes))] <-"covs_passivesmk_child_before2_binary"

#caffeine consumption before 2 for outcomes beyond birth (i.e. anything apart from birth body size outcomes)
key$potential_mediators_ca<-NA
key$potential_mediators_ca[-which((key$exposure_class%in%c("alcohol consumption","smoking","physical activity"))|(key$outcome_time=="at birth"&key$outcome%in%anthro_outcomes))]<-"covs_caffeinedrinks_child_before2_binary"

#alcohol consumption before 2 for outcomes beyond birth (i.e. anything apart from birth body size outcomes and cord measures)
key$potential_mediators_al<-NA
key$potential_mediators_al[-which((key$exposure_class%in%c("caffeine consumption","smoking","physical activity"))|(key$outcome_time=="at birth"&key$outcome%in%c(anthro_outcomes,cardio_outcomes)))]<-"covs_alcohol_child_before2_binary"

#child's prs
key$potential_mediators_prs<-NA
key$potential_mediators_prs[which(key$exposure_subclass%in%c("polygenic risk score"))]<-paste0()


key$potential_mediators <- apply(key[,c("potential_mediators_ga","potential_mediators_bw","potential_mediators_ps","potential_mediators_ca","potential_mediators_al")],1,function(x) paste(na.omit(x),collapse=","))
key$potential_mediators[key$potential_mediators==""]<-NA
key[,c("potential_mediators_ga","potential_mediators_bw","potential_mediators_ps","potential_mediators_ca","potential_mediators_al")]<-NULL
