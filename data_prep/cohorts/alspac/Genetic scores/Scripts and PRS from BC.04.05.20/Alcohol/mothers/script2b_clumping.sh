
#!bin/bash

#################################################
#only needed for qsub'd runs
#set time 
#PBS -l nodes=1:ppn=1,walltime=8:00:00

#Define working directory 
export WORK_DIR=$HOME/epoch/alcohol/mothers

#Change into working directory 
cd $WORK_DIR

#store the date
now=$(date +"%Y%m%d")

#################################################


plink --bfile alcohol --indep-pairwise 50 5 0.2  --out alcohol_clumped



