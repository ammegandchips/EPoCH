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

ggthemr(palette="solarized",layout = "minimal", type="outer")

df <- dat[dat$regression_term=="smoking_father_firsttrim_ordinalHeavy",]

pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-0.05))]-1
adj_pthreshold <- 0.05/nrow(df)
adj_pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-adj_pthreshold))]-1

p <- ggplot(df,
            aes(Estimate=est,P=p,Outcome=outcome_term,Cohorts=cohorts,N=total_n,
                x=est_SDM,y=rank(-log10(p)),
           #     x=rank(est_scaled),y=rank(-log10(p)),
                xmin=est_SDM-(1.96*se_SDM),
                xmax=est_SDM+(1.96*se_SDM)
                ))+
  geom_pointrange(aes(colour=outcome_class))+
  geom_vline(xintercept = 0,linetype="dashed",colour="grey40")+
  geom_hline(yintercept = pthreshold_rank,linetype="dashed",colour="grey40")+
  geom_hline(yintercept = adj_pthreshold_rank,linetype="dashed",colour="grey40")+
  coord_cartesian(xlim=c(-1,1))

ggplotly(p,tooltip=c("P","Estimate","Outcome","Cohorts","N"))

