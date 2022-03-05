Describe maternal and paternal behaviours throughout pregnancy (how change, how correlated - with other behaviours, same behaviour in other parent, and with confounders)
Explore confounding structures
Assoc with SEP, age, parity
Correlations in different cohorts
R2 for PRS at different points during pregnancy - change in R2 throughout pregnancy

# ALSPAC

dat <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds")

vars<-
  c(
    
    "physact_mother_secondtrim_ordinal",
    "physact_mother_thirdtrim_ordinal",
    "physact_father_secondtrim_ordinal",
    #  "physact_mother_postnatal_ordinal", (not included as not directly comparable)
    
    "caffeine_mother_total_firsttrim_ordinal",
    "caffeine_mother_total_secondtrim_ordinal",
    "caffeine_mother_total_thirdtrim_ordinal",
    "caffeine_mother_total_postnatal_ordinal",
    "caffeine_father_total_secondtrim_ordinal",
    
    "smoking_mother_preconception_ordinal",
    "smoking_mother_firsttrim_ordinal",
    "smoking_mother_secondtrim_ordinal",
    "smoking_mother_thirdtrim_ordinal",
    "smoking_mother_postnatal_ordinal",
    
    "smoking_father_startpregnancy_ordinal",
    "smoking_father_secondtrim_ordinal",
    "smoking_father_thirdtrim_ordinal",
    "smoking_father_postnatal_ordinal",
    
    "alcohol_mother_preconception_ordinal",
    "alcohol_mother_firsttrim_ordinal",
    "alcohol_mother_secondtrim_ordinal",
    "alcohol_mother_thirdtrim_ordinal",
    "alcohol_mother_postnatal_ordinal",
    
    "alcohol_father_preconception_ordinal",
    "alcohol_father_secondtrim_ordinal",
    "alcohol_father_thirdtrim_ordinal",
    "alcohol_father_postnatal_ordinal",
    
    "covs_occup_mother",
    "covs_occup_father",
    
    "covs_edu_mother",
    "covs_edu_father",
    
    "covs_occup_mother_highestlowest_binary",
    "covs_occup_father_highestlowest_binary",
    "covs_edu_mother_highestlowest_binary",
    "covs_edu_father_highestlowest_binary",
    
    "covs_parity_mother_binary",
    "covs_partner_lives_with_mother_prenatal"
    
    
  )

require(dplyr)
require(corrplot)
df1<-mutate_all(dat[,vars], function(x) as.numeric(x))
cors <- cor(df1[,vars[-((length(vars)-5):length(vars))]],use="pairwise.complete")
corrplot(cors,tl.cex=0.5,method="color",tl.col="black",order="hclust",addrect=5)

require(reshape2)
df1<-mutate_all(dat[,c("aln",vars)], function(x) as.numeric(x))
df1_melt <- melt(df1[,grepl("aln|smoking|physact|caff|alco",names(df1))],id.vars = "aln")

df1_melt$time <- NA
df1_melt$time[grepl(df1_melt$variable,pattern="preconception")]<-"pre-conception"
df1_melt$time[grepl(df1_melt$variable,pattern="firsttrim|start")]<-"first trimester"
df1_melt$time[grepl(df1_melt$variable,pattern="secondtrim")]<-"second trimester"
df1_melt$time[grepl(df1_melt$variable,pattern="thirdtrim")]<-"third trimester"
df1_melt$time[grepl(df1_melt$variable,pattern="postnatal")]<-"postnatal"
df1_melt$time <- factor(df1_melt$time,ordered=T, levels=c("pre-conception","first trimester","second trimester","third trimester","postnatal"))

df1_melt$behaviour <- NA
df1_melt$behaviour[grepl(df1_melt$variable,pattern="caff")]<-"caffeine"
df1_melt$behaviour[grepl(df1_melt$variable,pattern="alcohol")]<-"alcohol"
df1_melt$behaviour[grepl(df1_melt$variable,pattern="smoking")]<-"smoking"
df1_melt$behaviour[grepl(df1_melt$variable,pattern="physac")]<-"physical activity"
df1_melt$behaviour <- factor(df1_melt$behaviour,ordered=T, levels=c("smoking","alcohol","caffeine","physical activity"))

df1_melt$parent <- NA
df1_melt$parent[grepl(df1_melt$variable,pattern="mother")]<-"mother"
df1_melt$parent[grepl(df1_melt$variable,pattern="father")]<-"partner"

x <- droplevels(df1_melt[order(df1_melt$aln,df1_melt$time,df1_melt$parent,df1_melt$behaviour),])
x<-x[is.na(x$value)==F,]
x <- x[duplicated(x[,c("parent","behaviour","aln")])==F,]

names(x)[3]<-"initial_dose"
names(x)[2]<-"initial_var"

dfx <- merge(x[,c("aln","parent","behaviour","initial_dose","initial_var")],df1_melt,by=c("aln","parent","behaviour"),all=T)

dfy <- 
  dfx %>%
  group_by(factor(initial_dose),factor(behaviour),factor(time),factor(parent)) %>%
  dplyr::summarise(mean=mean(value,na.rm=T),sd=sd(value,na.rm=T),n=n())

ggthemr::ggthemr("light",layout = "minimal",type = "outer")
require(ggplot2)
ggplot(dfy,aes(x=`factor(time)`,y=mean,group=`factor(initial_dose)`))+
  geom_point(aes(colour=`factor(initial_dose)`,size=n))+
  geom_path(aes(colour=`factor(initial_dose)`))+
  #  geom_smooth(aes(colour=`factor(initial_dose)`),method="loess" )+
  facet_grid(`factor(behaviour)`~`factor(parent)`)+
  theme(axis.text.x=element_text(angle=45,hjust=1),panel.spacing.y = unit(1,"lines"))+
  xlab("")+ylab("mean level of behaviour")


#correlation if live together vs don't

require(reshape2)
cors_lt <- cor(df1[df1$covs_partner_lives_with_mother_prenatal==1,vars[-((length(vars)-5):length(vars))]],use="pairwise.complete")
cors_nlt <- cor(df1[df1$covs_partner_lives_with_mother_prenatal==0,vars[-((length(vars)-5):length(vars))]],use="pairwise.complete")
cors_melt_lt <- melt(cors_lt)
cors_melt_lt$live_together <-"parents live together"
cors_melt_nlt <- melt(cors_nlt)
cors_melt_nlt$live_together <-"parents live apart"

cors_melt <- bind_rows(cors_melt_lt,cors_melt_nlt)

ggplot(cors_melt[grepl("smoking|alcohol|physact|caffeine",cors_melt$Var1)&grepl("smoking|alcohol|physact|caffeine",cors_melt$Var2),],aes(x=Var1,y=Var2,fill=value,label=round(value,2)))+
  geom_tile()+
  #  geom_text(colour="white")+
  theme(axis.text.x = element_text(angle = 45,hjust=1))+
  scale_fill_gradient(low="white",high="darkblue")+
  facet_grid(.~live_together)

df7 <- cors_melt[grepl("smoking|alcohol|physact|caffeine",cors_melt$Var1)&grepl("smoking|alcohol|physact|caffeine",cors_melt$Var2),]

df7$time1 <- NA
df7$time1[grepl(df7$Var1,pattern="preconception")]<-"pre-conception"
df7$time1[grepl(df7$Var1,pattern="firsttrim|start")]<-"first trimester"
df7$time1[grepl(df7$Var1,pattern="secondtrim")]<-"second trimester"
df7$time1[grepl(df7$Var1,pattern="thirdtrim")]<-"third trimester"
df7$time1[grepl(df7$Var1,pattern="postnatal")]<-"postnatal"

df7$time2 <- NA
df7$time2[grepl(df7$Var2,pattern="preconception")]<-"pre-conception"
df7$time2[grepl(df7$Var2,pattern="firsttrim|start")]<-"first trimester"
df7$time2[grepl(df7$Var2,pattern="secondtrim")]<-"second trimester"
df7$time2[grepl(df7$Var2,pattern="thirdtrim")]<-"third trimester"
df7$time2[grepl(df7$Var2,pattern="postnatal")]<-"postnatal"
df7$sametime <- ifelse(df7$time1==df7$time2,"yes","no")

df7$behaviour1 <- unlist(lapply(strsplit(as.character(df7$Var1),split="_"),"[[",1))
df7$behaviour2 <- unlist(lapply(strsplit(as.character(df7$Var2),split="_"),"[[",1))
df7$samebehaviour <- ifelse(df7$behaviour1==df7$behaviour2,"yes","no")

df7$parent1 <- ifelse(grepl("mother",df7$Var1),"mother","partner")
df7$parent2 <- ifelse(grepl("mother",df7$Var2),"mother","partner")
df7$sameparent <- ifelse(df7$parent1==df7$parent2,"yes","no")

df8 <- df7[df7$sameparent=="no"&df7$samebehaviour=="yes"&df7$sametime=="yes",]
df8$time1 <- factor(df8$time1,ordered=T, levels=c("pre-conception","first trimester","second trimester","third trimester","postnatal"))

ggplot(df8,aes(x=1,y=value,fill=live_together))+
  geom_col(position = "dodge")+
  facet_grid(behaviour1~time1)


