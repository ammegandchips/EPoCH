# Missing paternal data simulations

# variable parameters: 
  # correlation between mum and dad's health behaviour (parentcor)
  # correlation with offspring outcome (childcor)
  # proportion "exposed" for mums (mpropexp)
  # proportion "exposed" for dads (dpropexp)
  # % of paternal samples missing (dmiss)
  # maternal percentile of continuous variable below which to sample dads (so we can oversample for "healthier" couples) (mperc)
  # number of simulations to perform (nSim)
  # sample size of each simulation (n)

#load necessary packages (ggthemr is just for aesthetics)

library(MASS)
library(ggplot2)
library(reshape)
library(ggthemr)

#create functions to run simulations and plot results

sim.function <- function(parentcor,childcor,mpropexp,dpropexp,dmiss,mperc,n){
  # create random skewed (because of healthy participant bias) correlated continuous variables for parents' "health behaviour" and offspring outcome.
dat = try(as.data.frame(mvrnorm(n=n, mu=c(0, 0,0), Sigma=matrix(c(1, parentcor, childcor,parentcor, 1,childcor,childcor,childcor,1), nrow=3), empirical=TRUE)),silent=T)
if(class(dat)=="try-error"){
  res <- rep(NA,16)
}else{
dat <- dat+10
dat <- log(dat,100)
colnames(dat)<-c("mothers","fathers","outcome")
# dichotomise the variable (so that it's more like smoking). Cut offs for exposed/unexposed different in dads and mums to represent different proportions of exposure seen in ALSPAC
dat$fathers_binary <- NA
dat$fathers_binary[dat$fathers<=quantile(dat$fathers,dpropexp)]<-1
dat$fathers_binary[dat$fathers>quantile(dat$fathers,dpropexp)]<-0
dat$mothers_binary <- NA
dat$mothers_binary[dat$mothers<=quantile(dat$mothers,mpropexp)]<-1
dat$mothers_binary[dat$mothers>quantile(dat$mothers,mpropexp)]<-0
# set a random sample of dads' data to missing, depending on the proportion missing (dmiss). Missing dads are oversampled for less "healthy" mums (mums with a health score < mperc)
if(dmiss!=0){
dat$fathers_binary[dat$mothers<quantile(dat$mothers,mperc)][sample(n*mperc, n*dmiss)]<- NA
}
# turn the offspring outcome variable into z scores
dat$outcome <- scale(dat$outcome)
# run linear regression for maternal, paternal and mutually adjusted effects
mat_res <-try(summary(lm(outcome~mothers_binary,data=dat))$coef[2,],silent=T)
matpat_res <-try(summary(lm(outcome~mothers_binary+fathers_binary,data=dat))$coef[2,],silent=T)
pat_res <- try(summary(lm(outcome~fathers_binary,data=dat))$coef[2,],silent=T)
patmat_res <-try(summary(lm(outcome~fathers_binary+mothers_binary,data=dat))$coef[2,],silent=T)
if(class(mat_res)=="try-error"|class(pat_res)=="try-error"){
  res <- as.numeric(rep(NA,16))
}else{
res <- as.numeric(c(mat_res,pat_res,matpat_res,patmat_res))
# calculate the correlation coefficients with binary variables and add to results
res <- c(res,cor(dat$mothers_binary,dat$fathers_binary,use="complete.obs"),
         cor(dat$mothers_binary,dat$outcome,use="complete.obs"),
         cor(dat$fathers_binary,dat$outcome,use="complete.obs"))
}}
# prepare results
res <- c(paste0("parentcor=",parentcor,
               " childcor=",childcor,
               " mpropexp=", mpropexp,
               " dpropexp=", dpropexp,
               " dmiss=", dmiss,
               " mperc=",mperc,
               " n=",n),res)
names(res)<-c("parameters",
              "est.m","se.m","t.m","p.m",
              "est.p","se.p","t.p","p.p",
              "est.mp","se.mp","t.mp","p.mp",
              "est.pm","se.pm","t.pm","p.pm",
              "cor.mp","cor.mo","cor.po"
              )
res
}

draw_sim_plot <- function(res,xlimits,plottitle){
df<-data.frame(estimates=c(res$est.m,res$est.p,res$est.mp,res$est.pm),exposed=c(rep("mother",nrow(res)),rep("father",nrow(res)),rep("mother",nrow(res)),rep("father",nrow(res))),adjustment=c(rep("A. not mutually adjusted",nrow(res)*2),rep("B. mutually adjusted",nrow(res)*2)))
p<-ggplot(df)+geom_histogram(aes(estimates,fill=exposed),position="identity",colour="grey40",alpha=0.5)+

  xlim(xlimits)+
  facet_grid(.~adjustment)+
  ylab("Count") +xlab("Regression coefficients")+ labs(title=plottitle)+ theme(panel.grid.minor = element_blank(),panel.grid.major = element_blank())
p
}

#specify number of simulations to perform
nSim <- 2000

# Run function to generate simulated data and run regression (parentcor and childcor are > they are in ALSPAC (where they are 0.45 and -0.16, respectively) because they are used to generate the continuous "health behaviour" variable before being dicohotomised. These values have been chosen because they seem to mean the correct correlations occur when using the binary variables. Can be checked by looking at final columns of results.)

# all dads
res_0dmiss <- replicate(nSim,expr=sim.function(parentcor=0.7,childcor=0.2,mpropexp = 0.31,dpropexp = 0.48,dmiss=0,mperc=0.8,n=15000),simplify = FALSE)
res_0dmiss <- as.data.frame(do.call(rbind,res_0dmiss))
res_0dmiss[,-1] <- apply(res_0dmiss[,-1],2,function(x) as.numeric(as.character(x)))

# 25% missing (oversampled from bottom 80% of maternal scores)
res_0.25dmiss <- replicate(nSim,expr=sim.function(parentcor=0.7,childcor=0.2,mpropexp = 0.31,dpropexp = 0.48,dmiss=0.25,mperc=0.8,n=15000),simplify = FALSE)
res_0.25dmiss <- as.data.frame(do.call(rbind,res_0.25dmiss))
res_0.25dmiss[,-1] <- apply(res_0.25dmiss[,-1],2,function(x) as.numeric(as.character(x)))

# 75% missing (oversampled from bottom 80% of maternal scores)
res_0.75dmiss <- replicate(nSim,expr=sim.function(parentcor=0.7,childcor=0.2,mpropexp = 0.31,dpropexp = 0.48,dmiss=0.75,mperc=0.8,n=15000),simplify = FALSE)
res_0.75dmiss <- as.data.frame(do.call(rbind,res_0.75dmiss))
res_0.75dmiss[,-1] <- apply(res_0.75dmiss[,-1],2,function(x) as.numeric(as.character(x)))

# Plot results

ggthemr("light")
draw_sim_plot(res_0dmiss,xlimits=c(-0.6,0),plottitle = "No fathers missing")
draw_sim_plot(res_0.25dmiss,xlimits=c(-0.6,0),plottitle =  "25% fathers missing")
draw_sim_plot(res_0.75dmiss,xlimits=c(-0.6,0),plottitle = "75% fathers missing")