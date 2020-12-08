#!/bin/bash
#
#
#PBS -l nodes=1:ppn=1,walltime=12:00:00

cohort = echo "$cohort" 
script = echo "~/EPoCH/scripts/$script"
outfile = echo "~/EPoCH/out/$cohort$script.out"

module add languages/R-4.0.3-gcc9.1.0

Rscript --verbose script cohort > outfile
