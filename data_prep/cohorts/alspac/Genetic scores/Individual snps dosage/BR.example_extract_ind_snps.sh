#PBS -N extractdata
#PBS -o alspac_bmi_snp_extract
#PBS -e alspac_bmi_snp_extract_error
#PBS -l walltime=24:00:00
#PBS -l nodes=1:ppn=4
#PBS -S /bin/bash
#---------------------------------------------

module load apps/qctool-1.4

cd /panfs/panasas01/sscm/eprcr/ALSPAC/BMI_SNPs 
datadir="/panfs/panasas01/dedicated-mrcieu/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/hrc/released/2017-05-04/data/bgen"
dir="/panfs/panasas01/sscm/eprcr/ALSPAC/BMI_SNPs"
dirx="/panfs/panasas01/dedicated-mrcieu/studies/latest/alspac/genetic/variants/arrays/gwas/imputed/hrc/released/2017-05-04/data/bgen"
dirs="/panfs/panasas01/sscm/eprcr/ALSPAC"

#Extract ALSPAC dosage data for BMI SNPs 

for i in {01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22};do
    qctool -g ${datadir}/data_${i}.bgen -og ${dir}/${i}_snp.dosage.gen -s ${dirx}/data.sample -incl-rsids ${dirs}/BMI.txt
done

rm  ${dir}/snps-out.gen
touch ${dir}/snps-out.gen
for i in {01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22};do
  cat ${dir}/${i}_snp.dosage.gen >> ${dir}/snps-out.gen
done
