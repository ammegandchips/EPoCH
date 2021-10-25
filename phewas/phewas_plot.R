RES <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")

res <-RES[RES$exposure_linker=="smoking-basic-ever in pregnancy-father-binary-self-reported or measured NA",]
require(ggplot2)



res <- res[-which(res$outcome_class %in% c("negative control outcomes","perinatal survival outcomes")),]
res_bin <- res[res$outcome_type=="binary",]
res_cont <- res[res$outcome_type=="numerical",]

res_bin$lci <- res_bin$est - (1.96* res_bin$se)
res_bin$uci <- res_bin$est + (1.96*res_bin$se)
res_bin[,grep(colnames(res_bin),pattern="est|uci|lci")] <- exp(res_bin[,grep(colnames(res_bin),pattern="est|uci|lci")])

res_bin <- res_bin[order(res_bin$est),]
res_bin$outcome_linker <- factor(res_bin$outcome_linker,ordered=T,levels=unique(res_bin$outcome_linker))

plot_bin <- ggplot(res_bin)+
  geom_vline(xintercept = 1)+
  geom_point(aes(x=est_ALSPAC,y=1,size=),colour="blue",alpha=0.5,shape=15,size=3)+
  geom_point(aes(x=est_BIB_ALL,y=1),colour="green",alpha=0.5,shape=15,size=3)+
  geom_point(aes(x=est_MCS,y=1),colour="orange",alpha=0.5,shape=15,size=3)+
  geom_errorbarh(aes(y=1,xmin=lci,xmax=uci,height=0))+
  geom_point(aes(x=est,y=1),shape=23,alpha=0.9,fill="black")+
  facet_grid(outcome_class+outcome_linker~.,scales = "free",space = "free_y",switch = "y")+
  theme(strip.text.y.left = element_text(angle = 0,hjust=1),
        axis.text.y=element_blank(),panel.spacing = unit(0, "lines"),axis.ticks.y=element_blank(),
        panel.grid.major.y=element_blank(),panel.grid.minor.y=element_blank())+
coord_trans(x = 'log10')+
  scale_x_continuous(breaks = c(0.5, 0.75, 1, 1.5, 2, 2.5, 3))

require(stringr)
res_cont$lci <- res_cont$est - (1.96* res_cont$se)
res_cont$uci <- res_cont$est + (1.96*res_cont$se)
res_cont <- res_cont[order(res_cont$est),]
#res_cont[-grep(res_cont$outcome_linker,pattern="reactive|interleukin"),]->res_cont
res_cont$outcome_text <- unlist(lapply(strsplit(res_cont$outcome_linker,split="-"),function(x) paste(x[3:4],collapse = " - ")))
substr(res_cont$outcome_text,1,1) <- toupper(substr(res_cont$outcome_text,1,1))
res_cont$outcome_text <- factor(res_cont$outcome_text,ordered=T,levels=res_cont$outcome_text)

plot_cont <- ggplot(res_cont)+
  geom_vline(xintercept = 0)+
  geom_point(aes(x=est_ALSPAC,y=1,colour="tomato3"),alpha=0.5,shape=15,size=3)+
  geom_point(aes(x=est_BIB_ALL,y=1,colour="seagreen"),alpha=0.5,shape=15,size=3)+
  geom_point(aes(x=est_MCS,y=1,colour="cornflowerblue"),alpha=0.5,shape=15,size=3)+
  geom_point(aes(x=est,y=1,fill="black"),shape=23,alpha=0.9,colour="black")+
  scale_color_identity(name = "Cohort estimates:",
                       breaks = c("cornflowerblue", "seagreen", "tomato3"),
                       labels = c("MCS", "BiB","ALSPAC"),
                       guide = "legend")+
  scale_fill_identity(name="Meta-analysis estimate:",
                      breaks = "black",
                      labels="",
                      guide="legend")+
  geom_errorbarh(aes(y=1,xmin=lci,xmax=uci,height=0))+
  facet_grid(outcome_class+outcome_text~.,scales = "free",space = "free_y",switch = "y")+
  theme(strip.text.y.left = element_text(angle = 0,hjust=1),
        axis.text.y=element_blank(),panel.spacing = unit(0, "lines"),axis.ticks.y=element_blank(),
        panel.grid.major.y=element_blank(),panel.grid.minor.y=element_blank())+
  xlab("SD difference in outcome in offspring of smokers vs non-smokers")+ylab("")



