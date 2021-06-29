#Function for generating mediterranean diet data from raw_dat (ALSPAC)
gen_med_diet_data <- function(){
  #Maternal mediterranean diet
  alspac.table <- haven::zap_labels(raw_dat)
  colnames(alspac.table) <- tolower(colnames(alspac.table))
  # set missings to 0 for these variables
  # (ie if missing assume not consumed at all)
  vars=c(
    "c200","c201","c202","c203","c204","c205","c206","c207","c208","c209",
    "c210","c211","c215","c216","c217","c218","c219","c220","c221","c222",
    "c223","c224","c225","c226","c227","c228","c229","c230","c231","c232",
    "c233","c234","c235","c236","c237","c238","c239","c240","c241","c242",
    "c243","c244","c245","c246","c247","c251","c252","c253","c254","c255",
    "c256","c260","c261","c263","c264","c265","c266","c267","c268","c269",
    "c270","c271","c272","c273","c274","c276","c277","c278","c279","c280",
    "c281","c282","c283","c284","c285","c286","c287","c288","c289","c300",
    "c301","c305","c306","c310","c373")
  # replace missing values with 0
  alspac.table[,vars]<-replace(alspac.table[,vars],alspac.table[,vars]<0,0)
  #########################################
  # Extract the relevant variables from ALSPAC data 
  # and set up food.data data frame for storing the 
  # interim variables - this keeps the orginal data 
  # untouched.
  # Food.data consists of frequency of eating variables
  # recoded from cateogrical to midpoints, plus a couple 
  # of interim calculations 
  #
  # ALSPAC variables to keep
  keep_vars<-c("aln",
               "c200","c201", "c202", "c203", "c204", 
               "c205","c206", "c207", "c209","c210", 
               "c217","c218", "c220", "c222", "c223", 
               "c224", "c225", "c226", "c227", "c228", 
               "c229", "c232", "c233", "c234", "c235", 
               "c237", "c240", "c241", "c243", "c250", 
               "c252", "c253", "c254", "c255", "c260",
               "c261", "c263", "c264", "c265", "c266", 
               "c267", "c268", "c269", "c270", "c271", 
               "c272", "c273", "c274", "c275", "c284", 
               "c285", "c286", "c287", "c288", "c289", 
               "c300", "c305", "c373")
  food.data <- alspac.table[,keep_vars]
  #########################################################
  # convert all categorical frequency variables into number 
  # of times eaten per week
  #########################################################
  # FREQ
  # 1  Never or rarely    0
  # 2  Once in 2WKS       0.5
  # 3  1-3 times PWK      2
  # 4  4-7 times PWK      5.5
  # 5  >once a day        10
  vars<-c("c200","c201", "c202", "c203", "c204", 
          "c205","c206", "c207", "c209", "c210", 
          "c217","c218", "c222", "c223", "c224", 
          "c225", "c226", "c227", "c228", "c229", 
          "c232", "c233", "c234", "c235", "c237", 
          "c240", "c241", "c243")
  food.data[,vars]<-sapply(alspac.table[,vars], recode,
                           "1"=0,
                           "2"=0.5,
                           "3"=2,
                           "4"=5.5,
                           "5"=10)
  # c250 slices of bread
  # missing       1.5
  # 1 <1          0
  # 2 1-2         1.5
  # 3 3-4         3.5
  # 4 5 or more   6
  food.data$c250[alspac.table$c250<0] <- 1.5
  food.data$c250<-recode(alspac.table$c250, 
                         "0"=0,
                         "1"=0,
                         "2"=1.5,
                         "3"=3.5,
                         "4"=6)
  # c275 slices of bread with fat 
  # missing   2
  # values>7  6
  food.data$c275[alspac.table$c275<0] <- 2
  food.data$c275[alspac.table$c275>7] <- 6
  # c252-255 eat types of bread
  # 1 Yes 1
  # 2 No  0
  food.data$c252[alspac.table$c252!=1] <- 0
  food.data$c253[alspac.table$c253!=1] <- 0
  food.data$c254[alspac.table$c254!=1] <- 0
  food.data$c255[alspac.table$c255!=1] <- 0
  #c284 c285 c287 c288 c289 - milk in tea, coffee, pudding, as drink, in milky drink
  # 0 (recoded from missing) 0
  # 1 Usually             1
  # 2 Sometimes           0.5
  # 3 Never               0
  vars=c("c284","c285","c287","c288","c289") 
  food.data[,vars]<-sapply(alspac.table[,vars], recode,
                           "0"=0,
                           "1"=1,
                           "2"=0.5,
                           "3"=0)
  #c286 milk in cereal
  # 0 (recoded from missing) 0
  # 1 Usually             1
  # 2 Sometimes           1
  # 3 Never               0
  food.data$c286 = recode(alspac.table$c286,
                          "0"=0, "1"=1, "2"=1,"3"=0)
  # c269 & c270 oil on bread/for frying
  # 1 Yes 1
  # 2 No  0
  food.data$c269[alspac.table$c269!=1] <- 0
  food.data$c270[alspac.table$c270!=1] <- 0
  # variables in food.data now have appropriate frequencies
  ###########################################                        
  #Set up a data frame for the output: food.gp
  food.gp=data.frame(aln=alspac.table$aln,
                     qlet=alspac.table$qlet,
                     vegetables=NA,
                     legumes=NA,
                     fruitnuts=NA,
                     dairy=NA,
                     cereals=NA,
                     meat=NA,
                     fish=NA,
                     oliveoil=NA,
                     alcohol=NA)
  ###################### Vegetables
  # Use variables: 
  #   c224 leafy green    119g
  #   c225 other green    132g
  #   c226 carrots        60g
  #   c227 other root veg 87g
  #   c228 salad          80g
  #   c210 pizza toppings   54.8g
  food.gp$vegetables <- 119 * food.data$c224 +
    132 * food.data$c225 +
    60 * food.data$c226 +
    87 * food.data$c227 +
    80 * food.data$c228 +
    54.8 * food.data$c210
  # these are portions per week - convert to daily:
  food.gp$vegetables <- food.gp$vegetables/7
  ###################### Legumes
  # c222 baked beans 135g
  # c223 legumes      74g
  # c240 pulses       120g
  food.gp$legumes <- 135 * food.data$c222 +
    74 * food.data$c223 +
    120 * food.data$c240 
  # these are portions per week - convert to daily:
  food.gp$legumes <- food.gp$legumes/7
  ###################### Fruit & Nuts
  # c229 fresh fruit  118g
  # c241 nuts          52g
  # c243  tahini       10g
  food.gp$fruitnuts <- 118 * food.data$c229 +
    52 * food.data$c241 +
    10 * food.data$c243
  # these are portions per week - convert to daily:
  food.gp$fruitnuts <- food.gp$fruitnuts/7
  ###################### Dairy
  ### milk:
  # c284  in tea          30g per cup
  # c300 cups/tea per day
  # c285 in coffee        30g per cup
  # c305 cups/coffee per day
  # c286 in cereal        100g per cereal
  # c233, c234 c235 - oat, bran and other cereals /week
  # c287 in pudding       150g
  # c232 no. puddings /week
  # c288 as a drink       200g
  # c289 in milky drink   260g
  # no measure of frequency for these two beyond usually/sometimes -
  # previous code has a factor 2/3 which I think is
  # interpreting 'usually have a milk drink' as on 2 in 3 days
  # 'sometimes' has a value of 0.5, so is thus on 1 in 3 days
  # milk - do this as daily milk (so need to convert cer3al and puddings)
  food.data$milk <- 30 * food.data$c284 * food.data$c300 +
    30 * food.data$c285 * food.data$c305 +
    (100 * food.data$c286 * (food.data$c233 + food.data$c234 + food.data$c235) )/7+
    (150 * food.data$c287 *food.data$c232)/7 +
    200 * food.data$c288 * 2/3 +
    260 * food.data$c289 * 2/3
  ### Other dairy:
  # c209 cheese   46g
  # c210 pizza    60.3g
  # convert cheese and pizza to daily
  food.gp$dairy <- (46 * food.data$c209 +
                      60.3 * food.data$c210)/7 +
    food.data$milk
  ###################### Cereals
  ### bread:
  # c250 portions eaten per day
  # Types of bread eaten
  # c252 white    36g
  # c253 brown    36g
  # c254 wholemeal    36g
  # c255 chapati    68g
  # c256 Dont usually eat any bread
  #vector of portion sizes for each type of bread
  b.portion <- matrix(c(36, 36, 36, 68),4,1)
  # matrix of bread types eaten: rows are observations, 4 cols for bread types
  # matrix contains 1 if type is eaten, 0 otherwise
  b.mat <- as.matrix(food.data[,c("c252","c253","c254","c255")] )
  # count number of different types of bread eaten
  n.btype <- apply(b.mat ,1,sum,na.rm=T)
  # scale bread matrix to be proportions  - 
  # so if eat two types of bread, then half for each
  # (avoid dividing by zero if there are none)
  b.mat[n.btype>0,] <- b.mat[n.btype>0,]/n.btype[n.btype>0]
  # calculate total portion size for a person, given the breads they eat
  food.data$bread <- b.mat %*% b.portion 
  # and calculate daily amount from portinos eaten per day
  food.data$bread <- food.data$bread * food.data$c250
  #### Other cereals
  # c217 rice     135g
  # c218 pasta    150g
  # c210 pizza    32.1g
  # c233 oat cereals      80g
  # c234 bran cereals     36g
  # c235 other cereals    33g
  # c237 crispbread   20g
  food.gp$cereals <- 135 * food.data$c217 +
    150 * food.data$c218 +
    32.1 * food.data$c210 +
    80 * food.data$c233 +
    36 * food.data$c234 +
    33 * food.data$c235 +
    20 * food.data$c237
  #convert to daily
  food.gp$cereals <- food.gp$cereals/7
  # add daily bread
  food.gp$cereals <- food.gp$cereals + food.data$bread
  ###################### Meat
  # c200 sausages/burgers 80g
  # c201 pies/pasties    129g
  # c202 red meat         88g
  # c203 poultry          100g
  # c204 offal            98g
  # amount of fat - not relevant
  food.gp$meat <-  80 * food.data$c200 +
    129 * food.data$c201 +
    88 * food.data$c202 +
    100 * food.data$c203 +
    98 * food.data$c204
  # these are portions per week - convert to daily:
  food.gp$meat <- food.gp$meat/7
  ###################### Fish
  # c205 white fish   130g
  # c206 oily fish    119g
  # c207 shellfish    89g
  food.gp$fish <- 130 * food.data$c205 +
    119 * food.data$c206 +
    89 * food.data$c207
  # these are portions per week - convert to daily:
  food.gp$fish <- food.gp$fish/7
  ###################### Olive Oil
  # c269 oil on bread         10g
  # c270 oil for frying       10g
  # ignore oil on bread
  #oil for frying:
  # sunflower/soya/corn/olive oil
  # Assume these occur in the proportions 30/30/30/10
  # - so 1/10 of oil is assumed to be olive oil
  # c261 butter for frying
  # c264 marg for frying
  # c266 polyunsat marg for frying
  # c268 low fat spread for frying
  # c270 sun/olive/etc oil for frying   <==========
  # c272 other oil for frying
  # c274 other fat for frying
  #  - assume these are used for frying proportionately
  # c220 freq eat fried food
  # matrix of frying fats used: rows are observations, 7 cols for fat types
  # matrix contains 1 if fat is used, 0 otherwise
  f.mat <- as.matrix(food.data[,c("c261","c264","c266","c268", "c270", "c272", "c274")] )
  # count number of different types of fat used
  n.ftype <- apply(f.mat ,1,sum)
  # scale fat matrix to be proportions  - 
  f.mat[which(n.ftype>0),] <- f.mat[which(n.ftype>0),]/n.ftype[which(n.ftype>0)]
  #only interested in the oil proportion:
  oil.p <- f.mat[,5]
  #assume 1/10 of this is olive oil:
  oil.p <- oil.p/10
  # calculate  total olive oil as 10g per portion each fried food occasion:
  food.gp$oliveoil <- 10 * oil.p * food.data$c220
  ###################### Alcohol
  # c373 alcohol units/wk 8g/unit
  food.gp$alcohol  <- food.data$c373 * 8              
  # convert to daily
  food.gp$alcohol  <- food.gp$alcohol/7
  # tidy up
  # remove interim variables
  rm(list=c("keep_vars","vars","nmiss","v",
            "b.mat","n.btype","b.portion",
            "f.mat","n.ftype","oil.p"))
  # Additional code
  pheno <- food.gp
  pheno$mat.kcal <- alspac.table$c3804
  pheno$mat.kcal[pheno$mat.kcal<0]<-NA
  pheno$mat.kcal <- pheno$mat.kcal/4.184 # convert kj to kcal
  ################
  # Construct food group tertiles
  # Please comment out (using # at beginning of each line) if your cohort does not have sufficient variation (not a normal distribution) in consumption of a food item (e.g. legumes or olive oil)
  # In that case, please see the next step of constructing alternative cut-offs
  ################
  # first check the distribution of food items
  require(ggplot2)
  require(reshape)
  require(knitr)
  df <- melt(pheno[,-c(1:2)])
  fooditems_hist <- ggplot(df,aes(value))+
    geom_histogram()+
    facet_wrap(.~variable,scales="free")
  fooditems_summary <- df %>% group_by(variable) %>%
    summarise(mean=mean(value,na.rm=T),sd=sd(value,na.rm=T),median=median(value,na.rm=T),lowerQ=quantile(value,0.25,na.rm=T),upperQ=quantile(value,0.75,na.rm=T)) %>%
    kable()
  fooditems_hist
  fooditems_summary
  # Now generate tertiles
  # Vegetables
  pheno$veg1000kcal <- (pheno$vegetables / pheno$mat.kcal * 1000)
  pheno$vegrmed <- with(pheno, factor(findInterval(pheno$veg1000kcal, c(-Inf, quantile(pheno$veg1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$vegrmed <- plyr::revalue(as.character(pheno$vegrmed), c("Q1"="0", "Q2"="1", "Q3"="2"))
  pheno$vegrmed <- as.numeric(pheno$vegrmed)
  # Legumes
  pheno$leg1000kcal <- (pheno$legumes / pheno$mat.kcal * 1000)
  pheno$legrmed <- with(pheno, factor(findInterval(pheno$leg1000kcal, c(-Inf, quantile(pheno$leg1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$legrmed <- plyr::revalue(as.character(pheno$legrmed), c("Q1"="0", "Q2"="1", "Q3"="2"))
  pheno$legrmed <- as.numeric(pheno$legrmed)
  # Fruit incl nuts	
  pheno$fruit1000kcal <- (pheno$fruitnuts / pheno$mat.kcal * 1000)
  pheno$fruitrmed <- with(pheno, factor(findInterval(pheno$fruit1000kcal, c(-Inf, quantile(pheno$fruit1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$fruitrmed <- plyr::revalue(as.character(pheno$fruitrmed), c("Q1"="0", "Q2"="1", "Q3"="2"))
  pheno$fruitrmed <- as.numeric(pheno$fruitrmed)
  # Fish and seafood								
  pheno$fish1000kcal <- (pheno$fish / pheno$mat.kcal * 1000)
  pheno$fishrmed <- with(pheno, factor(findInterval(pheno$fish1000kcal, c(-Inf, quantile(pheno$fish1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$fishrmed <- plyr::revalue(as.character(pheno$fishrmed), c("Q1"="0", "Q2"="1", "Q3"="2"))
  pheno$fishrmed <- as.numeric(pheno$fishrmed)
  # Cereals								
  pheno$cereal1000kcal <- (pheno$cereals / pheno$mat.kcal * 1000)
  pheno$cerealrmed <- with(pheno, factor(findInterval(pheno$cereal1000kcal, c(-Inf, quantile(pheno$cereal1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$cerealrmed <- plyr::revalue(as.character(pheno$cerealrmed), c("Q1"="0", "Q2"="1", "Q3"="2"))
  pheno$cerealrmed <- as.numeric(pheno$cerealrmed)
  # Meat								
  pheno$meat1000kcal <- (pheno$meat / pheno$mat.kcal * 1000)
  pheno$meatrmed <- with(pheno, factor(findInterval(pheno$meat1000kcal, c(-Inf, quantile(pheno$meat1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$meatrmed <- plyr::revalue(as.character(pheno$meatrmed), c("Q1"="2", "Q2"="1", "Q3"="0"))
  pheno$meatrmed <- as.numeric(pheno$meatrmed)
  # Dairy								
  pheno$dairy1000kcal <- (pheno$dairy / pheno$mat.kcal * 1000)
  pheno$dairyrmed <- with(pheno, factor(findInterval(pheno$dairy1000kcal, c(-Inf, quantile(pheno$dairy1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  pheno$dairyrmed <- plyr::revalue(as.character(pheno$dairyrmed), c("Q1"="2", "Q2"="1", "Q3"="0"))
  pheno$dairyrmed <- as.numeric(pheno$dairyrmed)
  # Olive oil [does not show a normal distribution in ALSPAC, so this code not used]
  ##pheno$oliveoil1000kcal <- (pheno$oliveoil / pheno$mat.kcal * 1000)
  ##pheno$oliveoilrmed <- with(pheno, factor(findInterval(pheno$oliveoil1000kcal, c(-Inf, quantile(pheno$oliveoil1000kcal, probs=c(0.33333, .66667),na.rm=T), Inf)), labels=c("Q1","Q2","Q3")))
  ##pheno$oliveoilrmed <- plyr::revalue(as.character(pheno$oliveoilrmed), c("Q1"="0", "Q2"="1", "Q3"="2"))
  ##pheno$oliveoilrmed <- as.numeric(pheno$oliveoilrmed)
  # Alcohol
  pheno$alcoholrmed <- 0
  pheno$alcoholrmed[pheno$alcohol>=5 & pheno$alcohol<=25] <- 2
  
  ################
  # Construct alternative cut-offs if >33% has same intake, e.g. >33% of women in Generation R consumes no legumes
  # In this case remove this specific food group above from "Construct food group tertiles"
  ################
  # in ALSPAC, we have to do this for oliveoil
  ## Please note that the first "tertile" will be those with no oliveoil consumption, since >33% had olive oil intake of zero. The script won't run when one value crosses two tertiles
  pheno$oliveoil1000kcal <- (pheno$oliveoil / pheno$mat.kcal * 1000)
  pheno$oliveoilrmed_notzero <- ifelse(pheno$oliveoil1000kcal == 0, NA, pheno$oliveoil1000kcal)
  pheno$oliveoilrmed <- with(pheno, factor(findInterval(pheno$oliveoilrmed_notzero, c(0.0000001, quantile(pheno$oliveoilrmed_notzero, probs=c(0.5), na.rm=T), Inf)), labels=c("1","2"))) ## CHECK WITH LEANNE AS I HAD TO CHANGE 0.01 TO 0.0000001
  pheno$oliveoilrmed <- as.numeric(pheno$oliveoilrmed)
  pheno$oliveoilrmed[pheno$oliveoil1000kcal==0] <- 0 #because more than 33% had olive oil intake of zero. The script won't run when one value crosses two tertiles
  pheno$oliveoilrmed_notzero <-NULL
  ## Check tertiles
  df <- melt(pheno[,grep("rmed",colnames(pheno))])
  tertile.table <- kable(table(df$variable, df$value))
  
  ################
  # Construct rMED
  ################
  pheno$rmed <- pheno$vegrmed + pheno$legrmed + pheno$fruitrmed + pheno$fishrmed + pheno$cerealrmed + pheno$meatrmed + pheno$dairyrmed + pheno$oliveoilrmed + pheno$alcoholrmed
  ################
  # Construct rMED2
  ################
  pheno$rmed2 <- pheno$vegrmed + pheno$legrmed + pheno$fruitrmed + pheno$fishrmed + pheno$cerealrmed + pheno$meatrmed + pheno$dairyrmed + pheno$oliveoilrmed
  # check distribution of med diet indices
  require(ggplot2)
  require(reshape)
  df <- melt(pheno[,c("rmed","rmed2")])
  rmed_hist <- ggplot(df,aes(value))+
    geom_histogram()+
    facet_wrap(.~variable,scales="free")
  rmed_summary <- df %>% group_by(variable) %>%
    summarise(mean=mean(value,na.rm=T),sd=sd(value,na.rm=T),median=median(value,na.rm=T),lowerQ=quantile(value,0.25,na.rm=T),upperQ=quantile(value,0.75,na.rm=T)) %>%
    kable()
  rmed_hist
  rmed_summary
  names(pheno) <- c("aln","qlet",paste0("diet_mother_",names(pheno)[3:ncol(pheno)],"_ever_pregnancy_continuous"))
  pheno
}