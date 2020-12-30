create_plot_tab1_numeric <- function(plot_data_tab1){
  ggthemr('flat',layout = "clean")
  darken_swatch(0.3)
  plot_data_tab1$p_threshold <- as.character(cut(plot_data_tab1$p,c(0,0.05,Inf),labels=c("P<0.05","P>0.05")))
  plot_data_tab1.numerical <- plot_data_tab1[plot_data_tab1$outcome_type=="numerical",]
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

    plot_tab1.numerical <- ggplotly(plot_tab1.numerical,
                                    height=125+(length(unique(plot_data_tab1.numerical$outcome))*25))
    
  list(plot_data_tab1.numerical,plot_tab1.numerical)
}
