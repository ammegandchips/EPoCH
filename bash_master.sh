#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=12:00:00

scriptname=echo "$scriptname"
cohort=echo "$cohort"

scriptlocation="EPoCH/scripts/${scriptname}.R"
outfile="EPoCH/out/${cohort}_${scriptname}.out"

echo $scriptlocation
echo $outfile

module add languages/R-4.0.3-gcc9.1.0

rscriptcommand="Rscript --verbose ${scriptlocation} ${cohort} > ${outfile}"

echo $rscriptcommand

eval $rscriptcommand
