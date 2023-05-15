#!/bin/bash

#SBATCH --partition=gpu_short
#SBATCH --gres=gpu:2
#SBATCH --job-name=epoch_master
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=6:0:0
#SBATCH --mem=2000M
#SBATCH --account=SSCM023123

echo 'epoch_master'
hostname

cohortORmodel=${1}
scriptname=${2}

echo $cohortORmodel
echo $scriptname

scriptlocation="~/EPoCH/scripts/$scriptname.R"
outfile="~/EPoCH/out/$cohortORmodel$scriptname.out"

echo $scriptlocation
echo $outfile

module add lang/r/4.1.2-bioconductor-gcc

rscriptcommand="Rscript --verbose $scriptlocation $cohortORmodel >> $outfile 2>&1"

echo $rscriptcommand

eval $rscriptcommand

