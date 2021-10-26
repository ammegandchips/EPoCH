
require(ggplot2)
require(dplyr)
require(gridExtra)

make_plot <- function(res,linker,binary,cropforleft=NULL,cropforright=NULL){
  if(class(res)=="list"){
    res <- lapply(res,function(x){
      y<-x[x$exposure_linker==linker,]
      y <- y[-which(y$outcome_class %in% c("negative control outcomes","perinatal survival outcomes")),]
      y <- y[-grep(y$outcome_linker,pattern="reactive|interleukin|skills|readiness"),]
      if(binary==TRUE){
        y <- y[y$outcome_type=="binary",]
      }else{
        y <- y[y$outcome_type=="numerical",]
      }
        y
      })
    res <- bind_rows(res)
  }else{
    res <- res[res$exposure_linker==linker,]
    res <- res[-which(res$outcome_class %in% c("negative control outcomes","perinatal survival outcomes")),]
    res <- res[-grep(res$outcome_linker,pattern="reactive|interleukin|skills|readiness"),]
    if(binary==TRUE){
      res <- res[res$outcome_type=="binary",]
    }else{
      res <- res[res$outcome_type=="numerical",]
    }
  }
  res$lci <- res$est - (1.96* res$se)
  res$uci <- res$est + (1.96*res$se)
  res <- res[order(res$model,res$outcome_class,res$outcome_type, res$est),]
  res$outcome_text <- unlist(lapply(strsplit(res$outcome_linker,split="-"),function(x) paste(x[3:4],collapse = " - ")))
  substr(res$outcome_text,1,1) <- toupper(substr(res$outcome_text,1,1))
  res$outcome_text <- factor(res$outcome_text,ordered=T,levels=unique(res$outcome_text))
  
  res$model <- paste0(toupper(substr(res$model,1,1)),substr(res$model,2,5)," ",substr(res$model,6,8))
  
  intercept_n <- 0
  if(binary==TRUE){
    res[,grep(colnames(res),pattern="est|uci|lci")] <- exp(res[,grep(colnames(res),pattern="est|uci|lci")])
    intercept_n <- 1
  }
  
  phewas_plot <- ggplot(res)+
    geom_vline(xintercept = intercept_n,colour="grey36")+
    geom_point(aes(x=est_ALSPAC,y=1,colour="tomato3"),alpha=0.5,shape=15,size=3)+
    geom_point(aes(x=est_BIB_ALL,y=1,colour="seagreen"),alpha=0.5,shape=15,size=3)+
    geom_point(aes(x=est_MCS,y=1,colour="cornflowerblue"),alpha=0.5,shape=15,size=3)+
    geom_point(aes(x=est,y=1,fill="black"),shape=23,alpha=0.9,colour="black")+
    geom_errorbarh(aes(y=1,xmin=lci,xmax=uci,height=0))+
    scale_color_identity(name = "Cohort estimates:",
                         breaks = c("cornflowerblue", "seagreen", "tomato3"),
                         labels = c("MCS", "BiB","ALSPAC"),
                         guide = "legend")+
    scale_fill_identity(name="Meta-analysis estimate:",
                        breaks = "black",
                        labels="",
                        guide="legend")+
    facet_grid(outcome_class+outcome_text~model,scales = "free",space = "free_y",switch = "y") +
    theme_minimal()+
    theme(strip.text.y.left = element_text(angle = 0,hjust=1,colour = "white",size=8),
          strip.text.x = element_text(colour = "white",size=10),
           axis.text.y=element_blank(),panel.spacing = unit(0.1, "lines"),
          axis.ticks.y=element_blank(),
           panel.grid=element_blank(),
          plot.title=element_text(hjust=0.5),
         panel.background = element_rect(fill="grey90",colour="white"),strip.background = element_rect(fill="grey36",colour = "white"))
  
  if(binary==TRUE){  
  phewas_plot <- phewas_plot + 
    xlab("OR for difference in outcome in children of smokers vs non-smokers")+ylab("") +
    ggtitle("Binary outcomes")+
    coord_trans(x = 'log10')
  }else{
    phewas_plot <- phewas_plot +
    xlab("SD difference in outcome in children of smokers vs non-smokers")+ylab("") +
    ggtitle("Continuous outcomes")
  }
  if(cropforleft==TRUE){
    phewas_plot <- phewas_plot +
    theme(plot.margin = margin(0.1, -4.5, 0.1, -8, "cm"))
  }
  if(cropforright==TRUE){
    phewas_plot <- phewas_plot +
      theme(plot.margin = margin(0.1, 0.1, 0.1, -7.3, "cm"))
  }
  
  phewas_plot
}

RESa <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
RESb <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")

res <- list(RESa,RESb)
linker <- "smoking-basic-ever in pregnancy-father-binary-self-reported or measured NA"

binary_plot <- make_plot(res,linker,binary=TRUE,cropforleft=FALSE,cropforright=FALSE)
continuous_plot <- make_plot(res,linker,binary=FALSE,cropforleft=FALSE,cropforright=FALSE)

ggsave("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/phewas_model2_binary.jpeg",
       plot = binary_plot,
       width=35,height=35,units=c("cm"),dpi=300)

ggsave("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/phewas_model2_continuous.jpeg",
       plot = continuous_plot,
       width=35,height=35,units=c("cm"),dpi=300)

