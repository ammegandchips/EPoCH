#!/bin/bash

#series of 3 SNPs to extract the alcohol SNPs from ALSPAC  
#Plink v1.09 is needed to run the extraction 

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

#Saves the following to script2.sh
#1. SNP List
#2. Location of the genetic data
#3. Name of the output file

module add apps/plink-1.90

./script2.sh alcohol_SNPs.txt /panfs/panasas01/shared/alspac/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/1000genomes/released/2015-10-30/data/derived/filtered/bestguess/maf0.01_info0.8/data_chrCHR alcohol \
> ${now}_script2_sh.out 2> ${now}_script2_sh.error


