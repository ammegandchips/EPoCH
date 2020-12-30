create_plot_tab1 <- function(plot_data_tab1,xmin_numeric_tab1,xmax_numeric_tab1,xmin_binary_tab1,xmax_binary_tab1){
  ggthemr('flat',layout = "clean")
  darken_swatch(0.3)
  plot_data_tab1$p_threshold <- as.character(cut(plot_data_tab1$p,c(0,0.05,Inf),labels=c("P<0.05","P>0.05")))
  if("binary" %in% plot_data_tab1$outcome_type){
    
    plot_tab1.binary <- ggplot(plot_data_tab1[plot_data_tab1$outcome_type=="binary",],
                               aes(x=exp(est),y=outcome_term,xmin=exp(ci.l),xmax=exp(ci.u),colour=p_threshold,shape=mutual_adjustment))+
      geom_errorbarh(height=0,position=position_dodgev(.5))+
      geom_point(size = 2,fill="white",position=position_dodgev(.5))+
      geom_vline(xintercept=1,size = .25, linetype = "dashed")+
      xlab("Odds ratio")+
      ylab("")+
      scale_shape_manual(values=c(22,15))+
      scale_x_log10(breaks = c(0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10),minor_breaks = NULL)+
      ggtitle("Binary outcomes")+
    theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))
  }
  
  if("numerical" %in% plot_data_tab1$outcome_type){
    plot_tab1.numerical <- ggplot(plot_data_tab1[plot_data_tab1$outcome_type=="numerical",],
                                  aes(x=est,y=outcome_term,xmin=ci.l,xmax=ci.u,shape=mutual_adjustment,colour=p_threshold))+
      geom_errorbarh(height=0,position=position_dodgev(.5))+
      geom_point(size = 2,fill="white",position=position_dodgev(.5))+
      geom_vline(xintercept=0,size = .25, linetype = "dashed")+
      xlab("Difference in sd of outcome per sd or group of exposure")+
      ylab("")+
      scale_shape_manual(values=c(22,15))+
      ggtitle("Continuous outcomes")+
      theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))
  }
  
  if("binary" %in% plot_data_tab1$outcome_type & "numerical" %in% plot_data_tab1$outcome_type){
    plot_tab1 <- list(ggplotly(plot_tab1.numerical),ggplotly(plot_tab1.binary))
  }else{
    if("binary" %in% plot_data_tab1$outcome_type){
      plot_tab1 <- ggplotly(plot_tab1.binary)                 
    }else{
      plot_tab1 <- ggplotly(plot_tab1.numerical)   
    }                
  }
  list(plot_data_tab1,plot_tab1)
  
}
