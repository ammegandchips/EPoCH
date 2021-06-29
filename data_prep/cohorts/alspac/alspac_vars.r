######################################################################
## Code to create alspac_pheno_raw.rds                              ##
## This code extracts all the raw variables from the ALSPAC server  ##
## and removes tripquads etc and performs WoCs                      ##
######################################################################

## CONNECT TO ALSPAC SERVER AT smb://central-gpfs.isys.bris.ac.uk/ALSPAC-Data

## Begin by clearing the environment
## (This is important!)

rm(list=ls())

###########################################
#######        Cohort profile         #####
###########################################
# From Cohort Profile
cp_location <- "/Volumes/ALSPAC-Data/Current/Other/Cohort Profile/cp_2b.dta"
cp_vars <- c("aln","qlet","in_alsp","in_core","in_phase2","in_phase3","in_phase4","tripquad","kz011b","kz021")

# Mums' profile (MZ)
mz_location <- "/Volumes/ALSPAC-Data/Current/Other/Sample Definition/mz_5a.dta"
mz_vars <- c("mz001","mz010","mz010a","mz011b","mz028a","mz028b","mz024a","mz024b")

# Kids' profile (KZ)
kz_location <- "/Volumes/ALSPAC-Data/Current/Other/Sample Definition/kz_5c.dta"
kz_vars <- c("kz001","kz011","kz017","kz030","kz028","kz031","kz032")

# Multiple Pregnancies (multpregs)
multpregs_location <- "/Volumes/ALSPAC-Data/Useful_data/Multiple pregs/mult_pregs in alspac_CORE.dta"
multpregs_vars <- c("mult_no","aln2","aln3")

# Bestgest
bestgest_location <-"/Volumes/ALSPAC-Data/Useful_data/bestgest/bestgest.dta"
bestgest_vars<-c("bestgest")

# Obstetrics
obs_location<-"/Volumes/ALSPAC-Data/Current/Other/Obstetric/OA_r1b.dta"
obs_vars<-c("HDP","pregnancy_diabetes")

# Birthweight centiles
centiles_location<-"/Volumes/ALSPAC-Data/Useful_data/birthweight_centile/data for centile program II.dta"
centiles_vars<-"centiles"

###########################################
#######          Partners'        #########
###########################################
dadspa_location <- "/Volumes/ALSPAC-Data/Current/Quest/Partner/pa_4a.dta"
dadspa_vars<-c("pa900","pa901","pa910","pa065","pa064","pa173a","pa174a","pa210","pa189a","pa172a","pa190a",
               "pa191a","pa191a","pa192a","paw002","paw010")

dadspb_location <- "/Volumes/ALSPAC-Data/Current/Quest/Partner/pb_4b.dta"
dadspb_vars<-c("pb900","pb901","pb071","pb072","pb077","pb078","pb079","pb075","pb076","pb099","pb100",
               "pb101","pb054", "pb057", "pb058", "pb060a", "pb061", "pb062", "pb063", "pb064", "pb066",
               "pb056","pb056a","pb060","pb065","pb065a","pb013","pb014","pb202","pb088","pb089","pb090",
               "pb091","pb092","pb093","pb094","pb095","pb096","pb097","pb098")

dadspc_location <- "/Volumes/ALSPAC-Data/Current/Quest/Partner/pc_3a.dta"
dadspc_vars<-c("pc250","pc260","pc251","pc280","pc281","pc996")

dadspd_location <- "/Volumes/ALSPAC-Data/Current/Quest/Partner/pd_7b.dta"
dadspd_vars<-c("pd620","pd625")

dadspe_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Partner/pe_4a.dta")
dadspe_vars<-c("pe450","pe452","pe411")

dadsph_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Partner/ph_1c.dta")
dadsph_vars<-c("ph6180")

dadspj_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Partner/pj_r1a.dta")
dadspj_vars<-c("pj5050","pj5051")

dadspl_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Partner/pl_r1b.dta")
dadspl_vars<-c("pl5010")

dadspp_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Partner/pp_r1b.dta")
dadspp_vars<-c("pp6020")

###########################################
#####      Mums' questionnaires      ######
###########################################
mumsa_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/a_3e.dta")
mumsa_vars <- c("a902", "a521","a522","a261","a228", "a222", "a225", "a231", "a234", "a237","a525",
                "a522","a524")

mumsb_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/b_4f.dta")
mumsb_vars <- c("b924","b650","b651","b652","b660","b663","b669","b665","b667","b670","b671",
                "b695","b683","b685","b690","b691","b692","b720","b721","b722","b754","b757",
                "b760","b769", "b775","b723","b730","b748", "b742", "b745", "b751", "b763", "b766",
                "b555","b556","b557","b635","b634","b862","b032","b040","b041","b042","b613","b560","b140",
                "b141","b142","b143","b144","b149","b700","b701","b702","b706","b707","b708","b709","b710",
                "b711","b712","b713","b714")

mumsc_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/c_8a.dta")
mumsc_vars <- c("c991","c482","c481a","c373","c360","c300", "c303", "c305", "c309", "c310", "c312", 
                "c317","c503","c504", "c200","c201","c202","c203","c204","c205","c206","c207", "c208","c209", 
                "c210","c216","c217","c218","c219","c220","c221","c222","c223","c224","c225",
                "c226","c227","c228","c229","c230","c231","c232","c233","c234","c235","c236","c237","c238",
                "c239","c240","c241","c242","c243","c244","c245","c246","c247","c250","c275","c251","c252",
                "c253","c254","c255","c256","c260","c261","c263","c264","c265","c266","c267","c268","c269",
                "c270","c271","c272","c273","c274","c276","c277","c278","c279","c280","c281","c282","c283",
                "c284","c285","c287","c288","c289","c286", "c301","c306","c373","c3804","c800","c801","c804",
                "c666a","c645a","c755","c765","c768","c110","c111","c112","c113","c114","c115","c211","c215", "c802","c803")


mumsd_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/d_4b.dta")
mumsd_vars <- c("d990","d153a","d154a","d190","d040","d169a","d152a","d170a","d171a","d172a",
                "dw021","dw002")

mumse_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/e_4f.dta")
mumse_vars <- c("e699","e178","e185", "e186","e220","e221", "e222","e157","e150","e151","e152",
                "e154","e155","e153","e156")

mumsf_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/f_2b.dta")
mumsf_vars <- c("f620","f601", "f625", "f626","f600")

mumsg_location <- "/Volumes/ALSPAC-Data/Current/Quest/Mother/g_5c.dta"
mumsg_vars <- c("g820","g822", "g823", "g825","g750","g761","g762","g572","g572a","g571","g571a")

mumsh_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/h_6d.dta")
mumsh_vars <- c("h602","h462","h462a","h461","h461a")

mumsj_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/j_5b.dta")
mumsj_vars <- c("j557a","j557b","j557c","j557d","j557e","j557f","j914")

mumsp_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Mother/p_r1b.dta")
mumsp_vars <- c("p3190")

###########################################
#######       Child based files      ######
###########################################
childka_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/ka_5a.dta"
childka_vars <- c("ka249","ka252","ka497")

childkb_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kb_7b.dta"
childkb_vars <- c("kb086","kb089","kb053","kb419","kb879a","kb277","kb280","kb390","kb390a","kb387",
                  "kb387a","kb549","kb551","kb388","kb385","kb361")

childkc_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kc_6a.dta"
childkc_vars <- c("kc403","kc404","kc514", "kc544","kc541","kc572","kc574","kc570","kc363","kc542","kc539","kc361",
                  "kc512")

childkd_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kd_5a.dta"
childkd_vars <- c("kd085","kd088","kd051b","kd070","kd990")

childke_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/ke_6a.dta"
childke_vars <- c("ke341","ke350","ke352","ke354","ke339","ke321","ke195","ke195a","ke196","ke196a",
                  "ke340","ke338","ke320")

childkf_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kf_8b.dta"
childkf_vars <- c("kf110","kf063","kf999","kf527","kf528")

childkg_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kg_5a.dta"
childkg_vars <- c("kg475","kg423","kg420","kg369a","kg174")

childkj_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kj_7a.dta"
childkj_vars <- c("kj100","kj043","kj090","kj999a","kj517","kj518")

childkk_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kk_3b.dta"
childkk_vars <- c("kk262a","kk286","kk287","kk288","kk289","kk290","kk998a","kk800","kk645","kk640","kk598",
                  "kk312")

childkl_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kl_2a.dta"
childkl_vars <- c("kl100","kl031","kl080","kl991a")

childkm_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/km_r1b.dta"
childkm_vars <- c("km6003","km6013","km6023","km6033","km6002","km6012","km6022","km6032","km6001",
                  "km6011","km6021","km6031","km2200","km2231","km2232","km2233","km2234","km2235","km9991a",
                  "km3030","km3031")

childkn_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kn_2a.dta"
childkn_vars <- c("kn7000","kn7003","kn7001","kn1120","kn1031","kn1110","kn9991a")

childkp_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kp_r1b.dta"
childkp_vars <- c("kp7003","kp7008","kp7002","kp7007","kp7001","kp7006","kp3030","kp9991a","kp5090","kp5091")

childkq_location <- ("/Volumes/ALSPAC-Data/Current/Quest/Child Based/kq_3a.dta")
childkq_vars <- c("kq348a","kq348b","kq348c","kq348d","kq348e","kq348f","kq035a","kq090","kq034a",
                  "kq024a","kq070","kq195a","kq217","kq218","kq219","kq220","kq221","kq830","kq823","kq798a","kq885","kq998a")

childkr_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kr_2a.dta"
childkr_vars <- c("kr554a","kr554b","kr042a","kr031a","kr041a","kr050","kr105a","kr991a")

childks_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/ks_r1b.dta"
childks_vars <- c("ks1042","ks1280","ks1031","ks1041","ks1240","ks1260","ks3000","ks3031","ks3032","ks3033",
                  "ks3034","ks3035","ks3030","ks9991a")

childkt_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kt_2b.dta"
childkt_vars <- c("kt6400","kt6290","kt6280","kt6193","kt1210","kt1211")

childku_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/ku_r2b.dta"
childku_vars <- c("ku783","ku788","ku793","ku798","ku782","ku787","ku792","ku797",
                  "ku705b","ku706b","ku707b","ku708b","ku709b","ku710b","ku991a")

childkv_location <- "/Volumes/ALSPAC-Data/Current/Quest/Child Based/kv_2a.dta"
childkv_vars <- c("kv1070","kv1110","kv1111","kv1060","kv1070","kv1080","kv1050","kv1059","kv9991a")

###########################################
#######    Child completed files      #####
###########################################

childf7_location <- "/Volumes/ALSPAC-Data/Current/Clinic/Child/f07_5a.dta"
childf7_vars <- c("f7ms014","f7ms010","f7ms018","f7ms026","f7ms026a","f7003c","f7sa022","f7sa021")

childf8_location <- "/Volumes/ALSPAC-Data/Current/Clinic/Child/f08_4d.dta"
childf8_vars <- c("f8lf020","f8lf021","f8ws110","f8ws111","f8ws112","f8ws115","f8003c")

childf9_location <- "/Volumes/ALSPAC-Data/Current/Clinic/Child/f09_4c.dta"
childf9_vars <- c("f9ms010","f9ms018","f9ms026","f9ms026a","f9dx135","f9003c","f9sa022","f9sa021")

childf10_location <- "/Volumes/ALSPAC-Data/Current/Clinic/Child/f10_6b.dta"
childf10_vars <- c("fdms010","fdms018","fdms026","fdms026a","fddp130","fdar118","fdar117","fd003c")

childcif_location <- "/Volumes/ALSPAC-Data/Current/Clinic/Child/cif_8b.dta"
childcif_vars <- c("cf054", "cf055", "cf056", "cf057", "cf058", "cf059","cf075","cf076","cf077","cf078",
                   "cf079","cf040","cf041","cf042","cf043","cf044","cf045","cf046","cf047","cf048","cf049",
                   "cf060","cf061","cf062","cf063","cf064","cf065","cf066","cf067","cf068","cf069","cf014",
                   "cf015", "cf016", "cf017","cf018","cf811","cf812","cf813","cf124","cf134", "cf144",
                   "cf143", "cf133", "cf123","cf018")

childsamples_location <- "/Volumes/ALSPAC-Data/Current/Other/Samples/Child/Child_bloods_4e.dta"
childsamples_vars <- c("trig_cord","Trig_CIF31", "Trig_CIF43", "TRIG_F7", "trig_f9","HDL_cord", "HDL_CIF31",
                       "HDL_CIF43", "HDL_F7", "HDL_f9","LDL_cord", "LDL_CIF31", "LDL_CIF43", "LDL_F7", "LDL_f9",
                       "chol_cord", "Chol_CIF31", "Chol_CIF43", "CHOL_F7", "CHOL_F9","Insulin_cord", 
                       "insulin_F9","CRP_cord", "CRP_f9","ApoAI_f9","ApoB_f9","IL6_f9")


## MAKE DATA FRAME OF ALL FILE LOCATIONS AND VARIABLE NAMES
df <- data.frame(locations=sapply(sort(ls()[grepl("location",ls())]),function(x) eval(parse(text=x))),
                 vars=sapply(sort(ls()[grepl("vars",ls())]),function(x) paste(eval(parse(text=x)),collapse=","))
)

## ADD ID VARIABLES
df$idvars <- "aln"
df$idvars[grepl("child|Child|kz|Cohort|Obstetric|centiles",df$location)] <-"aln,qlet"
df$allvars <- apply(df,1,function(x) paste(c(as.character(x)[3],as.character(x)[2]),collapse=","))

## CHECK FILES EXIST (NEED TO UPDATE LOCATIONS IF NOT)
useful_files <- list.files("/Volumes/ALSPAC-Data/Useful_data",full.names = TRUE,include.dirs = TRUE,recursive = TRUE)
current_files <- list.files("/Volumes/ALSPAC-Data/Current",full.names = TRUE,include.dirs = TRUE,recursive = TRUE)

all(df$locations[grep("Useful_data",df$locations)] %in% useful_files)==TRUE
all(df$locations[grep("Current",df$locations)] %in% current_files)==TRUE

## IF BOTH ABOVE LINES RETURN TRUE, READ IN DATA FROM ALSPAC
require(haven)
child_based <- apply(df[df$idvars=="aln,qlet",],1,function(x) try(read_dta(as.character(x[1]),col_select = unlist(strsplit(as.character(x[4]),split=",")))))
parent_based <- apply(df[df$idvars=="aln",],1,function(x) try(read_dta(as.character(x[1]),col_select = unlist(strsplit(as.character(x[4]),split=",")))))

## MERGE DATA FROM CHILD_BASED AND PARENT_BASED FILES
require(dplyr)
parent_df <- parent_based$mz_location #copy mz out of list
parent_based$mz_location <-NULL #remove mz from list
parent_based <-c(list(parent_df),parent_based) #add mz back in at the start of the list (because the next line will merge everything to the first dataframe, which we need to be mz)
parent_df <-  parent_based %>% purrr::reduce(left_join, by = "aln")

child_df <- child_based$kz_location #copy kz out of list
child_based$kz_location <-NULL #remove kz from list
child_based <-c(list(child_df),child_based) #add kz back in at the start of the list (because the next line will merge everything to the first dataframe, which we need to be kz)
child_df <- child_based  %>% purrr::reduce(left_join, by = c("aln","qlet"))

dat <- full_join(child_df,parent_df,by="aln")

# at this stage, we have 19982 children in dat. This matches the number in the kz file. 
# It's made up of 14676 children in the core ALSPAC sample + 5306 children from non-core pregnancies. 
# Some checks for N (all should be TRUE):

length(unique(dat$aln))==19788 #there should be 19788 pregnancies in dat (14541 pregnancies in the core ALSPAC sample + 5247 non-core pregnancies)
length(unique(dat$aln[dat$mz001%in%c(1)]))==14541 # there should be 14541 core pregnancies (mz001 is pregnancy is in core alspac sample)
sum(dat$in_core==1,na.rm=T)==14676 # there should be 14676 fetuses from core pregnancies. These are the pregnancies we're interested in, because the bolstered dataset doesn't have prospectively collected data on parents during pregnancy
sum(dat$tripquad==1,na.rm=T)==13 # there should be 13 fetuses from triplet or quadruplet pregnancies
length(unique(dat$aln[dat$mz001==1&dat$mz010==2]))==195  #there should be 195 twin pregnancies
nrow(dat[dat$kz011%in%c(1) & dat$kz001%in%c(1),])==14062 #there should be 14062 core live births (kz011==1)
nrow(dat[dat$kz011b%in%c(1) & dat$kz001%in%c(1),]) ==13988#there should be 13988 core children alive at one year (kz011b==1)

## Select core only (14676 fetuses)
dat <- dat[dat$in_core%in%c(1),]

## Remove triplets and quadruplets (4 pregnancies of 13 fetuses) as per ALSPAC instructions
dat <- dat[dat$mz010%in%c(1,2),]

## Check N now non-core and tripquads have been removed:
length(unique(dat$aln))==14468 #should be 14541 core pregnancies - 69 with no known outcome = 14472, - 4 tripquad pregnancies = 14468 pregnancies
sum(dat$in_core==1,na.rm=T)==14663 #should be 14676 fetuses from core pregnancies - 13 tripquads = 14663 fetuses

## Withdrawal of consent
# as of 29/6/2021
# dat <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno_raw.rds")
partners_woc <- c(42034,51798,52381) 
mothersquest_woc <- c(31075,32812,42568,35366,51798,38666,30484,53371,37355,40755,52237,36828,46659,46312,52177,50491,45194,52689,42034,40393,45544)
childbased_woc <- c(31075,32812,42568,35366,51798,38666,30484,53371,37355,40755,52237,36828,46659,46312,52177,50491,45194,52689,42034,40393,45544)
childcompleted_woc <- c(32778,32803,39444,53228,54074,34657,32230,47080,36194,34688,30006,47430,38685,47501,46814,38666,39400,53032,50035,30484,38831,36828,46659,50371,44307)

partners_vars <- unique(unlist(lapply(df[grep("Partner",df$locations),"vars"],strsplit,split=",")))
child_vars <- unique(c(unlist(lapply(df[grep("Child|bestgest|kz",df$locations),"vars"],strsplit,split=",")),"kz011b","kz021"))
mother_vars <- unique(unlist(lapply(df[grep("Mother|Multiple|Obstetric|mz",df$locations),"vars"],strsplit,split=",")))

dat[dat$aln %in% partners_woc,partners_vars] <- NA
dat[dat$aln %in% childbased_woc,child_vars] <- NA
dat[dat$aln %in% childcompleted_woc,child_vars] <- NA
dat[dat$aln %in% mothersquest_woc,mother_vars] <- NA

dat$partners_woc <-NA
dat$partners_woc[dat$aln %in% partners_woc] <- 1
dat$child_woc <-NA
dat$child_woc[dat$aln %in% c(childbased_woc,childcompleted_woc)] <- 1
dat$mothers_woc <-NA
dat$mothers_woc[dat$aln %in% mothersquest_woc] <- 1

## save file
saveRDS(dat,"/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno_raw.rds")

