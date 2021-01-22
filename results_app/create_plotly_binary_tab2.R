create_plot_tab2_binary <- function(plot_data_tab2){
  ggthemr('flat',layout = "clean")
  darken_swatch(0.3)
  plot_data_tab2$p_threshold <- as.character(cut(plot_data_tab2$p,c(0,0.05,Inf),labels=c("P<0.05","P>0.05")))
  plot_data_tab2.binary <- plot_data_tab2[plot_data_tab2$exposure_type=="binary",]
  
  plot_tab2.binary <- ggplot(plot_data_tab2[plot_data_tab2$exposure_type=="binary",],
                             aes(x=exp(est),y=exposure_term,xmin=exp(ci.l),xmax=exp(ci.u),colour=p_threshold,shape=mutual_adjustment))+
    geom_errorbarh(height=0,position=position_dodgev(.5))+
    geom_point(size = 2,fill="white",position=position_dodgev(.5))+
    geom_vline(xintercept=1,size = .25, linetype = "dashed")+
    ylab("")+
    scale_shape_manual(values=c(22,15))+
    ggtitle("Binary exposures")+
    theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))
  if("binary" %in% plot_data_tab2$outcome_type){
    plot_tab2.binary <-   plot_tab2.binary +
    xlab("Odds ratio")+
      scale_x_log10()
  }else{
    plot_tab2.binary <-   plot_tab2.binary +
      xlab("Mean difference")
  }
  
  plot_tab2.binary <- ggplotly(plot_tab2.binary,
                               height=125+(length(unique(plot_data_tab2.binary$exposure))*25))
  
  list(plot_data_tab2.binary,plot_tab2.binary)
}