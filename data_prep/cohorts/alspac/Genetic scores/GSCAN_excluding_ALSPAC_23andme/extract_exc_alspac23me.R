##############################################################################
#######  Preparing data to remake PRS excluding ALSPAC and 23and me    #######  
##############################################################################

# Read in data
library(dplyr)

# set wd
#setwd("~/University of Bristol/grp-EPoCH - Documents/WP3_data/3.5 preparation/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Alcohol/Alcohol prep files/")
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Alcohol/")

#####################################
## Data:
# AI = Age of initiation. SC = smoking cessation. CPD = cigs per day. SI = smoking initiation

##########################################################################
#######                         Alcohol                            #######
##########################################################################
#load data
alcohol_snps_original <- read.table("original_alcohol_SNPs.txt",header = F)
alcohol_snps_exc_alsp_original <- read.table("dpw_noICC.txt",header = T)

# merge original SNP list with the betas from the sample excluding 23andme and ALSPAC
library(reshape)
alcohol_snps_original <- rename(alcohol_snps_original, c(V1="RSID")) 
alcohol_snps_exc_alsp <- merge(alcohol_snps_original, alcohol_snps_exc_alsp_original, by="RSID", all.x=TRUE)

#save raw file
#saveRDS(alcohol_snps_exc_alsp,"~/University of Bristol/grp-EPoCH - Documents/WP3_data/3.5 preparation/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Alcohol/Alcohol prep files/raw_alcohol_snps_exc_alsp")

#save betas .txt file
alcohol_betas<-alcohol_snps_exc_alsp[,c("RSID","ALT","BETA")]
write.table(alcohol_betas, file = "alcohol_betas.txt", sep = "\t", col.names = F,row.names = F, quote=F)


#####################################################
### Extra code:
#filter by 5x10-8 if were doing it this way
alcohol_data <- select(filter(raw_alcohol_data, PVALUE < 0.00000005))

alcohol_data<-raw_alcohol_data[which(raw_alcohol_data$PVALUE< 0.00000005),]
# 5*10^(-8)
# 0.00000005


##########################################################################
#######                    Smoking                                 #######
##########################################################################

setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/")

#####################################################
#######        Cigarettes per day             #######
#####################################################

#load data
cigs_pd_snps_original <- read.table("original_cigs_pd_SNPs.txt",header = F)
cigs_pd_snps_exc_alsp_original <- read.table("cpd_noICC.txt",header = T)

# merge original SNP list with the betas from the sample excluding 23andme and ALSPAC
library(reshape)
cigs_pd_snps_original <- rename(cigs_pd_snps_original, c(V1="RSID")) 
cigs_pd_snps_exc_alsp <- merge(cigs_pd_snps_original, cigs_pd_snps_exc_alsp_original, by="RSID", all.x=TRUE)

#save raw file
#saveRDS(cigs_pd_snps_exc_alsp,"~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/raw_cigs_pd_snps_exc_alsp")

#save betas .txt file
cigs_pd_betas<-cigs_pd_snps_exc_alsp[,c("RSID","ALT","BETA")]
write.table(cigs_pd_betas, file = "cigs_pd_betas.txt", sep = "\t", col.names = F,row.names = F, quote=F)


#####################################################
#######        Smoking initiation             #######
#####################################################
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/")

#load data
smoking_initiation_snps_original <- read.table("original_smoking_initiation_SNPs.txt",header = F)
smoking_initiation_snps_exc_alsp_original <- read.table("si_noICC.txt",header = T)

# merge original SNP list with the betas from the sample excluding 23andme and ALSPAC
library(reshape)
smoking_initiation_snps_original <- rename(smoking_initiation_snps_original, c(V1="RSID")) 
smoking_initiation_snps_exc_alsp <- merge(smoking_initiation_snps_original, smoking_initiation_snps_exc_alsp_original, by="RSID", all.x=TRUE)

#save raw file
#saveRDS(smoking_initiation_snps_exc_alsp,"~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/raw_smoking_initiation_snps_exc_alsp")

#save betas .txt file
smoking_initiation_betas<-smoking_initiation_snps_exc_alsp[,c("RSID","ALT","BETA")]
write.table(smoking_initiation_betas, file = "smoking_initiation_betas.txt", sep = "\t", col.names = F,row.names = F, quote=F)


#####################################################
#######        Smoking cessation              #######
#####################################################
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/")

#load data
smoking_cessation_snps_original <- read.table("original_smoking_cessation_SNPs.txt",header = F)
smoking_cessation_snps_exc_alsp_original <- read.table("sc_noICC.txt",header = T)

# merge original SNP list with the betas from the sample excluding 23andme and ALSPAC
library(reshape)
smoking_cessation_snps_original <- rename(smoking_cessation_snps_original, c(V1="RSID")) 
smoking_cessation_snps_exc_alsp <- merge(smoking_cessation_snps_original, smoking_cessation_snps_exc_alsp_original, by="RSID", all.x=TRUE)

#save raw file
#saveRDS(smoking_cessation_snps_exc_alsp,"~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/raw_smoking_cessation_snps_exc_alsp")

#save betas .txt file
smoking_cessation_betas<-smoking_cessation_snps_exc_alsp[,c("RSID","ALT","BETA")]
write.table(smoking_cessation_betas, file = "smoking_cessation_betas.txt", sep = "\t", col.names = F,row.names = F, quote=F)

#####################################################
#######        Smoking age of initiation      #######
#####################################################
setwd("~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/")

#load data
smoking_age_init_snps_original <- read.table("original_smoking_age_init_SNPs.txt",header = F)
smoking_age_init_snps_exc_alsp_original <- read.table("ai_noICC.txt",header = T)

# merge original SNP list with the betas from the sample excluding 23andme and ALSPAC
library(reshape)
smoking_age_init_snps_original <- rename(smoking_age_init_snps_original, c(V1="RSID")) 
smoking_age_init_snps_exc_alsp <- merge(smoking_age_init_snps_original, smoking_age_init_snps_exc_alsp_original, by="RSID", all.x=TRUE)

#save raw file
#saveRDS(smoking_age_init_snps_exc_alsp,"~/University of Bristol/grp-EPoCH - Documents/EPoCH Github/data_prep/cohorts/alspac/Genetic scores/GSCAN_excluding_ALSPAC_23andme/Smoking/Smoking prep files/raw_smoking_age_init_snps_exc_alsp")

#save betas .txt file
smoking_age_init_betas<-smoking_age_init_snps_exc_alsp[,c("RSID","ALT","BETA")]
write.table(smoking_age_init_betas, file = "smoking_age_init_betas.txt", sep = "\t", col.names = F,row.names = F, quote=F)

