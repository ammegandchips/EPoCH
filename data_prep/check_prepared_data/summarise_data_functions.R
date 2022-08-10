#################################
## Functions to check the data ##
#################################

# categorical variables:

check.categorical.variables<-function(variables){
  list_of_variable_dataframes <- lapply(variables,function(x)dat[,c(x,"covs_sex")])
  list_of_variable_dataframes <- lapply(list_of_variable_dataframes,setNames,c("variable","covs_sex"))
  table.and.plot.function<-function(list.of.dfs,list.of.variables,i){
    df<-list.of.dfs[[i]]
    name.df <-list.of.variables[[i]]
    Plot <- ggplot(df,aes(x=factor(variable),fill=factor(covs_sex)))+
      geom_bar()+scale_fill_manual(values=c("lightseagreen","darksalmon"),na.value="grey")+theme_minimal()+ggtitle(name.df)+theme(legend.position="bottom",legend.title=element_blank(),axis.text.x = element_text(angle = 35, hjust = 1),axis.title=element_blank(),plot.title=element_text(hjust=0.5))
    Table <- tableGrob(table(df$variable,df$covs_sex),theme=ttheme_minimal(base_size=10))
    grid.arrange(Plot,Table,nrow=1,ncol=2,as.table=T)
  }
  lapply(1:length(variables),table.and.plot.function,list.of.dfs=list_of_variable_dataframes,list.of.variables=variables)
}

# continuous variables:

check.continuous.variables<-function(variables){
  list_of_variable_dataframes <- lapply(variables,function(x)dat[,c(x,"covs_sex")])
  list_of_variable_dataframes <- lapply(list_of_variable_dataframes,setNames,c("variable","covs_sex"))
  table.and.plot.function<-function(list.of.dfs,list.of.variables,i){
    df<-list.of.dfs[[i]]
    name.df <-list.of.variables[[i]]
    Plot <- ggplot(df,aes(x=variable,colour=factor(covs_sex)))+
      geom_histogram(fill="white",alpha=0.5,position="identity",bins=80)+scale_colour_manual(values=c("lightseagreen","darksalmon"),na.value="grey")+theme_classic()+ggtitle(name.df)+theme(legend.position="bottom",legend.title=element_blank(),axis.text.x = element_text(angle = 35, hjust = 1),axis.title=element_blank(),plot.title=element_text(hjust=0.5))
    Table <- data.frame(covs_sex =c("all","male","female"),
                        n = c(length(which(!is.na(df$variable))),length(which(!is.na(df$variable[df$covs_sex=="male"]))),length(which(!is.na(df$variable[df$covs_sex=="female"])))),
                        mean = c(mean(df$variable,na.rm=T),mean(df$variable[df$covs_sex=="male"],na.rm=T),mean(df$variable[df$covs_sex=="female"],na.rm=T)),
                        sd = c(sd(df$variable,na.rm=T),sd(df$variable[df$covs_sex=="male"],na.rm=T),sd(df$variable[df$covs_sex=="female"],na.rm=T)),
                        lower.iqr = c(quantile(df$variable,na.rm=T,prob=0.25),quantile(df$variable[df$covs_sex=="male"],na.rm=T,prob=0.25),quantile(df$variable[df$covs_sex=="female"],na.rm=T,prob=0.25)),
                        median = c(quantile(df$variable,na.rm=T,prob=0.5),quantile(df$variable[df$covs_sex=="male"],na.rm=T,prob=0.5),quantile(df$variable[df$covs_sex=="female"],na.rm=T,prob=0.5)),
                        upper.iqr = c(quantile(df$variable,na.rm=T,prob=0.75),quantile(df$variable[df$covs_sex=="male"],na.rm=T,prob=0.75),quantile(df$variable[df$covs_sex=="female"],na.rm=T,prob=0.75)),
                        min = c(min(df$variable,na.rm=T),min(df$variable[df$covs_sex=="male"],na.rm=T),min(df$variable[df$covs_sex=="female"],na.rm=T)),
                        max = c(max(df$variable,na.rm=T),max(df$variable[df$covs_sex=="male"],na.rm=T),max(df$variable[df$covs_sex=="female"],na.rm=T)))
    grid.arrange(Plot,tableGrob(Table,theme=ttheme_minimal(base_size=10)),nrow=2,ncol=1,as.table=T)
  }
  lapply(1:length(variables),table.and.plot.function,list.of.dfs=list_of_variable_dataframes,list.of.variables=variables)
}

# wrapper

check.variables <- function(grep.pattern, continuous.or.categorical){
if(continuous.or.categorical == "continuous"){
  variables<-names(dat)[grep(names(dat),pattern=grep.pattern)]
  cat.variables <-variables[grep(variables,pattern="binary|ordinal")]
  check.continuous.variables(variables[!variables%in%cat.variables])
}else{
  variables<-names(dat)[grep(names(dat),pattern=grep.pattern)]
  cat.variables <-variables[grep(variables,pattern="binary|ordinal")]
  check.categorical.variables((cat.variables))
}
}

