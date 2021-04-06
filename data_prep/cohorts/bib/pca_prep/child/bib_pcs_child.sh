#!/bin/bash
#
#
#PBS -l nodes=1:ppn=8,walltime=12:00:00

### script to prepare genetic PCA for pregnancies ###

module load apps/plink-1.90


# identify correlated snps
plink --bfile $HOME/bib_genetic_data/ \
--keep /newhome/ke14426/epoch/bib/pca/child/child_geno_ids.fam \
--maf 0.01 \
--indep-pairwise 50 5 0.2 \
--out /newhome/ke14426/epoch/bib/pca/child/directly_genotyped_released_uncorrelated

# identify related samples
plink --bfile $HOME/bib_genetic_data/ \
--keep /newhome/ke14426/epoch/bib/pca/child/child_geno_ids.fam \
--genome gz \
--out /ke14426/epoch/bib/pca/child/directly_genotyped_released \
--extract /ke14426/epoch/bib/pca/child/directly_genotyped_released_uncorrelated.prune.in

# make exclusion list (excluding identicals/duplicates, first & second degree relatives)
# excluded n=
zcat /ke14426/epoch/bib/pca/child/directly_genotyped_released.genome.gz | \
awk 'NR > 1 && $10 > 0.2 {print $3}' | \
sort -u | awk '{print $1" 1"}' \
> /ke14426/epoch/bib/pca/child/directly_genotyped_released_ibd.genome.exclusions.uniq.txt

# PCA of BiB pregnancies - child
plink --bfile $HOME/bib_genetic_data/ \
--extract /ke14426/epoch/bib/pca/child/directly_genotyped_released_uncorrelated.prune.in \
--remove /ke14426/epoch/bib/pca/child/directly_genotyped_released_ibd.genome.exclusions.uniq.txt \
--keep /ke14426/epoch/bib/pca/child/child_geno_ids.fam \
--pca header tabs var-wts \
--out /ke14426/epoch/bib/pca/child/directly_genotyped_released_pca
