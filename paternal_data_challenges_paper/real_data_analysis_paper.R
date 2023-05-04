###############################################
## Paternal participation and selection bias ##
###############################################

library(tidyverse)

#set wd
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/paternal_data_challenges_paper/")

#load data
bib <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_pheno.rds")
alspac <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds")
mcs <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno.rds")

#select only unique pregnancies (i.e. remove all but one children from multiple pregnancies)
bib_unique <- bib[which(bib$BiBPregNumber==1),]
alspac_unique <- data.frame(alspac[!duplicated(alspac$aln),])
mcs_unique <- data.frame(mcs[!duplicated(mcs$mcsid),]) # doesn't actually do anything in this cohort as we've already only selected one child per family

#summarise paternal participation in each cohort

pat_part <- data.frame(cohort=c("BiB","ALSPAC","MCS"),
                       mother=c(sum(is.na(bib_unique$BiBMotherID)==FALSE),
                                sum(is.na(alspac_unique$aln)==FALSE),
                                sum(is.na(mcs_unique$mcsid)==FALSE)), 
                       father=c(sum(bib_unique$paternal_participation,na.rm=T),
                                sum(alspac_unique$paternal_participation,na.rm=T),
                                sum(mcs_unique$paternal_participation,na.rm=T))
                       )
pat_part$percent <- (pat_part$father/pat_part$mother)*100

#family characteristics by partner participation

##prepare family characteristic variables
gen_new_vars <- function(df){
  
  df$mother_obese <- NA
  df$mother_obese[df$covs_bmi_mother>=30]<-1
  df$mother_obese[df$covs_bmi_mother<30]<-0
  
  df$covs_mother_edu_high <- df$covs_edu_mother
  df$covs_mother_edu_high[df$covs_edu_mother==3]<-1
  df$covs_mother_edu_high[df$covs_edu_mother<=2]<-0
  
  df$covs_mother_edu_low <- df$covs_edu_mother
  df$covs_mother_edu_low[df$covs_edu_mother==0]<-1
  df$covs_mother_edu_low[df$covs_edu_mother>=1]<-0
  
  df$covs_father_edu_high <- df$covs_edu_father
  df$covs_father_edu_high[df$covs_edu_father==3]<-1
  df$covs_father_edu_high[df$covs_edu_father<=2]<-0
  
  df$covs_father_edu_low <- df$covs_edu_father
  df$covs_father_edu_low[df$covs_edu_father==0]<-1
  df$covs_father_edu_low[df$covs_edu_father>=1]<-0
  
  df$ethnicity_white <- NA
  df$ethnicity_white[df$covs_ethnicity_mother_binary=="white"]<-1
  df$ethnicity_white[df$covs_ethnicity_mother_binary=="not white"]<-0
  
  df$ethnicity_white_father <- NA
  df$ethnicity_white_father[df$covs_ethnicity_father_binary=="white"]<-1
  df$ethnicity_white_father[df$covs_ethnicity_father_binary=="not white"]<-0
  
  if("covs_biological_father"%in%colnames(df)){
    df$biodad <- NA
    df$biodad[df$covs_biological_father=="bio_dad"]<-1
    df$biodad[df$covs_biological_father%in%c("missing","no_partner","not_bio_dad","unsure")]<-0
  }
  
  if("covs_age_mother_delivery" %in% names(df)){
    df$maternal_age_high <-NA
    df$maternal_age_high[df$covs_age_mother_delivery>=35]<-1
    df$maternal_age_high[df$covs_age_mother_delivery<35]<-0
    
    df$maternal_age_low <-NA
    df$maternal_age_low[df$covs_age_mother_delivery<=21]<-1
    df$maternal_age_low[df$covs_age_mother_delivery>21]<-0
  }else{
    df$maternal_age_high <-NA
    df$maternal_age_high[df$covs_age_mother_conception>=35]<-1
    df$maternal_age_high[df$covs_age_mother_conception<35]<-0
    
    df$maternal_age_low <-NA
    df$maternal_age_low[df$covs_age_mother_conception<=21]<-1
    df$maternal_age_low[df$covs_age_mother_conception>21]<-0
  }
  
  if("covs_age_father_delivery" %in% names(df)){
    df$paternal_age_high <-NA
    df$paternal_age_high[df$covs_age_father_delivery>=35]<-1
    df$paternal_age_high[df$covs_age_father_delivery<35]<-0
    
    df$paternal_age_low <-NA
    df$paternal_age_low[df$covs_age_father_delivery<=21]<-1
    df$paternal_age_low[df$covs_age_father_delivery>21]<-0
  }else{
    df$paternal_age_high <-NA
    df$paternal_age_high[df$covs_age_father_pregnancy>=35]<-1
    df$paternal_age_high[df$covs_age_father_pregnancy<35]<-0
    
    df$paternal_age_low <-NA
    df$paternal_age_low[df$covs_age_father_pregnancy<=21]<-1
    df$paternal_age_low[df$covs_age_father_pregnancy>21]<-0
  }
  
  df
}

bib_unique <- gen_new_vars(bib_unique)
alspac_unique <- gen_new_vars(alspac_unique)
mcs_unique <- gen_new_vars(mcs_unique)

variables <- c("mother_obese","biodad","paternal_age_low","paternal_age_high","maternal_age_low","maternal_age_high","alcohol_father_ever_pregnancy_binary_mreport","smoking_father_startpregnancy_binary_mreport","smoking_mother_ever_pregnancy_binary","alcohol_mother_ever_pregnancy_binary","covs_father_edu_high","covs_father_edu_low","covs_mother_edu_high","covs_mother_edu_low","covs_partner_lives_with_mother_prenatal","covs_married_mother_binary","anthro_birthweight_low_binary","anthro_birthweight_high_binary","covs_preterm_binary", "ethnicity_white","ethnicity_white_father")
varnames=c("Mother is obese","Partner is biological father","Partner is age <=21","Partner is age >=35","Mother is age <=21","Mother is age >=35","Partner drank alcohol in pregnancy","Partner smoked in pregnancy","Mother smoked in pregnancy","Mother drank alcohol in pregnancy","Partner has a degree","Partner has no qualifications","Mother has a degree","Mother has no qualifications","Mother lived with partner before birth","Mother is married","Baby's birthweight is <2.5kg","Baby's birthweight is >4.5kg","Baby was delivered preterm", "Mother is white","Partner is white")

##run logistic regressions to calculate odds ratios and CIs
logistic_reg <- function(y,x,confounders,data){
  if(is.null(confounders)){
    form <- paste0(y,"~",x)
  }else{
    form <- paste0(y,"~",x,"+",paste0(confounders,collapse="+"))
  }
  res <- try(glm(as.formula(form),data,family="binomial"))
  if(class(res)[1]=="try-error"|class(summary(res)$coefficients)[1]=="numeric"){
    final <- rep(NA,4)
  }else{
      final <-try(summary(res)$coef[2,])
  }
  if(class(final)=="try-error"){
    final <- rep(NA,4)
  }else{
  final
  }
}

alspac_results <- lapply(variables[variables %in% names(alspac_unique)],logistic_reg,x="paternal_participation",data=alspac_unique,confounders=NULL)
bib_results <- lapply(variables[variables %in% names(bib_unique)],logistic_reg,x="paternal_participation",data=bib_unique,confounders=NULL)
mcs_results <- lapply(variables[variables %in% names(mcs_unique)],logistic_reg,x="paternal_participation",data=mcs_unique,confounders=NULL)

##prepare results
prep_results <- function(cohort_results,cohort_data,cohort_name){
names(cohort_results)<-varnames[variables %in% names(cohort_data)]
if(any(is.na(unlist(cohort_results)))){
results_tb <-as.data.frame(t(bind_rows(cohort_results,.id="outcome")))
colnames(results_tb)<-c("est","se","z","p")
results_tb$outcome <-row.names(results_tb)
row.names(results_tb)<-NULL
}else{
  results_tb <-bind_rows(cohort_results,.id="outcome")
  colnames(results_tb)<-c("outcome","est","se","z","p")
}
results_tb$lci <- results_tb$est - (1.96*results_tb$se)
results_tb$uci <- results_tb$est + (1.96*results_tb$se)
results_tb$or <- exp(results_tb$est)
results_tb$or_lci <- exp(results_tb$lci)
results_tb$or_uci <- exp(results_tb$uci)
results_tb$cohort <- cohort_name
results_tb[,c("cohort","outcome","or","or_lci","or_uci","p")]
}

alspac_results_df <-prep_results(alspac_results,alspac_unique,"ALSPAC")
bib_results_df <-prep_results(bib_results,bib_unique,"BiB")
mcs_results_df <-prep_results(mcs_results,mcs_unique,"MCS")

all_results <- bind_rows(list(alspac_results_df,bib_results_df,mcs_results_df))

all_results$person <- NA
all_results$person[grep(all_results$outcome,pattern="Partner")]<-"Partner"
all_results$person[grep(all_results$outcome,pattern="Mother")]<-"Mother"
all_results$person[grep(all_results$outcome,pattern="Baby")]<-"Birth"
all_results <-all_results[order(all_results$or),]
all_results$outcome <- factor(all_results$outcome,ordered = T, levels=unique(all_results$outcome))

plot1<-  ggplot(all_results)+
  geom_vline(aes(xintercept = 1), size = .25, linetype = "dashed", colour= "grey40" ) +
  geom_point(aes(x=or,y=outcome,colour=cohort[1]),size=3,shape=15)+
  geom_errorbarh(aes(xmin=or_lci,xmax=or_uci,y=outcome,colour=cohort[1]),height=0,size=0.5)+
  facet_grid(person~cohort,space="free_y",scales="free")+
  labs(title= "Associations between partner participation and\nfamily characteristics") +
  theme_grey()+
  xlab("Odds ratio")+
  theme(axis.text.x=element_text(size=8),axis.text.y=element_text(size=8),axis.ticks.y=element_blank(),axis.title.y=element_blank(),panel.grid.minor = element_blank(),panel.grid.major = element_blank(),panel.spacing = unit(.2, "lines"),legend.title=element_blank(),legend.position="none",plot.title = element_text(hjust = 0.5))+
  scale_x_continuous(breaks = c(0.25,0.5,1,2,4,8,512),labels=c(0.25,0.5,1,2,4,8,512)) +
  coord_trans(x = 'log')

pdf("mother_characteristics_by_partner_participation.pdf",height=5,width=7)
plot1
dev.off()

## New Figure requested by Kate
## Maternal smoking --> BW in complet sample, sample w pp, sample with npp, complete sample adj for psmoking, complete sample adj for psmoking and factors that affect participation (ethnicity, education, co-habitation, being bio parent)

#table of models to run
models <- data.frame(modelname=c("Complete sample","Sample with participating partners","Sample with non-participating partners","Complete sample, adjusted for other parent's smoking",
                                 "Complete sample","Sample with participating partners","Sample with non-participating partners","Complete sample, adjusted for other parent's smoking",
                                 "Complete sample","Sample with participating partners","Sample with non-participating partners","Complete sample, adjusted for other parent's smoking",
                                 "Complete sample","Sample with participating partners","Sample with non-participating partners","Complete sample, adjusted for other parent's smoking"),
                     exposure=c(rep("smoking_mother_ever_pregnancy_binary",8),rep("smoking_father_ever_pregnancy_binary",8)),
                     data=c("complete_cohort","partners_cohort", "nonpartners_cohort", "complete_cohort",
                            "complete_cohort","partners_cohort", "nonpartners_cohort", "complete_cohort",
                            "complete_cohort","partners_cohort", "nonpartners_cohort", "complete_cohort",
                            "complete_cohort","partners_cohort", "nonpartners_cohort", "complete_cohort"),
                     confounders=c(NA,NA,NA,"smoking_father_ever_pregnancy_binary",
                                   rep("covs_ethnicity_mother",3),"covs_ethnicity_mother,smoking_father_ever_pregnancy_binary",
                                   NA,NA,NA,"smoking_mother_ever_pregnancy_binary",
                                   rep("covs_ethnicity_father",2),NA,"covs_ethnicity_father,smoking_mother_ever_pregnancy_binary")
)

run_analysis <- function(cohortname,cohort_data){
  complete_cohort <- cohort_data
  partners_cohort <- cohort_data[cohort_data$paternal_participation==1,]
  nonpartners_cohort <- cohort_data[-which(cohort_data$paternal_participation==1),]
  
  mod1<-summary(lm(anthro_birthweight_zscore ~ smoking_mother_ever_pregnancy_binary, data=complete_cohort))$coef[2,]
  mod2<-summary(lm(anthro_birthweight_zscore ~ smoking_mother_ever_pregnancy_binary, data=partners_cohort))$coef[2,]
  mod3<-summary(lm(anthro_birthweight_zscore ~ smoking_mother_ever_pregnancy_binary, data=nonpartners_cohort))$coef[2,]
  mod4<-summary(lm(anthro_birthweight_zscore ~ smoking_mother_ever_pregnancy_binary + smoking_father_ever_pregnancy_binary, data=complete_cohort))$coef[2,]
SAME BUT WITH ETHNICITY
SAME BUT FOR PATERNAL SMOKING (NONPARTNERS WILL BE NULL)
  }

ALSO NEED TO ADD ADJ FOR FACTORS THAT AFFECT PARTICIPATION

              
