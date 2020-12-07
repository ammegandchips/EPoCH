#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=12:00:00

module add languages/R-4.0.3-gcc9.1.0

mkdir -p ~/EPoCH/data/

mkdir -p ~/EPoCH/scripts/

mkdir -p ~/EPoCH/out/

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds ~/EPoCH/data/

wget --no-check-certificate --content-disposition https://github.com/ammegandchips/EPoCH/blob/main/making_key/MAKE_KEY.R

curl -LJO https://github.com/ammegandchips/EPoCH/blob/main/making_key/MAKE_KEY.R

R CMD BATCH --no-save --no-restore '--args ALSPAC' ~/EPoCH/scripts/MAKE_KEY.R ~/EPoCH/out/ALSPAC_MAKE_KEY.out

cp ~/EPoCH/data/* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/