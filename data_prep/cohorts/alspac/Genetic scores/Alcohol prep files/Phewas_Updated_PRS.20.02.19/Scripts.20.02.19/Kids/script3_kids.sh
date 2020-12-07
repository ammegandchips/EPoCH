
#!bin/bash

#################################################
#only needed for qsub'd runs
#set time 
#PBS -l nodes=1:ppn=1,walltime=8:00:00

#Define working directory 
export WORK_DIR=$HOME/phewas/kids

#Change into working directory 
cd $WORK_DIR

#store the date
now=$(date +"%Y%m%d")

#################################################

module add apps/plink-1.90


plink -bfile alcohol -extract alcohol_SNPs.txt -recode compound-genotypes \
		--keep /panfs/panasas01/shared/alspac/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/1000genomes/released/2015-10-30/data/derived/unrelated_ids/children/inclusion_list.txt \
		--remove /panfs/panasas01/shared/alspac/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/1000genomes/released/2015-10-30/data/derived/unrelated_ids/children/exclusion_list.txt \
             --out alcohol_children_excluded

