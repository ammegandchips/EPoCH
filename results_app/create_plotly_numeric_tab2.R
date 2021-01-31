create_plot_tab2_numeric <- function(plot_data_tab2){
  ggthemr('flat',layout = "clean")
  darken_swatch(0.3)
  plot_data_tab2$p_threshold <- as.character(cut(plot_data_tab2$p,c(0,0.05,Inf),labels=c("P<0.05","P>0.05")))
  plot_data_tab2.numeric <- plot_data_tab2[plot_data_tab2$exposure_type=="numerical",]
  
  plot_tab2.numeric <- ggplot(plot_data_tab2[plot_data_tab2$exposure_type=="numerical",],
                             aes(x=exp(est),y=exposure_term,xmin=exp(ci.l),xmax=exp(ci.u),colour=p_threshold,shape=mutual_adjustment,p=p,n=total_n,participatingcohorts=cohorts))+
    geom_errorbarh(height=0,position=position_dodgev(.5))+
    geom_point(size = 2,fill="white",position=position_dodgev(.5))+
    geom_vline(xintercept=1,size = .25, linetype = "dashed")+
    ylab("")+
    scale_shape_manual(values=c(22,15))+
    ggtitle("Numeric exposures")+
    theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))
  if("binary" %in% plot_data_tab2$outcome_type){
    plot_tab2.numeric <-   plot_tab2.numeric +
      xlab("Odds ratio")+
      scale_x_log10()
  }else{
    plot_tab2.numeric <-   plot_tab2.numeric +
      xlab("Mean difference")
  }
  
  plot_tab2.numeric <- ggplotly(plot_tab2.numeric, tooltip = c("x","exposure_term","p","total_n","participatingcohorts"),
                               height=125+(length(unique(plot_data_tab2.numeric$exposure))*25))
  
  list(plot_data_tab2.numeric,plot_tab2.numeric)
}