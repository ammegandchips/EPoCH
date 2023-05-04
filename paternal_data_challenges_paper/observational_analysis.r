###############################################
## Paternal participation and selection bias ##
###############################################

#set wd
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/paternal_data_challenges_paper/")

#load data

##first questionnaires
bib_all <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_pheno.rds")
alspac <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds")
mcs <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno.rds")

library(dplyr)
library(epitools)

#select only unique pregnancies (i.e. remove all but one children from multiple pregnancies)
bib_all_unique <- bib_all[which(bib_all$BiBPregNumber==1),]
alspac_unique <- data.frame(alspac[!duplicated(alspac$aln),])
mcs_unique <- data.frame(mcs[!duplicated(mcs$mcsid),]) # doesn't actually do anything in this cohort as we've already only selected one child per family

## HAVE STOPPED RUNNING THESE LINES FOLLOWING DEBORAH'S COMMENTS (PATERNITY VARIABLE NOT GREAT AND WHY DO WE EXCLUDE NON-BIOLOGICAL DADS IF WE THINK POSSIBLE INDIRECT EFFECT)
#set all paternal data to missing if partner is not the biological dad, or if paternity status is missing or mother is unsure
#alspac_unique[alspac_unique$covs_biological_father%in%c("not_bio_dad","unsure","missing"),grep(colnames(alspac_unique),pattern="father")]<-NA
#mcs_unique[mcs_unique$covs_biological_father%in%c("not_bio_dad","unsure","missing"),grep(colnames(mcs_unique),pattern="father")]<-NA

# set paternal participation to 0 if mum has no partner, partner is not the biological dad (obviously there is a biological father somewhere, but he's not participating in the study)
#alspac_unique[alspac_unique$covs_biological_father%in%c("not_bio_dad","no_partner"),grep(colnames(alspac_unique),pattern="paternal_participation")]<-0
#mcs_unique[mcs_unique$covs_biological_father%in%c("not_bio_dad","no_partner"),grep(colnames(mcs_unique),pattern="paternal_partcipation")]<-0

# set paternal participation to missing if paternity status is missing or unclear
#alspac_unique[alspac_unique$covs_biological_father%in%c("missing","unsure"),grep(colnames(alspac_unique),pattern="paternal_participation")]<-NA
#mcs_unique[mcs_unique$covs_biological_father%in%c("missing","unsure"),grep(colnames(mcs_unique),pattern="paternal_partcipation")]<-NA

# Summarise paternal participation in each cohort

#df <- data.frame(cohort=c("BiB South Asian","BiB White British","ALSPAC","MCS"),mother=c(sum(is.na(bib_sa_unique$MotherID)==FALSE),sum(is.na(bib_we_unique$MotherID)==FALSE),sum(is.na(alspac_unique$aln)==FALSE),sum(is.na(mcs_unique$mcsid)==FALSE)), father=c(sum(is.na(bib_sa_unique$FatherID)==FALSE,na.rm=T),sum(is.na(bib_we_unique$FatherID)==FALSE,na.rm=T),sum(alspac_unique$paternal_participation,na.rm=T),sum(mcs_unique$paternal_participation,na.rm=T)))

df <- data.frame(cohort=c("BiB","ALSPAC","MCS"),mother=c(sum(is.na(bib_all_unique$BiBMotherID)==FALSE),sum(is.na(alspac_unique$aln)==FALSE),sum(is.na(mcs_unique$mcsid)==FALSE)), father=c(sum(bib_all_unique$paternal_participation,na.rm=T),sum(alspac_unique$paternal_participation,na.rm=T),sum(mcs_unique$paternal_participation,na.rm=T)))

df$percent <- (df$father/df$mother)*100

#devtools::install_github('cttobin/ggthemr')
#devtools::install_github("brooke-watson/bplots")

require(ggthemr)
require(ggplot2)
require(extrafont)

ggthemr("light")

plot1<-ggplot(df) +
  geom_rect(aes(xmin=0,xmax=percent,ymin=0,ymax=1,fill="#62bba5"))+
  xlab("Percentage of pregnancies with partners\nparticipating in the study")+
  ggtitle("Partner participation in ALSPAC, BiB and MCS")+
  xlim(0,100)+
  facet_grid(cohort~., switch = "y")+
  theme_grey()+
  theme(strip.text.y = element_text(angle = 180),axis.text.y=element_blank(),axis.ticks.y=element_blank(),panel.grid.minor = element_blank(),panel.grid.major = element_blank(),panel.spacing = unit(.7, "lines"),legend.title=element_blank(),legend.position="none",plot.title = element_text(hjust = 0.5))

pdf("patpart_percentage.pdf",height=2.5,width=4.5)
plot1
dev.off()

# Concordance between partner data reported by the mother and that reported by the partner themselves

## In ALSPAC, two of our paternal variables of interest (smoking at the start of pregnancy and drinking alcohol at any point during pregnancy) were reported by both the study father himself and the study mother about the study father. 

require(knitr)
require(stringr)
mat_report_vars <- names(alspac)[grep(names(alspac_unique),pattern="mreport")][-1]
pat_report_vars <- str_remove(mat_report_vars,"_mreport")

### Alcohol in pregnancy

df <- na.omit(data.frame(self_report=alspac_unique$alcohol_father_ever_pregnancy_binary,mother_report=alspac_unique$alcohol_father_ever_pregnancy_binary_mreport))

table(df$self)
table(df$mother)
prop.table(table(df$self))
prop.table(table(df$mother))

prop.table(table(df$self==df$mother))*100

library(irr)
kappa2(apply(df,2,as.factor)) # kappa = 0.652, p=0

### Smoking at the start of pregnancy (binary)

df <- na.omit(data.frame(self_report=alspac_unique$smoking_father_startpregnancy_binary,mother_report=alspac_unique$smoking_father_startpregnancy_binary_mreport))

table(df$self)
table(df$mother)
prop.table(table(df$self))
prop.table(table(df$mother))

prop.table(table(df$self==df$mother))*100

kappa2(apply(df,2,as.factor)) # kappa = 0.897, p=0

### Smoking at the start of pregnancy (ordinal)

df<- na.omit(data.frame(mother_report=alspac_unique[,mat_report_vars[2]],self_report=alspac_unique[,pat_report_vars[2]]))

ggthemr("light")

plot2 <- ggplot(df,aes(x=self_report))+
  geom_bar(aes(fill=as.character(mother_report)),position="fill")+
  labs(y="Proportion",
       x="Partner self-report of smoking",
       title ="Partner smoking: a comparison of self- and\nmaternal-reported data in ALSPAC",
      fill="Cohort mother report of partner smoking:",
      bottom = title)+
  theme_grey()+
  theme(panel.grid.minor = element_blank(),panel.grid.major = element_blank(),legend.position="bottom", plot.title = element_text(hjust = 0.5))
  
pdf("smoking_self_maternal_report.pdf",height=4.5,width=6.5)
plot2
dev.off()

prop.table(table(as.character(df$self_report)==as.character(df$mother_report)))
df_disagreement <- df[df$self_report!=df$mother_report,]
prop.table(table(df_disagreement$mother_report<df_disagreement$self_report))

kappa2(df) # kappa = 0.767, p=0 (UNWEIGHTED)
kappa2(df,"equal") # kappa = 0.794, p=0 (WEIGHTED)
kappa2(df,"squared") # kappa = 0.829, p=0 (WEIGHTED)

### Mat report vs pat report smoking and alcohol on BW

all_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_father_startpregnancy_binary,data=alspac_unique))$coef[2,],"Self report","Complete sample","ALSPAC","Birthweight","Partner smoking at\nthe start of pregnancy"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_father_startpregnancy_binary_mreport,data=alspac_unique))$coef[2,],"Mother report","Complete sample","ALSPAC","Birthweight","Partner smoking at\nthe start of pregnancy"),
      							c(summary(lm(scale(anthro_birthweight)~alcohol_father_ever_pregnancy_binary,data=alspac_unique))$coef[2,],"Self report","Complete sample","ALSPAC","Birthweight","Partner alcohol\nduring pregnancy"),
      							c(summary(lm(scale(anthro_birthweight)~alcohol_father_ever_pregnancy_binary_mreport,data=alspac_unique))$coef[2,],"Mother report","Complete sample","ALSPAC","Birthweight","Partner alcohol\nduring pregnancy"))
colnames(all_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","exposure")

all_res[,c("estimate","se","t","p")]<-apply(all_res[,c("estimate","se","t","p")],2,function(x) as.numeric(as.character(x)))
all_res$model <- as.character(all_res$model)
all_res$model <- factor(all_res$model, ordered=T, levels = rev(unique(all_res$model)))
all_res$parent <- as.character(all_res$parent)
all_res$parent <- factor(all_res$parent, ordered=T, levels = rev(unique(all_res$parent)))

library(ggstance)

mreport_plot<-ggplot(data=all_res, aes(x=estimate, y=1,colour=as.character(parent))) + 
 geom_vline(aes(xintercept = 0), size = .25, linetype = "dashed", colour= "grey40" ) +
  geom_errorbarh(aes(xmax = estimate+(se*1.96), xmin = estimate-(se*1.96)), height = 0, position=position_dodgev(.5)) +
  geom_point(size=3, fill="white",position=position_dodgev(.5),shape=15)+
  theme_grey()+
  facet_grid(exposure~.,switch="y")+
  labs( y = "", x = "Difference in SD birthweight of exposed vs unexposed children") +
 theme(strip.text.y = element_text(angle=180), panel.grid.minor = element_blank(),panel.grid.major = element_blank(),panel.spacing = unit(.7, "lines"),panel.spacing.y = unit(0.1, "lines"),legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5),axis.text.y=element_blank(),axis.ticks.y=element_blank()) +
  labs(title= "Comparison of estimates generated using self- and\ncohort mother-reported data on partner health behaviours") 

pdf("maternal_v_self_report_birthweight_estimates.pdf",height=3,width=6.5)
mreport_plot
dev.off()

# Exploration of ethnicity (not for paper)

x <- bind_rows(
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary,data=bib_all_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary,data=bib_sa_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary,data=bib_we_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary,data=alspac_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary,data=mcs_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary+covs_ethnicity_mother_binary,data=bib_all_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary+covs_ethnicity_mother_binary,data=alspac_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary+covs_ethnicity_mother_binary,data=mcs_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary+covs_edu_mother,data=bib_all_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary+covs_edu_mother,data=alspac_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_life_binary+covs_edu_mother,data=mcs_unique))$coef[2,]
)
x$cohort <- c("BIB","BIB SA","BIB we","ALSPAC","MCS","BIB","ALSPAC","MCS","BIB","ALSPAC","MCS")
x$model <-c("unadjusted","unadjusted","unadjusted","unadjusted","unadjusted","adj for ethnicity","adj for ethnicity","adj for ethnicity","adj for education","adj for education","adj for education")
names(x)<-c("est","se","t","p","cohort","model")
x$exposure <- "ever been a smoker"
y <- bind_rows(
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=bib_all_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=bib_sa_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=bib_we_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=alspac_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=mcs_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother_binary,data=bib_all_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother_binary,data=alspac_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother_binary,data=mcs_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_edu_mother,data=bib_all_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_edu_mother,data=alspac_unique))$coef[2,],
summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_edu_mother,data=mcs_unique))$coef[2,]
)
y$cohort <- c("BIB","BIB SA","BIB we","ALSPAC","MCS","BIB","ALSPAC","MCS","BIB","ALSPAC","MCS")
y$model <-c("unadjusted","unadjusted","unadjusted","unadjusted","unadjusted","adj for ethnicity","adj for ethnicity","adj for ethnicity","adj for education","adj for education","adj for education")
names(y)<-c("est","se","t","p","cohort","model")
y$exposure <- "any smoking in pregnancy"

xy <- bind_rows(x,y)

ggplot(xy,aes(x=est,y=cohort,xmin=est-(se*1.96),xmax=est+(se*1.96)))+
geom_errorbarh(height=0.1)+geom_vline(xintercept=0)+xlab("sd birthweight of children\nof exposed vs not exposed")+
geom_point()+
facet_grid(model~exposure,space="free",scale="free")

# Selection bias in paternal data

## paternal participation ~ maternal and birth characteristics

calc_props <- function(df,variable){
  if(variable %in% colnames(df)){
d00 <- sum(na.omit(df$paternal_participation[which(df[,variable]==0)])==0)
d10 <- sum(na.omit(df$paternal_participation[which(df[,variable]==0)])==1)
d01 <- sum(na.omit(df$paternal_participation[which(df[,variable]==1)])==0)
d11 <- sum(na.omit(df$paternal_participation[which(df[,variable]==1)])==1)
res<-data.frame(variable=variable,p0v0=d00,p0v1=d01,p1v0=d10,p1v1=d11,percentv1_pp0=NA,percentv1_pp1=NA)
res$percentv1_pp0 <- (res$p0v1/(res$p0v1+res$p0v0))*100
res$percentv1_pp1 <- (res$p1v1/(res$p1v1+res$p1v0))*100
res$difference <- res$percentv1_pp1-res$percentv1_pp0
ORres <- glm(df$paternal_participation ~ df[,variable],family="binomial")
ORres <- summary(ORres)$coefficients[2,]
res$est <- ORres[1]
res$or <- exp(ORres[1])
res$or_lower <- exp(ORres[1] - (1.96*ORres[2]))
res$or_upper <- exp(ORres[1] + (1.96*ORres[2]))
}else{
  res<-data.frame(variable=variable,p0v0=NA,p0v1=NA,p1v0=NA,p1v1=NA,percentv1_pp0=NA,percentv1_pp1=NA)
  res$difference <- NA
  res$est <-NA
  res$or <- NA
  res$or_lower <- NA
  res$or_upper <- NA
}
res
}

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

bib_all_unique <- gen_new_vars(bib_all_unique)
alspac_unique <- gen_new_vars(alspac_unique)
mcs_unique <- gen_new_vars(mcs_unique)

variables <- c("mother_obese","biodad","paternal_age_low","paternal_age_high","maternal_age_low","maternal_age_high","alcohol_father_ever_pregnancy_binary_mreport","smoking_father_startpregnancy_binary_mreport","smoking_mother_ever_pregnancy_binary","alcohol_mother_ever_pregnancy_binary","covs_father_edu_high","covs_father_edu_low","covs_mother_edu_high","covs_mother_edu_low","covs_partner_lives_with_mother_prenatal","covs_married_mother_binary","anthro_birthweight_low_binary","anthro_birthweight_high_binary","covs_preterm_binary", "ethnicity_white","ethnicity_white_father")

df_alspac <- bind_rows(lapply(variables,calc_props,df=alspac_unique))
df_bib <- bind_rows(lapply(variables,calc_props,df=bib_all_unique))
df_mcs <- bind_rows(lapply(variables,calc_props,df=mcs_unique))

varnames=c("Mother is obese","Partner is biological father","Partner is age <=21","Partner is age >=35","Mother is age <=21","Mother is age >=35","Partner drank alcohol in pregnancy","Partner smoked in pregnancy","Mother smoked in pregnancy","Mother drank alcohol in pregnancy","Partner has a degree","Partner has no qualifications","Mother has a degree","Mother has no qualifications","Mother lived with partner before birth","Mother is married","Baby's birthweight is <2.5kg","Baby's birthweight is >4.5kg","Baby was delivered preterm", "Mother is white","Partner is white")

# df <- data.frame(varname=c(varnames,varnames,varnames[1:12],varnames[1:12],varnames),
# pp0=c(df_alspac[,6],df_bib[,6],df_sa_bib[,6],df_we_bib[,6],df_mcs[,6]),
#                  pp1=c(df_alspac[,7],df_bib[,6],df_sa_bib[,7],df_we_bib[,7],df_mcs[,7]),
#                  difference=c(df_alspac[,8],df_bib[,8],df_sa_bib[,8],df_we_bib[,8],df_mcs[,8]),
#                  cohort=c(rep("ALSPAC",13),rep("BIB",13),rep("BiB South Asian",12),rep("BiB White European",12),rep("MCS",13)),
#                  or=c(df_alspac$or,df_bib$or,df_sa_bib$or,df_we_bib$or,df_mcs$or),
#                  or_lower=c(df_alspac$or_lower,df_bib$or_lower,df_sa_bib$or_lower,df_we_bib$or_lower,df_mcs$or_lower),
#                  or_upper=c(df_alspac$or_upper,df_bib$or_upper,df_sa_bib$or_upper,df_we_bib$or_upper,df_mcs$or_upper),
#                  est=c(df_alspac$est,df_bib$est,df_sa_bib$est,df_we_bib$est,df_mcs$est)
#                  )

df <- data.frame(varname=c(varnames,varnames,varnames),
                 v1=c(df_alspac[,3]+df_alspac[,5],df_bib[,3]+df_bib[,5],df_mcs[,3]+df_mcs[,5]),
                 v0=c(df_alspac[,2]+df_alspac[,4],df_bib[,2]+df_bib[,4],df_mcs[,2]+df_mcs[,4]),
                 p0v1=c(df_alspac[,3],df_bib[,3],df_mcs[,3]),
                 p0v0=c(df_alspac[,2],df_bib[,2],df_mcs[,2]),
                 pp0=c(df_alspac[,6],df_bib[,6],df_mcs[,6]),
                 pp1=c(df_alspac[,7],df_bib[,6],df_mcs[,7]),
                 difference=c(df_alspac[,8],df_bib[,8],df_mcs[,8]),
                 cohort=c(rep("ALSPAC",21),rep("BIB",21),rep("MCS",21)),
                 or=c(df_alspac$or,df_bib$or,df_mcs$or),
                 or_lower=c(df_alspac$or_lower,df_bib$or_lower,df_mcs$or_lower),
                 or_upper=c(df_alspac$or_upper,df_bib$or_upper,df_mcs$or_upper),
                 est=c(df_alspac$est,df_bib$est,df_mcs$est)
)


df$varname <- factor(df$varname,ordered=T,levels=unique(df$varname))


library(ggthemr)
ggthemr("light")

df2 <- df[df$cohort %in% c("ALSPAC","BIB","MCS"),]

df2<-df2[which(is.na(df2$pp0)==F),]
df2 <- df2[df2$p0v1>10 & df2$p0v0>10,]
df2 <- droplevels(df2)
df2$person <- NA
df2$person[grep(df2$varname,pattern="Partner")]<-"Partner"
df2$person[grep(df2$varname,pattern="Mother")]<-"Mother"
df2$person[grep(df2$varname,pattern="Baby")]<-"Birth"
df2 <-df2[order(df2$or),]
df2$varname <- factor(df2$varname,ordered = T, levels=unique(df2$varname))



scaleFUN <- function(x) sprintf("%.0f", x)

plot1<-  ggplot(df2)+
   # geom_rect(aes(xmin=-pp0,xmax=pp1,ymin=as.numeric(as.factor(cohort))-.5,ymax=as.numeric(as.factor(cohort))+.5,fill=cohort))+
  geom_vline(aes(xintercept = 1), size = .25, linetype = "dashed", colour= "grey40" ) +
       geom_point(aes(x=or,y=varname,colour=cohort[1]),size=3,shape=15)+
#  geom_rect(aes(xmin=1,xmax=or,ymin=as.numeric(as.factor(cohort))-.5,ymax=as.numeric(as.factor(cohort))+.5,fill=cohort))+
 #   geom_text(aes(label=round(or,2),x=label_position,y=as.numeric(as.factor(cohort))),size=2.5)+
        geom_errorbarh(aes(xmin=or_lower,xmax=or_upper,y=varname,colour=cohort[1]),height=0,size=0.5)+
 #   facet_grid(.~varname, switch = "y",scales="free")+
 #   geom_vline(xintercept = 0,colour="grey40")+
  facet_grid(person~cohort,space="free_y",scales="free")+
  labs(title= "Associations between partner participation and\nfamily characteristics") +
    theme_grey()+
    xlab("Odds ratio")+
  theme(axis.text.x=element_text(size=8),axis.text.y=element_text(size=8),axis.ticks.y=element_blank(),axis.title.y=element_blank(),panel.grid.minor = element_blank(),panel.grid.major = element_blank(),panel.spacing = unit(.2, "lines"),legend.title=element_blank(),legend.position="none",plot.title = element_text(hjust = 0.5))+
   scale_x_continuous(breaks = c(0.25,0.5,1,2,4,8,512),labels=scaleFUN) +
  coord_trans(x = 'log')

pdf("mother_characteristics_by_partner_participation.pdf",height=5,width=7)
plot1
dev.off()

## paternal participation ~ maternal and birth characteristics

calc_props2 <- function(df,variable){
  if(variable %in% colnames(df)){
    d00 <- sum(na.omit(df$paternal_participation[which(df[,variable]==0)])==0)
    d10 <- sum(na.omit(df$paternal_participation[which(df[,variable]==0)])==1)
    d01 <- sum(na.omit(df$paternal_participation[which(df[,variable]==1)])==0)
    d11 <- sum(na.omit(df$paternal_participation[which(df[,variable]==1)])==1)
    res<-data.frame(variable=variable,p0v0=d00,p0v1=d01,p1v0=d10,p1v1=d11,percentv1_pp0=NA,percentv1_pp1=NA)
    res$percentv1_pp0 <- (res$p0v1/(res$p0v1+res$p0v0))*100
    res$percentv1_pp1 <- (res$p1v1/(res$p1v1+res$p1v0))*100
    res$difference <- res$percentv1_pp1-res$percentv1_pp0
    ORres <- glm(df$paternal_participation ~ df[,variable] + df$covs_ethnicity_mother_binary,family="binomial")
    ORres <- summary(ORres)$coefficients[2,]
    res$est <- ORres[1]
    res$or <- exp(ORres[1])
    res$or_lower <- exp(ORres[1] - (1.96*ORres[2]))
    res$or_upper <- exp(ORres[1] + (1.96*ORres[2]))
  }else{
    res<-data.frame(variable=variable,p0v0=NA,p0v1=NA,p1v0=NA,p1v1=NA,percentv1_pp0=NA,percentv1_pp1=NA)
    res$difference <- NA
    res$est <-NA
    res$or <- NA
    res$or_lower <- NA
    res$or_upper <- NA
  }
  res
}


variables <- c("biodad","paternal_age_low","paternal_age_high","maternal_age_low","maternal_age_high","alcohol_father_ever_pregnancy_binary_mreport","smoking_father_startpregnancy_binary_mreport","smoking_mother_ever_pregnancy_binary","alcohol_mother_ever_pregnancy_binary","covs_father_edu_high","covs_father_edu_low","covs_mother_edu_high","covs_mother_edu_low","covs_partner_lives_with_mother_prenatal","covs_married_mother_binary","anthro_birthweight_low_binary","anthro_birthweight_high_binary","covs_preterm_binary", "ethnicity_white_father")

df_alspac2 <- bind_rows(lapply(variables,calc_props2,df=alspac_unique))
df_bib2 <- bind_rows(lapply(variables,calc_props2,df=bib_all_unique))
df_mcs2 <- bind_rows(lapply(variables,calc_props2,df=mcs_unique))

varnames=c("Partner is biological father","Partner is age <=21","Partner is age >=35","Mother is age <=21","Mother is age >=35","Partner drank alcohol in pregnancy","Partner smoked in pregnancy","Mother smoked in pregnancy","Mother drank alcohol in pregnancy","Partner has a degree","Partner has no qualifications","Mother has a degree","Mother has no qualifications","Mother lived with partner before birth","Mother is married","Baby's birthweight is <2.5kg","Baby's birthweight is >4.5kg","Baby was delivered preterm","Partner is white")

df3 <- data.frame(varname=c(varnames,varnames,varnames),
                 v1=c(df_alspac2[,3]+df_alspac2[,5],df_bib2[,3]+df_bib2[,5],df_mcs2[,3]+df_mcs2[,5]),
                 v0=c(df_alspac2[,2]+df_alspac2[,4],df_bib2[,2]+df_bib2[,4],df_mcs2[,2]+df_mcs2[,4]),
                 p0v1=c(df_alspac2[,3],df_bib2[,3],df_mcs2[,3]),
                 p0v0=c(df_alspac2[,2],df_bib2[,2],df_mcs2[,2]),
                 pp0=c(df_alspac2[,6],df_bib2[,6],df_mcs2[,6]),
                 pp1=c(df_alspac2[,7],df_bib2[,6],df_mcs2[,7]),
                 difference=c(df_alspac2[,8],df_bib2[,8],df_mcs2[,8]),
                 cohort=c(rep("ALSPAC",19),rep("BIB",19),rep("MCS",19)),
                 or=c(df_alspac2$or,df_bib2$or,df_mcs2$or),
                 or_lower=c(df_alspac2$or_lower,df_bib2$or_lower,df_mcs2$or_lower),
                 or_upper=c(df_alspac2$or_upper,df_bib2$or_upper,df_mcs2$or_upper),
                 est=c(df_alspac2$est,df_bib2$est,df_mcs2$est)
)


df3$varname <- factor(df3$varname,ordered=T,levels=unique(df3$varname))


library(ggthemr)
ggthemr("light")

df4 <- df3[df3$cohort %in% c("ALSPAC","BIB","MCS"),]

df4<-df4[which(is.na(df4$pp0)==F),]
df4 <- df4[df4$p0v1>10 & df4$p0v0>10,]
df4 <- droplevels(df4)
df4$person <- NA
df4$person[grep(df4$varname,pattern="Partner")]<-"Partner"
df4$person[grep(df4$varname,pattern="Mother")]<-"Mother"
df4$person[grep(df4$varname,pattern="Baby")]<-"Birth"
df4 <-df4[order(df4$or),]
df4$varname <- factor(df4$varname,ordered = T, levels=unique(df4$varname))



scaleFUN <- function(x) sprintf("%.0f", x)

plot1<-  ggplot(df4)+
  # geom_rect(aes(xmin=-pp0,xmax=pp1,ymin=as.numeric(as.factor(cohort))-.5,ymax=as.numeric(as.factor(cohort))+.5,fill=cohort))+
  geom_vline(aes(xintercept = 1), size = .25, linetype = "dashed", colour= "grey40" ) +
  geom_point(aes(x=or,y=varname,colour=cohort[1]),size=3,shape=15)+
  #  geom_rect(aes(xmin=1,xmax=or,ymin=as.numeric(as.factor(cohort))-.5,ymax=as.numeric(as.factor(cohort))+.5,fill=cohort))+
  #   geom_text(aes(label=round(or,2),x=label_position,y=as.numeric(as.factor(cohort))),size=2.5)+
  geom_errorbarh(aes(xmin=or_lower,xmax=or_upper,y=varname,colour=cohort[1]),height=0,size=0.5)+
  #   facet_grid(.~varname, switch = "y",scales="free")+
  #   geom_vline(xintercept = 0,colour="grey40")+
  facet_grid(person~cohort,space="free_y",scales="free")+
  labs(title= "Associations between partner participation and\nfamily characteristics") +
  theme_grey()+
  xlab("Odds ratio")+
  theme(axis.text.x=element_text(size=8),axis.text.y=element_text(size=8),axis.ticks.y=element_blank(),axis.title.y=element_blank(),panel.grid.minor = element_blank(),panel.grid.major = element_blank(),panel.spacing = unit(.2, "lines"),legend.title=element_blank(),legend.position="none",plot.title = element_text(hjust = 0.5))+
  scale_x_continuous(breaks = c(0.25,0.5,1,2,4,8,512),labels=scaleFUN) +
  coord_trans(x = 'log')

pdf("mother_characteristics_by_partner_participation_ethnicity_adjusted.pdf",height=5,width=7)
plot1
dev.off()







# birthweight ~ maternal smoking stratified by paternal participation

ggthemr("light")
library(ggstance)

## BiB all

unadj_bw_bib_all_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=bib_all_unique))$coef[2,],"Maternal smoking","Complete sample","BiB","Birthweight","Unadjusted for ethnicity"),
                                        c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=bib_all_unique[bib_all_unique$paternal_participation==1,]))$coef[2,],"Maternal smoking","Sample with participating partners","BiB","Birthweight","Unadjusted for ethnicity"),
                                        c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=bib_all_unique[bib_all_unique$paternal_participation==0,]))$coef[2,],"Maternal smoking","Sample with non-participating partners","BiB","Birthweight","Unadjusted for ethnicity"),
                                        c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+smoking_father_ever_pregnancy_binary,data=bib_all_unique))$coef[2,],"Maternal smoking","Complete sample, adjusted for partner smoking","BiB","Birthweight","Unadjusted for ethnicity"))
colnames(unadj_bw_bib_all_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","adjusted")


## ALSPAC

unadj_bw_alspac_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=alspac_unique))$coef[2,],"Maternal smoking","Complete sample","ALSPAC","Birthweight","Unadjusted for ethnicity"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=alspac_unique[alspac_unique$paternal_participation==1,]))$coef[2,],"Maternal smoking","Sample with participating partners","ALSPAC","Birthweight","Unadjusted for ethnicity"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=alspac_unique[alspac_unique$paternal_participation==0,]))$coef[2,],"Maternal smoking","Sample with non-participating partners","ALSPAC","Birthweight","Unadjusted for ethnicity"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+smoking_father_ever_pregnancy_binary,data=alspac_unique))$coef[2,],"Maternal smoking","Complete sample, adjusted for partner smoking","ALSPAC","Birthweight","Unadjusted for ethnicity"))
colnames(unadj_bw_alspac_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","adjusted")

## MCS

unadj_bw_mcs_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=mcs_unique))$coef[2,],"Maternal smoking","Complete sample","MCS","Birthweight","Unadjusted for ethnicity"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=mcs_unique[mcs_unique$paternal_participation==1,]))$coef[2,],"Maternal smoking","Sample with participating partners","MCS","Birthweight","Unadjusted for ethnicity"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary,data=mcs_unique[mcs_unique$paternal_participation==0,]))$coef[2,],"Maternal smoking","Sample with non-participating partners","MCS","Birthweight","Unadjusted for ethnicity"),
      							c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+smoking_father_ever_pregnancy_binary,data=mcs_unique))$coef[2,],"Maternal smoking","Complete sample, adjusted for partner smoking","MCS","Birthweight","Unadjusted for ethnicity"))
colnames(unadj_bw_mcs_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","adjusted")


#all_res <- rbind.data.frame(unadj_bw_alspac_res,unadj_bw_bib_all_res,unadj_bw_bib_sa_res,unadj_bw_bib_we_res,unadj_bw_mcs_res)
all_res <- rbind.data.frame(unadj_bw_alspac_res,unadj_bw_bib_all_res,unadj_bw_mcs_res)

all_res[,c("estimate","se","t","p")]<-apply(all_res[,c("estimate","se","t","p")],2,function(x) as.numeric(as.character(x)))
all_res$model <- as.character(all_res$model)
all_res$model <- factor(all_res$model, ordered=T, levels = rev(unique(all_res$model)))

unadj_all_res <- all_res

## same but adjusted for ethnicity

## BiB all

adj_bw_bib_all_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=bib_all_unique))$coef[2,],"Maternal smoking","Complete sample","BiB","Birthweight","Adjusted for ethnicity"),
                                         c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=bib_all_unique[bib_all_unique$paternal_participation==1,]))$coef[2,],"Maternal smoking","Sample with participating partners","BiB","Birthweight","Adjusted for ethnicity"),
                                         c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=bib_all_unique[bib_all_unique$paternal_participation==0,]))$coef[2,],"Maternal smoking","Sample with non-participating partners","BiB","Birthweight","Adjusted for ethnicity"),
                                         c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother+smoking_father_ever_pregnancy_binary,data=bib_all_unique))$coef[2,],"Maternal smoking","Complete sample, adjusted for partner smoking","BiB","Birthweight","Adjusted for ethnicity"))
colnames(adj_bw_bib_all_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","adjusted")


## ALSPAC

adj_bw_alspac_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=alspac_unique))$coef[2,],"Maternal smoking","Complete sample","ALSPAC","Birthweight","Adjusted for ethnicity"),
                                        c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=alspac_unique[alspac_unique$paternal_participation==1,]))$coef[2,],"Maternal smoking","Sample with participating partners","ALSPAC","Birthweight","Adjusted for ethnicity"),
                                        c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=alspac_unique[alspac_unique$paternal_participation==0,]))$coef[2,],"Maternal smoking","Sample with non-participating partners","ALSPAC","Birthweight","Adjusted for ethnicity"),
                                        c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother+smoking_father_ever_pregnancy_binary,data=alspac_unique))$coef[2,],"Maternal smoking","Complete sample, adjusted for partner smoking","ALSPAC","Birthweight","Adjusted for ethnicity"))
colnames(adj_bw_alspac_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","adjusted")

## MCS

adj_bw_mcs_res <- rbind.data.frame(c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=mcs_unique))$coef[2,],"Maternal smoking","Complete sample","MCS","Birthweight","Adjusted for ethnicity"),
                                     c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=mcs_unique[mcs_unique$paternal_participation==1,]))$coef[2,],"Maternal smoking","Sample with participating partners","MCS","Birthweight","Adjusted for ethnicity"),
                                     c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother,data=mcs_unique[mcs_unique$paternal_participation==0,]))$coef[2,],"Maternal smoking","Sample with non-participating partners","MCS","Birthweight","Adjusted for ethnicity"),
                                     c(summary(lm(scale(anthro_birthweight)~smoking_mother_ever_pregnancy_binary+covs_ethnicity_mother+smoking_father_ever_pregnancy_binary,data=mcs_unique))$coef[2,],"Maternal smoking","Complete sample, adjusted for partner smoking","MCS","Birthweight","Adjusted for ethnicity"))
colnames(adj_bw_mcs_res)<-c("estimate","se","t","p","parent","model","cohort","outcome","adjusted")


all_res <- rbind.data.frame(adj_bw_alspac_res,adj_bw_bib_all_res,adj_bw_mcs_res)

all_res[,c("estimate","se","t","p")]<-apply(all_res[,c("estimate","se","t","p")],2,function(x) as.numeric(as.character(x)))
all_res$model <- as.character(all_res$model)
all_res$model <- factor(all_res$model, ordered=T, levels = rev(unique(all_res$model)))

all_res <- bind_rows(all_res,unadj_all_res)


all_res$adjusted <- as.character(all_res$adjusted)
all_res$adjusted <- factor(all_res$adjusted,ordered=T,levels=rev(unique(all_res$adjusted)))

plot2 <- ggplot(data=all_res, aes(x=estimate, y=model, colour=as.character(adjusted[1]))) + 
  geom_errorbarh(aes(xmax = estimate+(se*1.96), xmin = estimate-(se*1.96)), height = 0, position=position_dodgev(.5),size=0.5) +
  geom_point(size=2.5, fill="white",position=position_dodgev(.5),shape=15)+
  geom_vline(aes(xintercept = 0), size = .25, linetype = "dashed", colour= "grey40" ) +
  labs( y = "", x = "Difference in SD birthweight of offspring of mothers who smoked\nvs those who did not smoke during pregnancy") +
  facet_grid(adjusted~cohort) +
  theme_grey()+
  theme(axis.text.x=element_text(size=8),axis.text.y=element_text(size=10),axis.ticks.y=element_blank(),axis.title.y=element_blank(),panel.grid.minor = element_blank(),panel.grid.major = element_blank(),panel.spacing = unit(.1, "lines"),legend.title=element_blank(),legend.position="none",plot.title = element_text(hjust = 0.5))+
  labs(title= "Associations between maternal smoking during pregnancy\nand baby's birthweight") 

pdf("checking_selection_maternal_smoking_ethadjusted.pdf",height=4.5,width=8)
plot2
dev.off()


# generating parameteres for simulation studies

library(broom)

generate_parameters <- function(dat){
proportions <-  data.frame(
prop.dads = sum(dat[,"paternal_participation"]==1,na.rm=T)/sum(dat[,"paternal_participation"]%in%c(0,1),na.rm=T),
prop.pSmoke = sum(dat[,"smoking_father_ever_pregnancy_binary"]==1,na.rm=T)/sum(dat[,"smoking_father_ever_pregnancy_binary"]%in%c(0,1),na.rm=T),
prop.mSmoke = sum(dat[,"smoking_mother_ever_pregnancy_binary"]==1,na.rm=T)/sum(dat[,"smoking_mother_ever_pregnancy_binary"]%in%c(0,1),na.rm=T))

correlations <- cor(dat[,c("paternal_participation","smoking_father_ever_pregnancy_binary","smoking_mother_ever_pregnancy_binary","covs_edu_father","covs_edu_mother","covs_bmi_father_zscore","covs_bmi_mother_zscore","anthro_birthweight")],use="pairwise.complete.obs")

regression_results <- data.frame(pSmoke.pSEP.beta = summary(glm(smoking_father_ever_pregnancy_binary ~ covs_edu_father, data=dat, family="binomial"))$coef[2,1:2],
pBMI.pSmoke.beta = summary(lm(covs_bmi_father_zscore ~ smoking_father_ever_pregnancy_binary, data=dat))$coef[2,1:2],
pBMI.pSEP.beta = summary(lm(covs_bmi_father_zscore ~ covs_edu_father, data=dat))$coef[2,1:2],
pBMI.pSmoke_pSEP.beta = summary(lm(covs_bmi_father_zscore ~ smoking_father_ever_pregnancy_binary + covs_edu_father, data=dat))$coef[2,1:2],
pBMI.pSEP_pSmoke.beta = summary(lm(covs_bmi_father_zscore ~ smoking_father_ever_pregnancy_binary + covs_edu_father, data=dat))$coef[3,1:2],

oBW.pBMI.beta = summary(lm(scale(anthro_birthweight) ~ covs_bmi_father_zscore, data=dat))$coef[2,1:2],
oBW.pSmoke.beta = summary(lm(scale(anthro_birthweight) ~ smoking_father_ever_pregnancy_binary, data=dat))$coef[2,1:2],
oBW.pSmoke_pBMI.beta = summary(lm(scale(anthro_birthweight) ~ smoking_father_ever_pregnancy_binary + covs_bmi_father_zscore, data=dat))$coef[2,1:2],
oBW.pBMI_pSmoke.beta = summary(lm(scale(anthro_birthweight) ~ smoking_father_ever_pregnancy_binary + covs_bmi_father_zscore, data=dat))$coef[3,1:2],

mSmoke.mSEP.beta = summary(glm(smoking_mother_ever_pregnancy_binary ~ covs_edu_mother, data=dat, family="binomial"))$coef[2,1:2],
mBMI.mSmoke.beta = summary(lm(covs_bmi_mother_zscore ~ smoking_mother_ever_pregnancy_binary, data=dat))$coef[2,1:2],
mBMI.mSEP.beta = summary(lm(covs_bmi_mother_zscore ~ covs_edu_mother, data=dat))$coef[2,1:2],
mBMI.mSmoke_mSEP.beta = summary(lm(covs_bmi_mother_zscore ~ smoking_mother_ever_pregnancy_binary + covs_edu_mother, data=dat))$coef[2,1:2],
mBMI.mSEP_mSmoke.beta = summary(lm(covs_bmi_mother_zscore ~ smoking_mother_ever_pregnancy_binary + covs_edu_mother, data=dat))$coef[3,1:2],

oBW.mBMI.beta = summary(lm(scale(anthro_birthweight) ~ covs_bmi_mother_zscore, data=dat))$coef[2,1:2],
oBW.mSmoke.beta = summary(lm(scale(anthro_birthweight) ~ smoking_mother_ever_pregnancy_binary, data=dat))$coef[2,1:2],
oBW.mSmoke_mBMI.beta = summary(lm(scale(anthro_birthweight) ~ smoking_mother_ever_pregnancy_binary + covs_bmi_mother_zscore, data=dat))$coef[2,1:2],
oBW.mBMI_mSmoke.beta = summary(lm(scale(anthro_birthweight) ~ smoking_mother_ever_pregnancy_binary + covs_bmi_mother_zscore, data=dat))$coef[3,1:2],

pParticipation.pSEP.beta = summary(glm(paternal_participation ~ covs_edu_father, data=dat, family="binomial"))$coef[2,1:2],
pParticipation.mSEP.beta = summary(glm(paternal_participation ~ covs_edu_mother, data=dat, family="binomial"))$coef[2,1:2],
pParticipation.mBMI.beta = summary(glm(paternal_participation ~ covs_bmi_mother_zscore, data=dat, family="binomial"))$coef[2,1:2],
pParticipation.mSmoke.beta = summary(glm(paternal_participation ~ smoking_mother_ever_pregnancy_binary, data=dat, family="binomial"))$coef[2,1:2]
)
list(proportions,regression_results,correlations)
}

res <- lapply(list(alspac_unique,bib_sa_unique,bib_we_unique,bib_all_unique,mcs_unique),generate_parameters)
names(res) <- c("alspac","bib south asians","bib white european","bib all","mcs")
proportions <- bind_rows(lapply(res,"[[",1))
proportions <- as.data.frame(t(proportions))
names(proportions) <- c("alspac","bib south asians","bib white european","bib all","mcs")

reg_res <- bind_rows(lapply(res,"[[",2))
reg_res <- as.data.frame(t(reg_res))
colnames(reg_res) <- c("alspac_coef","alspac_se","bib_south_asians_coef","bib_south_asians_se","bib_white_european_coef","bib_white_european_se","bib_all_coef","bib_all_se","mcs_coef","mcs_se")

reg_res$alspac_lci <- reg_res$alspac_coef - (1.96*reg_res$alspac_se)
reg_res$alspac_uci <- reg_res$alspac_coef + (1.96*reg_res$alspac_se)
reg_res$bib_south_asians_lci <- reg_res$bib_south_asians_coef - (1.96*reg_res$bib_south_asians_se)
reg_res$bib_south_asians_uci <- reg_res$bib_south_asians_coef + (1.96*reg_res$bib_south_asians_se)
reg_res$bib_white_european_lci <- reg_res$bib_white_european_coef - (1.96*reg_res$bib_white_european_se)
reg_res$bib_white_european_uci <- reg_res$bib_white_european_coef + (1.96*reg_res$bib_white_european_se)
reg_res$bib_all_lci <- reg_res$bib_all_coef - (1.96*reg_res$bib_all_se)
reg_res$bib_all_uci <- reg_res$bib_all_coef + (1.96*reg_res$bib_all_se)
reg_res$mcs_lci <- reg_res$mcs_coef - (1.96*reg_res$mcs_se)
reg_res$mcs_uci <- reg_res$mcs_coef + (1.96*reg_res$mcs_se)

reg_res <- reg_res[,c("alspac_coef","alspac_se","alspac_lci","alspac_uci",
           "bib_white_european_coef","bib_white_european_se","bib_white_european_lci","bib_white_european_uci",
           "bib_south_asians_coef","bib_south_asians_se","bib_south_asians_lci","bib_south_asians_uci",
           "bib_all_coef","bib_all_se","bib_all_lci","bib_all_uci",
           "mcs_coef","mcs_se","mcs_lci","mcs_uci")]

correlations_alspac <- lapply(res,"[[",3)$alspac
correlations_bib_sa <- lapply(res,"[[",3)$"bib south asian"
correlations_bib_we <- lapply(res,"[[",3)$"bib white european"
correlations_bib_all <- lapply(res,"[[",3)$"bib all"
correlations_mcs <- lapply(res,"[[",3)$"mcs"

write.csv(reg_res,"regression_parameters_for_apostolos.csv",row.names=T)
write.csv(proportions,"proportions_for_apostolos.csv",row.names=T)
write.csv(correlations_alspac,"correlations_alspac_for_apostolos.csv",row.names=T)























## New Figure requested by Kate
## Maternal smoking --> BW in complet sample, sample w pp, sample with npp, complete sample adj for psmoking, complete sample adj for psmoking and factors that affect participation (ethnicity, education, co-habitation, being bio parent)


