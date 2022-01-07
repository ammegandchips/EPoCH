#!/bin/bash

#SBATCH --partition=gpu_short
#SBATCH --gres=gpu:2
#SBATCH --job-name=epoch_master
#SBATCH --output=epoch_master_out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -mem=2000M
#SBATCH --time=06:00:00

echo 'epoch_master'
hostname

scriptname=echo "$scriptname"
cohort=echo "$cohortORmodel"

scriptlocation="~/EPoCH/scripts/${scriptname}.R"
outfile="~/EPoCH/out/${cohortORmodel}_${scriptname}.out"

echo $scriptlocation
echo $outfile

module add lang/r/4.0.3-bioconductor-gcc

rscriptcommand="Rscript --verbose ${scriptlocation} ${cohortORmodel} >> ${outfile} 2>&1"

echo $rscriptcommand

eval $rscriptcommand

