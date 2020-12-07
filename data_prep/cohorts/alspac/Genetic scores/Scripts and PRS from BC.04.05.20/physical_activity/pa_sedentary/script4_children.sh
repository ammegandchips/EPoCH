#program to generate genomewide score profiles based on SNP beta values 
#Plink v1.09 is needed to run the extractsnps.sh script called in this program 


#!bin/bash

#################################################
#only needed for qsub'd runs
#set time 
#PBS -l nodes=1:ppn=1,walltime=8:00:00

#Define working directory 
export WORK_DIR=$HOME/epoch/physical_activity/pa_sedentary
#Change into working directory 
cd $WORK_DIR

#store the date
now=$(date +"%Y%m%d")

#################################################

module add apps/plink-1.90


#generate scores
 plink --file pa_sedentary_children_excluded \
 		--noweb \
 		--score /panfs/panasas01/psyc/ke14426/epoch/physical_activity/pa_sedentary/pa_sedentary_betas.txt \
 		no-mean-imputation \
 		--out ${now}_scores_pa_sedentary_children


