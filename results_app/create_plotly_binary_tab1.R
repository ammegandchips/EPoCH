create_plot_tab1_binary <- function(plot_data_tab1){
  ggthemr('flat',layout = "clean")
  darken_swatch(0.3)
  plot_data_tab1$p_threshold <- as.character(cut(plot_data_tab1$p,c(0,0.05,Inf),labels=c("P<0.05","P>0.05")))
  plot_data_tab1.binary <- plot_data_tab1[plot_data_tab1$outcome_type=="binary",]

    plot_tab1.binary <- ggplot(plot_data_tab1[plot_data_tab1$outcome_type=="binary",],
                               aes(x=exp(est),y=outcome_term,xmin=exp(ci.l),xmax=exp(ci.u),colour=p_threshold,shape=mutual_adjustment,p=p,n=total_n,participatingcohorts=cohorts))+
      geom_errorbarh(height=0,position=position_dodgev(.5))+
      geom_point(size = 2,fill="white",position=position_dodgev(.5))+
      geom_vline(xintercept=1,size = .25, linetype = "dashed")+
      xlab("Odds ratio")+
      ylab("")+
      scale_shape_manual(values=c(22,15))+
      scale_x_log10()+
      ggtitle("Binary outcomes")+
    theme(legend.title=element_blank(),legend.position="bottom",plot.title = element_text(hjust = 0.5))

    plot_tab1.binary <- ggplotly(plot_tab1.binary,tooltip = c("x","exposure_term","p","total_n","participatingcohorts"),
                                 height=125+(length(unique(plot_data_tab1.binary$outcome))*25))
    
  list(plot_data_tab1.binary,plot_tab1.binary)
}