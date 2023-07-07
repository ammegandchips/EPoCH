#function to run regression analysis

run_analysis<-function(exposures,outcomes,model_number,df){
  
  #if the exposure is a factor, change it so it's no longer "ordered":
  df[,exposures][sapply(df[,exposures], is.factor)] <- lapply(df[,exposures][sapply(df[,exposures], is.factor)], function(x) factor(x,ordered=FALSE))
  
  # run logistic regression for all binary outcomes:
  binary_key <- key[which(key$exposure%in%exposures & key$outcome%in%outcomes & key$outcome_type=="binary"),c("exposure","outcome",paste0("covariates_",model_number),"person_exposed")]
  if(nrow(binary_key)==0){
    binary_res <- NA
  }else{
    binary_res <- apply(binary_key,1,function(x){
      exposure <- as.character(x[1])
      outcome <- as.character(x[2])
      adjustment_vars <- na.omit(unlist(strsplit(as.character(x[3]),split=",")))
      if(grepl("_FEMALE|_MALE",cohort)){
      adjustment_vars <-   adjustment_vars[-which(adjustment_vars=="covs_sex")]
      }
      adjustment_vars <- adjustment_vars[adjustment_vars %in% colnames(df)]
      fit <-try(glm(formula=as.formula(paste( outcome, "~", paste(c(exposure,adjustment_vars),collapse="+") )),data=df,family="binomial"),silent=T)
      # extract results
      res<-try(data.frame(summary(fit)$coef,1-(fit$deviance/fit$null.deviance),nrow(model.frame(fit))),silent=T)
      if(class(res)=="try-error"){res<-as.data.frame(t(data.frame(error=rep(NA,6))))
      }else{
        if(is.na(fit$coefficients[2])){res<-as.data.frame(t(data.frame(error=rep(NA,6))))
        }else{
          res <- res
        }}
      res$regression_term <-rownames(res)
      try(names(res)<-c("est","se","t.z","p","r2","n","regression_term"))
      res$regression_type <-"glm"
      if(is.na(res$est[1])){
        res$ci.l <- NA
        res$ci.u <- NA
        res$intercept_est <- NA
        res$intercept_se <- NA
        res$intercept_p <- NA
        res$outcome_n <-NA
        res$exposure_n<-NA
      }else{
        res$ci.l <- res$est-(res$se*1.96)
        res$ci.u <- res$est+(res$se*1.96)
        res$intercept_est <- res[1,1]
        res$intercept_se <- res[1,2]
        res$intercept_p <- res[1,4]
        res$outcome_n <- sum(model.frame(fit)[,as.character(outcome)]==1)
        if(grepl("binary",exposure)){
          res$exposure_n <- sum(model.frame(fit)[,as.character(exposure)]==1)
        }else{
          if(grepl("ordinal",exposure)){
            res$exposure_n <- NA
            res$exposure_n[grep("Light",res$regression_term)] <- sum(model.frame(fit)[,as.character(exposure)]=="Light")
            res$exposure_n[grep("Moderate",res$regression_term)] <- sum(model.frame(fit)[,as.character(exposure)]=="Moderate")
            res$exposure_n[grep("Heavy",res$regression_term)] <- sum(model.frame(fit)[,as.character(exposure)]=="Heavy")
          }else{
            res$exposure_n <-NA
        }
      }
      # remove unneeded results
      if(any(c(is.na(adjustment_vars),class(fit)=="try-error")==TRUE)){
        res<-res
      }else{
        if(is.na(fit$coefficients[2])){
          res<-res
        }else{
          res<-res[-grep(res$regression_term,pattern=paste0(c("(Intercept)",adjustment_vars),collapse="|")),]
        }
      }}
      res
    })
    
    binary_res <-Map(cbind, binary_res, outcome = binary_key$outcome, exposure = binary_key$exposure, person_exposed=binary_key$person_exposed)
    binary_res <- as.data.frame(do.call(rbind,binary_res))
  }
  
  # run linear regression for all continuous/integer outcomes:
  cont_key <- key[which(key$exposure%in%exposures & key$outcome%in%outcomes & key$outcome_type=="continuous"),c("exposure","outcome",paste0("covariates_",model_number),"person_exposed")]
  if(nrow(cont_key)==0){
    cont_res <-NA
    }else{
    cont_res <- apply(cont_key,1,function(x){
      exposure <- as.character(x[1])
      outcome <- as.character(x[2])
      adjustment_vars <- na.omit(unlist(strsplit(as.character(x[3]),split=",")))
      if(grepl("_FEMALE|_MALE",cohort)){
        adjustment_vars <-   adjustment_vars[-which(adjustment_vars=="covs_sex")]
      }
      adjustment_vars <- adjustment_vars[adjustment_vars %in% colnames(df)]
      fit <-try(lm(formula=as.formula(paste( outcome, "~", paste(c(exposure,adjustment_vars),collapse="+") )),data=df),silent=T)
      # extract results
      res<-try(data.frame(summary(fit)$coef,summary(fit)$r.squared,nrow(model.frame(fit))),silent=T)
      if(class(res)=="try-error"){res<-as.data.frame(t(data.frame(error=rep(NA,6))))
      }else{
        if(is.na(fit$coefficients[2])){res<-as.data.frame(t(data.frame(error=rep(NA,6))))
        }else{
          res <- res
        }}
      res$regression_term <-rownames(res)
      try(names(res)<-c("est","se","t.z","p","r2","n","regression_term"))
      res$regression_type <-"lm"
      if(is.na(res$est[1])){
        res$ci.l <- NA
        res$ci.u <- NA
        res$intercept_est <- NA
        res$intercept_se <- NA
        res$intercept_p <- NA
        res$outcome_n <-NA
        res$exposure_n <-NA
      }else{
        res$ci.l <- res$est-(res$se*1.96)
        res$ci.u <- res$est+(res$se*1.96)
        res$intercept_est <- res[1,1]
        res$intercept_se <- res[1,2]
        res$intercept_p <- res[1,4]
        res$outcome_n <-NA
        if(grepl("binary",exposure)){
          res$exposure_n <- sum(model.frame(fit)[,as.character(exposure)]==1)
        }else{
          if(grepl("ordinal",exposure)){
            res$exposure_n <-NA
            res$exposure_n[grep("Light",res$regression_term)]<-sum(model.frame(fit)[,as.character(exposure)]=="Light")
            res$exposure_n[grep("Moderate",res$regression_term)]<-sum(model.frame(fit)[,as.character(exposure)]=="Moderate")
            res$exposure_n[grep("Heavy",res$regression_term)]<-sum(model.frame(fit)[,as.character(exposure)]=="Heavy")
          }else{
               res$exposure_n <-NA
             }
        }
      }
      # remove unneeded results
      if(any(c(is.na(adjustment_vars),class(fit)=="try-error")==TRUE)){
        res<-res
      }else{
        if(is.na(fit$coefficients[2])){
          res<-res
        }else{
          res<-res[-grep(res$regression_term,pattern=paste0(c("(Intercept)",adjustment_vars),collapse="|")),]
        }
      }
      res
    })
    
    cont_res <-Map(cbind, cont_res, outcome = cont_key$outcome, exposure = cont_key$exposure, person_exposed = cont_key$person_exposed)
    cont_res <- as.data.frame(do.call(rbind,cont_res))
  }
  
  
  # Combine logistic and linear regression results
  if(class(binary_res)=="logical"){all_res <- cont_res
  }else{
    if(class(cont_res)=="logical"){all_res <- binary_res
    }else{
      all_res <- rbind.data.frame(binary_res,cont_res)
    }}
  row.names(all_res)<-NULL
  all_res$model <- model_number
  all_res[,c("exposure","outcome","regression_term","person_exposed","model","n","exposure_n","outcome_n","est","se","ci.l","ci.u","p","r2","t.z","intercept_est","intercept_se","intercept_p")]
}
