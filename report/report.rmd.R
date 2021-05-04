# packages
require(ggplot2)
require(ggthemr)
require(gridExtra)
require(dplyr)
require(ggstance)


# read key
key <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/master_key.RDS")

# select exposure of interest
eoi <- c("smoking","ever in pregnancy","basic","binary")
key_here <- key[key$exposure_class==eoi[1]&key$exposure_time==eoi[2]&key$exposure_subclass==eoi[3]&key$exposure_type==eoi[4],]
key_here <- key_here[-which(key_here$outcome_class=="negative control outcomes"),]
key_here <- key_here[-intersect(grep(key_here$outcome_type, pattern="numerical"),grep(key_here$outcome,pattern="zscore|sds",invert = T)),]
key_here <- key_here[-intersect(grep(key_here$outcome,pattern="bmi"),grep(key_here$outcome,pattern="zscore")),]

# Table 1 (summarise the maximum N exposed and unexposed in each cohort and in total, and the mean ages of parents, proportion parity>1, proportion female, proportion each SEP level, ethnicity)

# Basic pheWAS plot (model 1a)
df_model1a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
df_model1a <- df_model1a[df_model1a$exposure %in% key_here$exposure & df_model1a$outcome %in% key_here$outcome,]

df_model1a$outcome_time <- factor(df_model1a$outcome_time,ordered=T,levels=c(
  "any time in childhood","first year", "age 1 or 2","age 3 or 4","age 5, 6 or 7","age 8, 9, 10 or 11"
))

df_model1a <- df_model1a[order(df_model1a$outcome_class,df_model1a$outcome_time,-log10(df_model1a$p)),]
df_model1a$outcome_term <- factor(df_model1a$outcome_term,ordered=T,levels=unique(df_model1a$outcome_term))

ggthemr("flat")
phewas_pvalue_plot <- function(outcomeclass){
ggplot(df_model1a[df_model1a$outcome_class==outcomeclass,],aes(x=outcome_subclass2,y=-log10(p)))+
  geom_point(alpha=0.7,colour="#34495e",aes(fill=person_exposed,shape=outcome_type))+
  geom_hline(yintercept=-log10(0.0002),linetype="dashed",colour="#34495e",size=0.5)+
  scale_shape_manual(values=c(21,22),limits=c("binary","numerical"))+
  scale_fill_manual(values=c("#2ecc71","#3498db"),limits=c("mother","father"),
                    guide=guide_legend(override.aes=list(shape=21)))+
  facet_grid(.~outcome_time,space="free",scales = "free")+
  labs(fill = "Parent exposed",shape="Outcome type")  +
  theme(axis.text.x=element_text(angle=45,hjust=1,size = 8),axis.title.x=element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
#        strip.text = element_blank(), strip.background = element_blank(),
        panel.spacing = unit(0.2, "lines"))
}

all_plots <- lapply(unique(df_model1a$outcome_class),phewas_pvalue_plot)
grid.arrange(all_plots[[1]],all_plots[[2]],all_plots[[3]],all_plots[[4]],nrow=4)


# Covariate adjustment (model 2a) plot for anything with P<0.05 

hits_1a <- as.character(unique(df_model1a$outcome_term[df_model1a$p<0.05]))

df_model1a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
df_model2a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
df_model2a <- df_model2a[df_model2a$exposure %in% key_here$exposure & df_model2a$outcome_term %in% hits_1a,]
df_model1a <- df_model1a[df_model1a$exposure %in% key_here$exposure & df_model1a$outcome_term %in% hits_1a,]

df_model1a2a <- bind_rows(df_model1a,df_model2a)

# to convert ln(OR) to cohen's d (SDM), multiply ln(OR) by sqrt(3)/pi (which is 0.5513)
# to convert SDM to ln(OR), multiply SDM by pi/sqrt(3) (which is 1.814)
# https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
# https://onlinelibrary.wiley.com/doi/abs/10.1002/1097-0258(20001130)19:22%3C3127::AID-SIM784%3E3.0.CO;2-M

df_model1a2a$est_SDM <- df_model1a2a$est
df_model1a2a$est_SDM[df_model1a2a$outcome_type=="binary"|df_model1a2a$outcome_type=="ordinal"]<-df_model1a2a$est[df_model1a2a$outcome_type=="binary"|df_model1a2a$outcome_type=="ordinal"]*0.5513

df_model1a2a$se_SDM <- df_model1a2a$se
df_model1a2a$se_SDM[df_model1a2a$outcome_type=="binary"|df_model1a2a$outcome_type=="ordinal"]<-df_model1a2a$se[df_model1a2a$outcome_type=="binary"|df_model1a2a$outcome_type=="ordinal"]*0.5513

ggplot(df_model1a2a,aes(x=est_SDM,y=outcome_term,xmin=est_SDM-(1.96*se_SDM),xmax=est_SDM+(1.96*se_SDM),colour=model))+
  geom_errorbarh(height=0,position=position_dodgev(.5))+
  geom_point(size = 2,fill="white",position=position_dodgev(.5))+
  facet_grid(outcome_class~person_exposed,scales="free",space="free")+
  geom_vline(xintercept=0,size = .25, linetype = "dashed")+
  xlab("Cohen's d")+
  ylab("")+
  scale_shape_manual(values=c(22,15))+
  theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))

# Negative control (model 2b)

hits_2a_m <- as.character(unique(df_model1a2a$outcome_term[df_model1a2a$p<0.05&df_model1a2a$person_exposed=="mother"]))
hits_2a_p <- as.character(unique(df_model1a2a$outcome_term[df_model1a2a$p<0.05&df_model1a2a$person_exposed=="father"]))

df_model2b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")

df_model2b$est_SDM <- df_model2b$est
df_model2b$est_SDM[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]<-df_model2b$est[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]*0.5513
df_model2b$se_SDM <- df_model2b$se
df_model2b$se_SDM[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]<-df_model2b$se[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]*0.5513

df_model2b_m_m <- df_model2b[df_model2b$person_exposed=="mother" & df_model2b$exposure %in% key_here$exposure & df_model2b$outcome_term %in% hits_2a_m,]
df_model2b_p_p <- df_model2b[df_model2b$person_exposed=="father" & df_model2b$exposure %in% key_here$exposure & df_model2b$outcome_term %in% hits_2a_p,]
df_model2b_m_p <- df_model2b[df_model2b$person_exposed=="mother" & df_model2b$exposure %in% key_here$exposure & df_model2b$outcome_term %in% hits_2a_p,]
df_model2b_p_m <- df_model2b[df_model2b$person_exposed=="father" & df_model2b$exposure %in% key_here$exposure & df_model2b$outcome_term %in% hits_2a_m,]

df_model2b_m_m<-df_model2b_m_m[match(df_model2b_p_m$outcome,df_model2b_m_m$outcome),]
df_model2b_p_p<-df_model2b_p_p[match(df_model2b_m_p$outcome,df_model2b_p_p$outcome),]


df_model2b_mat_hits <- bind_rows(df_model2b_m_m,df_model2b_p_m)
df_model2b_pat_hits <- bind_rows(df_model2b_p_p,df_model2b_m_p)

ggplot(df_model2b_mat_hits,aes(x=est_SDM,y=outcome_term,xmin=est_SDM-(1.96*se_SDM),xmax=est_SDM+(1.96*se_SDM),colour=person_exposed))+
  geom_errorbarh(height=0,position=position_dodgev(.5))+
  geom_point(size = 2,fill="white",position=position_dodgev(.5))+
  facet_grid(outcome_class~.,scales="free",space="free")+
  geom_vline(xintercept=0,size = .25, linetype = "dashed")+
  xlab("Cohen's d")+
  ylab("")+
  scale_shape_manual(values=c(22,15))+
  theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))

ggplot(df_model2b_pat_hits,aes(x=est_SDM,y=outcome_term,xmin=est_SDM-(1.96*se_SDM),xmax=est_SDM+(1.96*se_SDM),colour=person_exposed))+
  geom_errorbarh(height=0,position=position_dodgev(.5))+
  geom_point(size = 2,fill="white",position=position_dodgev(.5))+
  facet_grid(outcome_class~.,scales="free",space="free")+
  geom_vline(xintercept=0,size = .25, linetype = "dashed")+
  xlab("Cohen's d")+
  ylab("")+
  scale_shape_manual(values=c(22,15))+
  theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))

# Timing

hits_2b_m <- unique(df_model2b_m_m$outcome_term[(abs(df_model2b_m_m$est_SDM) > abs(df_model2b_p_m$est_SDM)) & df_model2b_m_m$p<0.05])
hits_2b_p <- unique(df_model2b_p_p$outcome_term[(abs(df_model2b_p_p$est_SDM) > abs(df_model2b_m_p$est_SDM)) & df_model2b_p_p$p<0.05])

df_model2b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")

df_model2b$est_SDM <- df_model2b$est
df_model2b$est_SDM[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]<-df_model2b$est[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]*0.5513
df_model2b$se_SDM <- df_model2b$se
df_model2b$se_SDM[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]<-df_model2b$se[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]*0.5513

# Dose response



# MR



# 





# psychosocial outcomes

key <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/master_key.RDS")

eoi <- c("smoking","ever in pregnancy","basic","binary","self-reported or measured")
key_here <- key[key$exposure_class==eoi[1]&key$exposure_time==eoi[2]&key$exposure_subclass==eoi[3]&key$exposure_type==eoi[4]&key$exposure_source==eoi[5],]
key_here <- key_here[-which(key_here$outcome_class=="negative control outcomes"),]
key_here <- key_here[-intersect(grep(key_here$outcome_type, pattern="numerical"),grep(key_here$outcome,pattern="zscore|sds",invert = T)),]
key_here <- key_here[-intersect(grep(key_here$outcome,pattern="bmi"),grep(key_here$outcome,pattern="zscore")),]

key_here <- key_here[which(key_here$outcome%in%unique(key$outcome[key$outcome_class=="psychosocial and cognitive outcomes"&key$outcome_type=="binary"])),]

# Table 1 (summarise the maximum N exposed and unexposed in each cohort and in total, and the mean ages of parents, proportion parity>1, proportion female, proportion each SEP level, ethnicity)

df_model2a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
df_model2b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")

df_model2a <- df_model2a[df_model2a$exposure %in% key_here$exposure & df_model2a$outcome %in% key_here$outcome,]
df_model2b <- df_model2b[df_model2b$exposure %in% key_here$exposure & df_model2b$outcome %in% key_here$outcome,]

df_model2a$est_SDM <- df_model2a$est
df_model2a$est_SDM[df_model2a$outcome_type=="binary"|df_model2a$outcome_type=="ordinal"]<-df_model2a$est[df_model2a$outcome_type=="binary"|df_model2a$outcome_type=="ordinal"]*0.5513
df_model2a$se_SDM <- df_model2a$se
df_model2a$se_SDM[df_model2a$outcome_type=="binary"|df_model2a$outcome_type=="ordinal"]<-df_model2a$se[df_model2a$outcome_type=="binary"|df_model2a$outcome_type=="ordinal"]*0.5513

df_model2b$est_SDM <- df_model2b$est
df_model2b$est_SDM[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]<-df_model2b$est[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]*0.5513
df_model2b$se_SDM <- df_model2b$se
df_model2b$se_SDM[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]<-df_model2b$se[df_model2b$outcome_type=="binary"|df_model2b$outcome_type=="ordinal"]*0.5513

hits <- bind_rows(df_model2a,df_model2b)

hits <- hits[order(hits$est),]
hits$outcome_subclass2 <- factor(hits$outcome_subclass2,ordered=T,levels=unique(hits$outcome_subclass2))

hits$person_model <-NA
hits$person_model[hits$person_exposed=="mother"&hits$model=="model2a"]<-"maternal smoking"
hits$person_model[hits$person_exposed=="mother"&hits$model=="model2b"]<-"maternal smoking with adjustment for paternal smoking"
hits$person_model[hits$person_exposed=="father"&hits$model=="model2a"]<-"paternal smoking"
hits$person_model[hits$person_exposed=="father"&hits$model=="model2b"]<-"paternal smoking with adjustment for maternal smoking"

ggthemr("flat dark",layout="clean",type="outer")
ggplot(hits,aes(x=exp(est),y=outcome_subclass2,xmin=exp(est-(1.96*se)),xmax=exp(est+(1.96*se)),colour=person_model,shape=person_model))+
  geom_vline(xintercept=1,linetype="dashed")+
  geom_errorbarh(height=0,position=position_dodgev(.5))+
  geom_point(size = 2,position=position_dodgev(.5))+
  facet_grid(outcome_subclass2~outcome_time,scales="free",space="free")+
  xlab("Odds ratio")+
  ylab("")+
  scale_colour_manual(values=c("mediumpurple1","mediumpurple1","cadetblue1","cadetblue1"))+
  scale_shape_manual(values=c(22,15,21,19))+
  coord_trans(x="log10")+
  theme(strip.text = element_blank(),
    legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))



df_model1a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
df_model1b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1b_extracted.RDS")
df_model2a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
df_model2b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")

df_model2a <- df_model2a[df_model2a$exposure %in% key_here$exposure & df_model2a$outcome %in% "neuro_hyperactivity_stage4_binary",]
df_model2b <- df_model2b[df_model2b$exposure %in% key_here$exposure & df_model2b$outcome %in% "neuro_hyperactivity_stage4_binary",]
df_model1a <- df_model1a[df_model1a$exposure %in% key_here$exposure & df_model1a$outcome %in% "neuro_hyperactivity_stage4_binary",]
df_model1b <- df_model1b[df_model1b$exposure %in% key_here$exposure & df_model1b$outcome %in% "neuro_hyperactivity_stage4_binary",]


df_prs<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
df_prs <- df_prs[df_prs$exposure %in% "prs_score_mother_smoking_cigs_pd_zscore" & df_prs$outcome %in% "neuro_hyperactivity_stage4_binary",]

hits1 <- bind_rows(df_model1a,df_model1b)
hits2 <- bind_rows(df_model2a,df_model2b)



hits1$person_model <-NA
hits1$person_model[hits1$person_exposed=="mother"&hits1$model=="model1a"]<-"maternal smoking"
hits1$person_model[hits1$person_exposed=="mother"&hits1$model=="model1b"]<-"maternal smoking with adjustment for paternal smoking"
hits1$person_model[hits1$person_exposed=="father"&hits1$model=="model1a"]<-"paternal smoking"
hits1$person_model[hits1$person_exposed=="father"&hits1$model=="model1b"]<-"paternal smoking with adjustment for maternal smoking"
hits2$person_model <-NA
hits2$person_model[hits2$person_exposed=="mother"&hits2$model=="model2a"]<-"maternal smoking"
hits2$person_model[hits2$person_exposed=="mother"&hits2$model=="model2b"]<-"maternal smoking with adjustment for paternal smoking"
hits2$person_model[hits2$person_exposed=="father"&hits2$model=="model2a"]<-"paternal smoking"
hits2$person_model[hits2$person_exposed=="father"&hits2$model=="model2b"]<-"paternal smoking with adjustment for maternal smoking"
df_prs$person_model <-"maternal smoking"

hits <- bind_rows(hits1,hits2,df_prs)
hits$modelnumber <- c("Minimal adjustment","Minimal adjustment","Minimal adjustment","Minimal adjustment","Confounder adjustment","Confounder adjustment","Confounder adjustment","Confounder adjustment","Genetic risk score\nfor maternal smoking")
hits$modelnumber <-factor(hits$modelnumber,ordered=T,levels=unique(hits$modelnumber))

ggthemr("flat dark",layout="clean",type="outer")
ggplot(hits,aes(x=exp(est),y=outcome_subclass2,xmin=exp(est-(1.96*se)),xmax=exp(est+(1.96*se)),colour=person_model,shape=person_model))+
  geom_vline(xintercept=1,linetype="dashed")+
  geom_errorbarh(height=0,position=position_dodgev(.5))+
  geom_point(size = 2,position=position_dodgev(.5))+
  facet_grid(modelnumber~.,switch="y")+
  xlab("Odds ratio")+
  ylab("")+
  scale_colour_manual(values=c("mediumpurple1","mediumpurple1","cadetblue1","cadetblue1"))+
  scale_shape_manual(values=c(22,15,21,19))+
  coord_trans(x="log10")+
  scale_x_continuous(breaks = c(1,1.5,2) )+
  theme(strip.text.y.left = element_text(angle = 0,hjust = 1),axis.text.y=element_blank(),
        legend.title=element_blank())



