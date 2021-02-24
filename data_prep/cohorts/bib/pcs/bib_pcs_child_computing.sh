#!/bin/bash
#
#
#PBS -l nodes=1:ppn=8,walltime=12:00:00

### script to prepare genetic PCA for pregnancies ###

module load apps/plink-1.90


# identify correlated snps
plink --bfile /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bibsnp/bibgenodata/data \
--keep /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/child_geno_ids.fam \
--maf 0.01 \
--indep-pairwise 50 5 0.2 \
--out /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released_uncorrelated

# identify related samples
plink --bfile /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bibsnp/bibgenodata/data \
--keep /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/child_geno_ids.fam \
--genome gz \
--out /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released \
--extract /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released_uncorrelated.prune.in

# make exclusion list (excluding identicals/duplicates, first & second degree relatives)
# excluded n=
zcat /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released.genome.gz | \
awk 'NR > 1 && $10 > 0.2 {print $3}' | \
sort -u | awk '{print $1" 1"}' \
> /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released_ibd.genome.exclusions.uniq.txt

# PCA of BiB pregnancies - child
plink --bfile /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bibsnp/bibgenodata/data \
--extract /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released_uncorrelated.prune.in \
--remove /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released_ibd.genome.exclusions.uniq.txt \
--keep /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/child_geno_ids.fam \
--pca header tabs var-wts \
--out /newhome/kt17109/metabolon_CHD_project/bib_metabolites_chd/bib_pca/child/directly_genotyped_released_pca
