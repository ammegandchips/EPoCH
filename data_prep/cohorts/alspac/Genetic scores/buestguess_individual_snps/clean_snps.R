
# Individual SNP (buestguess) {.tabset}

## Read in data

```{r eval=FALSE, include=TRUE}
snps_alcohol_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/alcohol_mothers_excluded_numb.raw", header=T)
snps_alcohol_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/alcohol_children_excluded_numb.raw", header=T)

snps_caffeine_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/caffeine_mothers_excluded_numb.raw", header=T)
snps_caffeine_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/caffeine_children_excluded_numb.raw", header=T)

snps_smoking_age_init_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_age_init_mothers_excluded_numb.raw", header=T)
snps_smoking_age_init_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_age_init_children_excluded_numb.raw", header=T)

snps_smoking_cessation_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cessation_mothers_excluded_numb.raw", header=T)
snps_smoking_cessation_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cessation_children_excluded_numb.raw", header=T)

snps_smoking_cigs_pd_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cigs_pd_mothers_excluded_numb.raw", header=T)
snps_smoking_cigs_pd_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_cigs_pd_children_excluded_numb.raw", header=T)

snps_smoking_initiation_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_initiation_mothers_excluded_numb.raw", header=T)
snps_smoking_initiation_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/smoking_initiation_children_excluded_numb.raw", header=T)

snps_pa_sedentary_buestguess_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_sedentary_mothers_excluded_numb.raw", header=T)
snps_pa_sedentary_buestguess_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_sedentary_children_excluded_numb.raw", header=T)

snps_pa_overall_activity_mother<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_overall_activity_mothers_excluded_numb.raw", header=T)
snps_pa_overall_activity_children<-read.table("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/individual_snps/pa_overall_activity_children_excluded_numb.raw", header=T)
```

## Clean variables

```{r eval=FALSE, include=TRUE}
# (rename) add mother_snp to start of all snp columns
names(snps_alcohol_buestguess_mother)<-paste("mother_snp_alc_",names(snps_alcohol_buestguess_mother),sep="")
names(snps_alcohol_buestguess_children)<-paste("children_snp_alc_",names(snps_alcohol_buestguess_children),sep="")

names(snps_caffeine_buestguess_mother)<-paste("mother_snp_caff_",names(snps_caffeine_buestguess_mother),sep="")
names(snps_caffeine_buestguess_children)<-paste("children_snp_caff_",names(snps_caffeine_buestguess_children),sep="")

names(snps_smoking_age_init_buestguess_mother)<-paste("mother_snp_age_init_",names(snps_smoking_age_init_buestguess_mother),sep="")
names(snps_smoking_age_init_buestguess_children)<-paste("children_snp_age_init_",names(snps_smoking_age_init_buestguess_children),sep="")

names(snps_smoking_cessation_buestguess_mother)<-paste("mother_snp_cessation_",names(snps_smoking_cessation_buestguess_mother),sep="")
names(snps_smoking_cessation_buestguess_children)<-paste("children_snp_cessation_",names(snps_smoking_cessation_buestguess_children),sep="")

names(snps_smoking_cigs_pd_buestguess_mother)<-paste("mother_snp_cigspd_",names(snps_smoking_cigs_pd_buestguess_mother),sep="")
names(snps_smoking_cigs_pd_buestguess_children)<-paste("children_snp_cigspd_",names(snps_smoking_cigs_pd_buestguess_children),sep="")

names(snps_smoking_initiation_buestguess_mother)<-paste("mother_snp_initiation_",names(snps_smoking_initiation_buestguess_mother),sep="")
names(snps_smoking_initiation_buestguess_children)<-paste("children_snp_initiation_",names(snps_smoking_initiation_buestguess_children),sep="")

names(snps_pa_sedentary_buestguess_mother)<-paste("mother_snp_sedentary_",names(snps_pa_sedentary_buestguess_mother),sep="")
names(snps_pa_sedentary_buestguess_children)<-paste("children_snp_sedentary_",names(snps_pa_sedentary_buestguess_children),sep="")

names(snps_pa_overall_activity_mother)<-paste("mother_snp_overallact_",names(snps_pa_overall_activity_mother),sep="")
names(snps_pa_overall_activity_children)<-paste("children_snp_overallact_",names(snps_pa_overall_activity_children),sep="")
```

###  Create aln and qlet and delete columns dont need

**Maternal**
  
  ```{r eval=FALSE, include=TRUE}
snps_alcohol_buestguess_mother$aln <-as.numeric(substr(snps_alcohol_buestguess_mother$mother_snp_alc_FID, 1, 5))
snps_alcohol_buestguess_mother$qlet<-substr(snps_alcohol_buestguess_mother$mother_snp_alc_FID, 6, 6)
snps_alcohol_buestguess_mother<-snps_alcohol_buestguess_mother[-c(1:6)] 

snps_caffeine_buestguess_mother$aln <-as.numeric(substr(snps_caffeine_buestguess_mother$mother_snp_caff_FID, 1, 5))
snps_caffeine_buestguess_mother$qlet<-substr(snps_caffeine_buestguess_mother$mother_snp_caff_FID, 6, 6)
snps_caffeine_buestguess_mother<-snps_caffeine_buestguess_mother[-c(1:6)]

snps_smoking_age_init_buestguess_mother$aln <-as.numeric(substr(snps_smoking_age_init_buestguess_mother$mother_snp_age_init_FID, 1, 5))
snps_smoking_age_init_buestguess_mother$qlet<-substr(snps_smoking_age_init_buestguess_mother$mother_snp_age_init_FID, 6, 6)
snps_smoking_age_init_buestguess_mother<-snps_smoking_age_init_buestguess_mother[-c(1:6)]

snps_smoking_cessation_buestguess_mother$aln <-as.numeric(substr(snps_smoking_cessation_buestguess_mother$mother_snp_cessation_FID, 1, 5))
snps_smoking_cessation_buestguess_mother$qlet<-substr(snps_smoking_cessation_buestguess_mother$mother_snp_cessation_FID, 6, 6)
snps_smoking_cessation_buestguess_mother<-snps_smoking_cessation_buestguess_mother[-c(1:6)]

snps_smoking_cigs_pd_buestguess_mother$aln <-as.numeric(substr(snps_smoking_cigs_pd_buestguess_mother$mother_snp_cigspd_FID, 1, 5))
snps_smoking_cigs_pd_buestguess_mother$qlet<-substr(snps_smoking_cigs_pd_buestguess_mother$mother_snp_cigspd_FID, 6, 6)
snps_smoking_cigs_pd_buestguess_mother<-snps_smoking_cigs_pd_buestguess_mother[-c(1:6)]

snps_smoking_initiation_buestguess_mother$aln <-as.numeric(substr(snps_smoking_initiation_buestguess_mother$mother_snp_initiation_FID, 1, 5))
snps_smoking_initiation_buestguess_mother$qlet<-substr(snps_smoking_initiation_buestguess_mother$mother_snp_initiation_FID, 6, 6)
snps_smoking_initiation_buestguess_mother<-snps_smoking_initiation_buestguess_mother[-c(1:6)]

snps_pa_sedentary_buestguess_mother$aln <-as.numeric(substr(snps_pa_sedentary_buestguess_mother$mother_snp_sedentary_FID, 1, 5))
snps_pa_sedentary_buestguess_mother$qlet<-substr(snps_pa_sedentary_buestguess_mother$mother_snp_sedentary_FID, 6, 6)
snps_pa_sedentary_buestguess_mother<-snps_pa_sedentary_buestguess_mother[-c(1:6)]

snps_pa_overall_activity_mother$aln <-as.numeric(substr(snps_pa_overall_activity_mother$mother_snp_overallact_FID, 1, 5))
snps_pa_overall_activity_mother$qlet<-substr(snps_pa_overall_activity_mother$mother_snp_overallact_FID, 6, 6)
snps_pa_overall_activity_mother<-snps_pa_overall_activity_mother[-c(1:6)]

```

**Child**
  ```{r eval=FALSE, include=TRUE}
snps_alcohol_buestguess_children$aln <-as.numeric(substr(snps_alcohol_buestguess_children$children_snp_alc_FID, 1, 5))
snps_alcohol_buestguess_children$qlet<-substr(snps_alcohol_buestguess_children$children_snp_alc_FID, 6, 6)
snps_alcohol_buestguess_children<-snps_alcohol_buestguess_children[-c(1:6)]

snps_caffeine_buestguess_children$aln <-as.numeric(substr(snps_caffeine_buestguess_children$children_snp_caff_FID, 1, 5))
snps_caffeine_buestguess_children$qlet<-substr(snps_caffeine_buestguess_children$children_snp_caff_FID, 6, 6)
snps_caffeine_buestguess_children<-snps_caffeine_buestguess_children[-c(1:6)]

snps_smoking_age_init_buestguess_children$aln <-as.numeric(substr(snps_smoking_age_init_buestguess_children$children_snp_age_init_FID, 1, 5))
snps_smoking_age_init_buestguess_children$qlet<-substr(snps_smoking_age_init_buestguess_children$children_snp_age_init_FID, 6, 6)
snps_smoking_age_init_buestguess_children<-snps_smoking_age_init_buestguess_children[-c(1:6)]

snps_smoking_cessation_buestguess_children$aln <-as.numeric(substr(snps_smoking_cessation_buestguess_children$children_snp_cessation_FID, 1, 5))
snps_smoking_cessation_buestguess_children$qlet<-substr(snps_smoking_cessation_buestguess_children$children_snp_cessation_FID, 6, 6)
snps_smoking_cessation_buestguess_children<-snps_smoking_cessation_buestguess_children[-c(1:6)]

snps_smoking_cigs_pd_buestguess_children$aln <-as.numeric(substr(snps_smoking_cigs_pd_buestguess_children$children_snp_cigspd_FID, 1, 5))
snps_smoking_cigs_pd_buestguess_children$qlet<-substr(snps_smoking_cigs_pd_buestguess_children$children_snp_cigspd_FID, 6, 6)
snps_smoking_cigs_pd_buestguess_children<-snps_smoking_cigs_pd_buestguess_children[-c(1:6)]

snps_smoking_initiation_buestguess_children$aln <-as.numeric(substr(snps_smoking_initiation_buestguess_children$children_snp_initiation_FID, 1, 5))
snps_smoking_initiation_buestguess_children$qlet<-substr(snps_smoking_initiation_buestguess_children$children_snp_initiation_FID, 6, 6)
snps_smoking_initiation_buestguess_children<-snps_smoking_initiation_buestguess_children[-c(1:6)]

snps_pa_sedentary_buestguess_children$aln <-as.numeric(substr(snps_pa_sedentary_buestguess_children$children_snp_sedentary_FID, 1, 5))
snps_pa_sedentary_buestguess_children$qlet<-substr(snps_pa_sedentary_buestguess_children$children_snp_sedentary_FID, 6, 6)
snps_pa_sedentary_buestguess_children<-snps_pa_sedentary_buestguess_children[-c(1:6)]

snps_pa_overall_activity_children$aln <-as.numeric(substr(snps_pa_overall_activity_children$children_snp_overallact_FID, 1, 5))
snps_pa_overall_activity_children$qlet<-substr(snps_pa_overall_activity_children$children_snp_overallact_FID, 6, 6)
snps_pa_overall_activity_children<-snps_pa_overall_activity_children[-c(1:6)]

```

## Merge
```{r eval=FALSE, include=TRUE}
dat<-left_join(dat,snps_alcohol_buestguess_mother[,-which(colnames(snps_alcohol_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_alcohol_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_caffeine_buestguess_mother[,-which(colnames(snps_caffeine_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_caffeine_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_age_init_buestguess_mother[,-which(colnames(snps_smoking_age_init_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_age_init_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_cessation_buestguess_mother[,-which(colnames(snps_smoking_cessation_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_cessation_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_cigs_pd_buestguess_mother[,-which(colnames(snps_smoking_cigs_pd_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_cigs_pd_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_smoking_initiation_buestguess_mother[,-which(colnames(snps_smoking_initiation_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_smoking_initiation_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_pa_sedentary_buestguess_mother[,-which(colnames(snps_pa_sedentary_buestguess_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_pa_sedentary_buestguess_children, by =c("aln", "qlet"))

dat<-left_join(dat,snps_pa_overall_activity_mother[,-which(colnames(snps_pa_overall_activity_mother) =="qlet")], by =c("aln"))
dat<-left_join(dat,snps_pa_overall_activity_children, by =c("aln", "qlet"))

```

# Save file {.tabset}
#You must be connected to the server: smb://rdsfcifs.acrc.bris.ac.uk/MRC-IEU-research/
  ```{r eval=FALSE, include=TRUE}
saveRDS(dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds")
```