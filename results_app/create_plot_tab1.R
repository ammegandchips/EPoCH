create_plot_tab1 <- function(plot_data_tab1,xmin_numeric_tab1,xmax_numeric_tab1,xmin_binary_tab1,xmax_binary_tab1){
  ggthemr('flat',layout = "clean")
  darken_swatch(0.3)
  if("binary" %in% plot_data_tab1$outcome_type){
    
    plot_tab1.binary <- ggplot(plot_data_tab1[plot_data_tab1$outcome_type=="binary",],
                               aes(x=exp(est),y=outcome_term,xmin=exp(ci.l),xmax=exp(ci.u),shape=mutual_adjustment,colour=p<0.05))+
      geom_pointrangeh(position=position_dodgev(1))+
      geom_point(size = 2,fill="white",position=position_dodgev(1))+
      geom_vline(xintercept=1,size = .25, linetype = "dashed")+
      xlab("Odds ratio")+
      ylab("")+
      scale_shape_manual(values=c(22,15))+
      guides(colour=FALSE)+
      facet_grid(outcome_term~person_exposed,space = "free",scales="free_y")+
      scale_x_log10(breaks = c(0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10),minor_breaks = NULL)
 #     if(grepl("prs",plot_data_tab1$exposure[1])==FALSE){
        plot_tab1.binary <-  plot_tab1.binary + coord_cartesian(xlim = c(as.numeric(xmin_binary_tab1),as.numeric(xmax_binary_tab1)))
  #    }
    plot_tab1.binary <- plot_tab1.binary + theme(panel.spacing.x = unit(0.1, "lines"),panel.spacing.y = unit(0.1, "lines"),
            legend.title=element_blank(),legend.position="bottom",strip.background.y = element_blank(),
            strip.text.y = element_blank(),plot.title = element_text(hjust = 0.5))
  }
  
  if("numerical" %in% plot_data_tab1$outcome_type){
    plot_tab1.numerical <- ggplot(plot_data_tab1[plot_data_tab1$outcome_type=="numerical",],
                                  aes(x=est,y=outcome_term,xmin=ci.l,xmax=ci.u,shape=mutual_adjustment,colour=p<0.05))+
      geom_pointrangeh(position=position_dodgev(1))+
      geom_point(size = 2,fill="white",position=position_dodgev(1))+
      geom_vline(xintercept=0,size = .25, linetype = "dashed")+
      xlab("Difference in sd of outcome per sd or group of exposure")+
      ylab("")+
      scale_shape_manual(values=c(22,15))+
      guides(colour=FALSE)+
      facet_grid(outcome_term~person_exposed,space = "free",scales="free_y")+
      coord_cartesian(xlim = c(as.numeric(xmin_numeric_tab1),as.numeric(xmax_numeric_tab1)))+
      theme(panel.spacing.x = unit(0.1, "lines"),panel.spacing.y = unit(0.1, "lines"),
            legend.title=element_blank(),legend.position="bottom",strip.background.y = element_blank(),
            strip.text.y = element_blank(),plot.title = element_text(hjust = 0.5))
  }
  
  if("binary" %in% plot_data_tab1$outcome_type & "numerical" %in% plot_data_tab1$outcome_type){
    plot_tab1 <- ggarrange(plot_tab1.numerical,plot_tab1.binary,
                           heights=c(length(unique(plot_data_tab1[plot_data_tab1$outcome_type=="numerical","outcome"]))*25,
                                     length(unique(plot_data_tab1[plot_data_tab1$outcome_type=="binary","outcome"]))*25))
  }else{
    if("binary" %in% plot_data_tab1$outcome_type){
      plot_tab1 <- plot_tab1.binary                  
    }else{
      plot_tab1 <- plot_tab1.numerical    
    }                
  }
  list(plot_data_tab1,plot_tab1)
  
}
