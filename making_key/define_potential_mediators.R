##NEED TO UPDATE WITH MOBA VERSION BEFORE PUBLICATION##

# define potential mediators (gestage, birthweight, passive smoke before 2, caffeine before 2, alcohol before 2, child's PRS where exposure == PRS)

# gestational age for everything apart from sga and lga (which are already adjusted for ga) and where the exposure is a PRS
key$potential_mediators_ga<-names(dat)[grep(names(dat),pattern="gestage")]
key$potential_mediators_ga[grep(key$outcome,pattern="sga|lga")] <-NA
key$potential_mediators_ga[key$exposure_subclass=="polygenic risk score"] <-NA

# birthweight for everything apart from birth body size outcomes
key$potential_mediators_bw<-"anthro_birthweight"
key$potential_mediators_bw[which(key$outcome_time=="delivery"&key$outcome%in%anthro_outcomes)] <-NA
key$potential_mediators_bw[key$exposure_subclass=="polygenic risk score"] <-NA

#breastfeeding for outcomes beyond birth (i.e. anything apart from birth body size outcomes and cord blood measures)
#key$potential_mediators_bf<-NA
#key$potential_mediators_bf[-which(key$outcome_time=="delivery"&key$outcome%in%c(cardio_outcomes,anthro_outcomes))]<-"covs_breastfeeding_ordinal"

#passive smoking for outcomes beyond birth (i.e. anything apart from birth body size and cord blood outcomes)
key$potential_mediators_ps<-"covs_passivesmk_child_before2_binary"
key$potential_mediators_ps[which(key$outcome_time=="delivery"&key$outcome%in%c(anthro_outcomes,cardio_outcomes))] <-NA
key$potential_mediators_ps[key$exposure_subclass=="polygenic risk score"] <-NA

#caffeine consumption before 2 for outcomes beyond birth (i.e. anything apart from birth body size outcomes)
key$potential_mediators_ca<-"covs_caffeinedrinks_child_before2_binary"
key$potential_mediators_ca[which((key$exposure_class%in%c("alcohol consumption","smoking","physical activity"))|(key$outcome_time=="delivery"&key$outcome%in%anthro_outcomes))]<-NA
key$potential_mediators_ca[key$exposure_subclass=="polygenic risk score"] <-NA

#alcohol consumption before 2 for outcomes beyond birth (i.e. anything apart from birth body size outcomes and cord measures)
key$potential_mediators_al<-"covs_alcohol_child_before2_binary"
key$potential_mediators_al[which((key$exposure_class%in%c("caffeine consumption","smoking","physical activity"))|(key$outcome_time=="delivery"&key$outcome%in%c(anthro_outcomes,cardio_outcomes)))]<-NA
key$potential_mediators_al[key$exposure_subclass=="polygenic risk score"] <-NA

#child's prs and PCs
key$potential_mediators_prs<-NA
key$potential_mediators_prs[key$exposure_subclass=="polygenic risk score"]<-str_replace(key$exposure[key$exposure_subclass=="polygenic risk score"],"mother|father","child")

key$child_PCs<-NA
key$child_PCs[key$exposure_subclass=="polygenic risk score"]<-paste0("childpc",1:10,collapse=",")

key$potential_mediators <- apply(key[,c("potential_mediators_ga","potential_mediators_bw","potential_mediators_ps","potential_mediators_ca","potential_mediators_al","potential_mediators_prs","child_PCs")],1,function(x) paste(na.omit(x),collapse=","))
key$potential_mediators[key$potential_mediators==""]<-NA
key[,c("potential_mediators_ga","potential_mediators_bw","potential_mediators_ps","potential_mediators_ca","potential_mediators_al","potential_mediators_prs","child_PCs")]<-NULL
