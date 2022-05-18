require(ggplot2)
require(ggthemr)
require(plotly)


# to convert ln(OR) to cohen's d (SDM), multiply ln(OR) by sqrt(3)/pi (which is 0.5513)
# to convert SDM to ln(OR), multiply SDM by pi/sqrt(3) (which is 1.814)
# https://www.meta-analysis.com/downloads/Meta-analysis%20Converting%20among%20effect%20sizes.pdf
# https://onlinelibrary.wiley.com/doi/abs/10.1002/1097-0258(20001130)19:22%3C3127::AID-SIM784%3E3.0.CO;2-M

dat$est_SDM <- dat$est
dat$est_SDM[dat$outcome_type=="binary"|dat$outcome_type=="ordinal"]<-dat$est[dat$outcome_type=="binary"|dat$outcome_type=="ordinal"]*0.5513

dat$se_SDM <- dat$se
dat$se_SDM[dat$outcome_type=="binary"|dat$outcome_type=="ordinal"]<-dat$se[dat$outcome_type=="binary"|dat$outcome_type=="ordinal"]*0.5513

#ggthemr(palette="solarized",layout = "minimal", type="outer")

# VOLCANO

df <- dat[dat$exposure_linker=="smoking-basic-ever in pregnancy-mother-binary-self-reported or measured NA"|
            dat$exposure_linker=="smoking-basic-ever in pregnancy-father-binary-self-reported or measured NA",]

pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-0.05))]-1
adj_pthreshold <- 0.05/nrow(df)
adj_pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-adj_pthreshold))]-1

#ggthemr_reset()

Plot <- ggplot(df,
            aes(Estimate=est,P=p,Outcome=outcome_linker,Cohorts=cohorts,N=total_n,
                x=est_SDM,y=rank(-log10(p))
                ))+
 geom_point(aes(colour=outcome_class))+
  geom_vline(xintercept = 0,linetype="dashed",colour="grey40")+
  geom_ribbon(aes(ymin=pthreshold_rank,ymax=adj_pthreshold_rank),alpha=0.2,fill="red")+
  geom_ribbon(aes(ymin=adj_pthreshold_rank,ymax=max(p)),alpha=0.2,fill="blue")+
  facet_grid(.~person_exposed)+
#  geom_hline(yintercept = pthreshold_rank,linetype="dashed",colour="grey40")+
#  geom_hline(yintercept = adj_pthreshold_rank,linetype="dashed",colour="grey40")+
  coord_cartesian(xlim=c(-0.75,0.75))

ggplotly(Plot,tooltip=c("P","Estimate","Outcome","Cohorts","N"))



# MANHATTAN


create_manhattan_dfs <- function(exposureclass){
df <- dat[dat$exposure_class==exposureclass&dat$person_exposed!="child",]
df$exposure_dose_ordered <- factor(df$exposure_dose,ordered=T,levels=c("light","moderate","heavy"))
df <- df[order(df$exposure_subclass,df$exposure_time,df$exposure_dose_ordered),]
df$exposure_subclass_time_dose <- paste(df$exposure_subclass,df$exposure_time,df$exposure_dose)
df$exposure_subclass_time_dose<-factor(df$exposure_subclass_time_dose,ordered=T,levels=unique(df$exposure_subclass_time_dose))
df
}

smoking <- create_manhattan_dfs("smoking")
alc <- create_manhattan_dfs("alcohol consumption")
caf <- create_manhattan_dfs("caffeine consumption")
sep <- create_manhattan_dfs("socioeconomic position")



create_manhattan_plot <- function(df){
adj_pthreshold <- 0.05/nrow(df)
p <- ggplot(df,
            aes(Estimate=est,P=p,Outcome=outcome_linker,Cohorts=cohorts,N=total_n,
                x=exposure_subclass_time_dose,y=-log10(p)
            ))+
  geom_jitter(aes(colour=outcome_class),alpha=0.5)+
  facet_grid(person_exposed~.)+
  xlab("")+
  theme_classic()+
  scale_colour_brewer(palette = "Dark2")+
  theme(axis.text.x = element_text(angle = 90,hjust=1))+
  geom_hline(yintercept = -log10(adj_pthreshold),linetype="dashed",colour="grey40")
p
}

smoking_p <- create_manhattan_plot(smoking)
alc_p <- create_manhattan_plot(alc)
caf_p <- create_manhattan_plot(caf)
sep_p <- create_manhattan_plot(sep)



