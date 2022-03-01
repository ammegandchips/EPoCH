
require(ggplot2)
require(dplyr)
require(gridExtra)
require(stringr)

make_plot <- function(res,linker,binary,cropforleft=NULL,cropforright=NULL,xtitle){
  if(class(res)=="list"){
    res <- lapply(res,function(x){
      y<-x[x$exposure_linker==linker,]
      y <- y[-which(y$outcome_class %in% c("negative control outcomes","perinatal survival")),]
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
    res <- res[-which(res$outcome_class %in% c("negative control outcomes","perinatal survival")),]
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
    geom_point(aes(x=est_ALSPAC,y=1,fill="#ef5675"),alpha=0.5,shape=22,size=3,colour="grey90")+
    geom_point(aes(x=est_BIB,y=1,fill="#7a5195"),alpha=0.5,shape=22,size=3,colour="grey90")+
    geom_point(aes(x=est_MCS,y=1,fill="#003f5c"),alpha=0.5,shape=22,size=3,colour="grey90")+
    geom_point(aes(x=est_MOBA,y=1,fill="#ffa600"),alpha=0.5,shape=22,size=3,colour="grey90")+
#    geom_point(aes(x=est,y=1,colour=p<0.05),shape=18,alpha=0.9,size=3)+
#    geom_errorbarh(aes(y=1,xmin=lci,xmax=uci,height=0,colour=p<0.05))+
    geom_point(aes(x=est,y=1),shape=18,alpha=0.9,size=3,colour="grey36")+
    geom_errorbarh(aes(y=1,xmin=lci,xmax=uci),height=0,colour="grey36")+
    scale_fill_identity(name = "Cohort estimates:",
                         breaks = c("#ffa600","#003f5c", "#7a5195", "#ef5675"),
                         labels = c("MOBA","MCS", "BiB","ALSPAC"),
                         guide = "legend")+
#    scale_colour_manual(name="Meta-analysis estimate:",
#                        breaks = c("TRUE","FALSE"),
#                        labels= c("P<0.05","P<0.05"),
#                        values= c("firebrick1","black"),
#                        guide="legend")+
    facet_grid(outcome_class+outcome_text~model,scales = "free",space = "free_y",switch = "y") +
    xlab(xtitle)+ylab("") +
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
    ggtitle("Binary outcomes")+
    coord_trans(x = 'log10')
  }else{
    phewas_plot <- phewas_plot +
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

RESa <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_model2a_extracted.RDS")
RESb <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_model2b_extracted.RDS")
RESc <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_model2c_extracted.RDS")

res <- list(RESa,RESb,RESc)

res <- lapply(res,function(x){
  x$outcome_linker[grep(x$outcome_linker,pattern="age 1-2")] <- str_replace(x$outcome_linker[grep(x$outcome_linker,pattern="age 1-2")],pattern="age 1-2","age 1 to 2")
  x$outcome_linker[grep(x$outcome_linker,pattern="age 3-4")] <- str_replace(x$outcome_linker[grep(x$outcome_linker,pattern="age 3-4")],pattern="age 3-4","age 3 to 4")
  x$outcome_linker[grep(x$outcome_linker,pattern="age 5-7")] <- str_replace(x$outcome_linker[grep(x$outcome_linker,pattern="age 5-7")],pattern="age 5-7","age 5 to 7")
  x$outcome_linker[grep(x$outcome_linker,pattern="age 8-11")] <- str_replace(x$outcome_linker[grep(x$outcome_linker,pattern="age 8-11")],pattern="age 8-11","age 8 to 11")
  x
})
  
linker <- "smoking-basic-ever in pregnancy-father-binary-self-reported or measured NA"
xtitle_bin <- "Odds ratio for outcome in children of paternal smokers vs non-smokers"
xtitle_cont <- "SD difference in outcome in children of paternal smokers vs non-smokers"
binary_plot <- make_plot(res,linker,binary=TRUE,cropforleft=FALSE,cropforright=FALSE,xtitle=xtitle_bin)
continuous_plot <- make_plot(res,linker,binary=FALSE,cropforleft=FALSE,cropforright=FALSE,xtitle=xtitle_cont)

ggsave("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/phewas_model2_binary.jpeg",
       plot = binary_plot,
       width=35,height=35,units=c("cm"),dpi=300)

ggsave("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/phewas_model2_continuous.jpeg",
       plot = continuous_plot,
       width=35,height=35,units=c("cm"),dpi=300)

