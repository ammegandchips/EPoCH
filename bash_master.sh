#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=12:00:00

script=echo "$script"
cohort=echo "$cohort"

echo $script
echo $cohort

scriptlocation="~/EPoCH/scripts/${script}.R"
outfile="~/EPoCH/out/${cohort}_${script}.out"

echo $scriptlocation
echo $outfile

module add languages/R-4.0.3-gcc9.1.0

echo "Rscript --verbose $scriptlocation $cohort > $outfile"
