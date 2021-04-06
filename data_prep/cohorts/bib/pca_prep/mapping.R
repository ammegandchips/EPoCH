

##### create fam file for plink for PCA ####
#### load chip to id mapping 
#load("/Volumes/MRC-IEU-research/data/bib/phenotypic/released/2019-04-01/data/rdata/Linkage_v7_gwaslp_Data.Rdata")
load("/Volumes/MRC-IEU-research-1/data/bib/phenotypic/released/2019-04-01/data/rdata/Linkage_v7_gwaslp_Data.Rdata")

mapping<-dat[c("PregnancyID", "gwassentrixps")]
mapping<-mapping[which(mapping$gwassentrixps!=""),]
​
#### add fam fields 
mapping$within_fam <- 1
mapping$father <- 0
mapping$mother <- 0
mapping$sex <- 2
mapping$pheno <- -9
​
#### output selected fields 
e<-as.numeric(Sys.time())
write.table(mapping[c("gwassentrixps", "within_fam", "father", "mother", "sex", "pheno")], col.names=F, quote=F, row.names=F, sep=" ", 
            file=paste0('/Volumes/MRC-IEU-research-1/projects/ieu2/p5/015/working/data/bib/mapping/geno_ids_', e, '.fam'))


## Separate for child
##### create fam file for plink####
#### load chip to id mapping 
get(load("/Volumes/MRC-IEU-research-1/data/bib/phenotypic/released/2019-04-01/data/rdata/Linkage_v7_gwaslc_Data.Rdata"))
mapping<-dat[c("PregnancyID", "gwassentrixcs")]
mapping<-mapping[which(mapping$gwassentrixcs!=""),]
​
#### add fam fields 
mapping$within_fam <- 1
mapping$father <- 0
mapping$mother <- 0
mapping$sex <- 2
mapping$pheno <- -9
​
#### output selected fields 
e<-as.numeric(Sys.time())
write.table(mapping[c("gwassentrixcs", "within_fam", "father", "mother", "sex", "pheno")], col.names=F, quote=F, row.names=F, sep=" ", file="/Volumes/MRC-IEU-research-1/projects/ieu2/p5/015/working/data/bib/mapping/child_geno_ids.fam")
​