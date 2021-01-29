#!/bin/bash

#PBS -N bash_master
#PBS -l select=1:ncpus=1:mem=100M
#PBS -l walltime=06:00:00


scriptname=echo "$scriptname"
cohort=echo "$cohort"

scriptlocation="~/EPoCH/scripts/${scriptname}.R"
outfile="~/EPoCH/out/${cohort}_${scriptname}.out"

echo $scriptlocation
echo $outfile

module add lang/r/4.0.3-bioconductor-gcc

rscriptcommand="Rscript --verbose ${scriptlocation} ${cohort} >> ${outfile} 2>&1"

echo $rscriptcommand

eval $rscriptcommand
