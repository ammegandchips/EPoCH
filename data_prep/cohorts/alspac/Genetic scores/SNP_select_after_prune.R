
#setwd("/Volumes/Pregnancy/EPoCH/")
rm(list=ls())

# Alcohol

setwd("/Users/ke14426/OneDrive - University of Bristol/Documents/EPoCH/Analysis/Genetic scores/Alcohol")

init<-read.delim(file="Alcohol_betas_original.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

insnps<-read.delim(file="alcohol_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="alcohol_betas.txt",
      ncolumns= 3,
      sep="\t")


##### Smoking #####
# Cigs per day

#setwd("/Users/ke14426/OneDrive - University of Bristol/Documents/EPoCH/Analysis/Genetic scores/Smoking")
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/Smoking prep files")

init<-read.delim(file="smoking_cigs_pd_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking")

insnps<-read.delim(file="smoking_cigs_pd_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="smoking_cigs_pd_betas.txt",
      ncolumns= 3,
      sep="\t")

# Smoking initiation (smoker V non)
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/Smoking prep files")

init<-read.delim(file="smoking_initiation_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE


setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking")

insnps<-read.delim(file="smoking_initiation_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="smoking_initiation_betas.txt",
      ncolumns= 3,
      sep="\t")

# Smoking cessation

#setwd("/Users/ke14426/OneDrive - University of Bristol/Documents/EPoCH/Analysis/Genetic scores/Smoking")
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/Smoking prep files")

init<-read.delim(file="smoking_cessation_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking")

insnps<-read.delim(file="smoking_cessation_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="smoking_cessation_betas.txt",
      ncolumns= 3,
      sep="\t")

# Smoking age init

setwd("/Users/ke14426/OneDrive - University of Bristol/Documents/EPoCH/Analysis/Genetic scores/Smoking")

init<-read.delim(file="smoking_age_init_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

insnps<-read.delim(file="smoking_age_init_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="smoking_age_init_betas.txt",
      ncolumns= 3,
      sep="\t")

# Caffeine (coffee)

setwd("/Users/ke14426/OneDrive - University of Bristol/Documents/EPoCH/Analysis/Genetic scores/Caffeine")

init<-read.delim(file="caffeine_betas_original.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

insnps<-read.delim(file="caffeine_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="caffeine_betas.txt",
      ncolumns= 3,
      sep="\t")

## Physical acitity
# Sedentary behaviour

setwd("/Users/ke14426/OneDrive - University of Bristol/Documents/EPoCH/Analysis/Genetic scores/Physical_activity")

init<-read.delim(file="pa_sedentary_betas_original.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

insnps<-read.delim(file="pa_sedentary_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="pa_sedentary_betas.txt",
      ncolumns= 3,
      sep="\t")


