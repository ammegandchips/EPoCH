
#!bin/bash

#################################################
#only needed for qsub'd runs
#set time 
#PBS -l nodes=1:ppn=1,walltime=8:00:00

#Define working directory 
export WORK_DIR=$HOME/epoch/smoking/smoking_age_init

#Change into working directory 
cd $WORK_DIR

#store the date
now=$(date +"%Y%m%d")

#################################################


plink --bfile smoking_age_init --indep-pairwise 50 5 0.2  --out smoking_age_init_clumped



