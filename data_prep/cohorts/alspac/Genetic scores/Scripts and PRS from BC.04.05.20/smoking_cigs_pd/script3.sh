
#!bin/bash

#################################################
#only needed for qsub'd runs
#set time 
#PBS -l nodes=1:ppn=1,walltime=8:00:00

#Define working directory 
export WORK_DIR=$HOME/epoch/smoking/smoking_cigs_pd

#Change into working directory 
cd $WORK_DIR

#store the date
now=$(date +"%Y%m%d")

#################################################

module add apps/plink-1.90



plink -bfile smoking_cigs_pd -extract smoking_cigs_pd_clumped.prune.in -recode compound-genotypes \
		--keep /panfs/panasas01/shared/alspac/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/1000genomes/released/2015-10-30/data/derived/unrelated_ids/mothers/inclusion_list.txt \
		--remove /panfs/panasas01/shared/alspac/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/1000genomes/released/2015-10-30/data/derived/unrelated_ids/mothers/exclusion_list.txt \
             --out smoking_cigs_pd_mothers_excluded

