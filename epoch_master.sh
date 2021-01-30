#!/bin/bash

#PBS -N epoch_master
#PBS -o epoch_master_out
#PBS -l select=1:ncpus=1:mem=2000M
#PBS -l walltime=06:0:00

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

