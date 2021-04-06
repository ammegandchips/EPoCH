#####################################################
##### Create a txt file of the final SNPs betas #####
#####################################################

#######
# BiB #
#######

edit each section from alspac pathways as I make scores

# This script takes the clumped_prune.in file and merges with 
## the original betas list to give the clumped SNPs only with betas

rm(list=ls())

# Alcohol

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/alcohol prep files")

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

#setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/Smoking prep files")
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/Genetic scores/smoking_prep_files/")


init<-read.delim(file="smoking_cigs_pd_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE


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
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/Genetic scores/smoking_prep_files")

init<-read.delim(file="smoking_initiation_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE


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

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/smoking_prep_files/")

init<-read.delim(file="smoking_cessation_raw.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

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

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/smoking_prep_files/")

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

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/caff_prep_files/")
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

## Physical activity
# Sedentary behaviour

setwd("/Users/ke14426/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/pa_prep_files/")

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

# Overall activity

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/bib/genetic scores/pa_prep_files/")

init<-read.delim(file="pa_overall_activity_betas_original.txt", header=FALSE)
colnames(init)<- c("SNP", "Alt allele freq", "Beta")
#init$Zscore<-init$Beta/init$SE

insnps<-read.delim(file="pa_overall_activity_clumped.prune.in", header=FALSE)
colnames(insnps)<-"SNP"

outsnps<-merge(x=init, 
               y=insnps, 
               by.x= "SNP", 
               by.y= "SNP", 
               sort=TRUE)
outsnps<-as.matrix(outsnps)

write(t(outsnps), 
      file="pa_overall_activity_betas.txt",
      ncolumns= 3,
      sep="\t")
