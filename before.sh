mkdir -p ~/EPoCH/data/

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bibsa/bibsa_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bibwe/bibwe_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno.rds ~/EPoCH/data/

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/alspac_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bibsa/bibsa_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bibwe/bibwe_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/mcs_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/moba/moba_key.rds ~/EPoCH/data/

mkdir -p ~/EPoCH/scripts/

wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/data_prep/check_prepared_data/SUMMARISE_DATA.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/making_key/MAKE_KEY.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/phewas/RUN_PHEWAS.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/phewas/RUN_PHEWAS_SUMMARIES_ONLY.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/meta_analysis/RUN_META_ANALYSIS.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/cohort_qc/COHORT_QC.R -P ~/EPoCH/scripts/

mkdir -p ~/EPoCH/out/
rm -r ~/EPoCH/out/*
mkdir -p ~/EPoCH/results/
rm -r ~/EPoCH/results/*

mkdir -p ~/EPoCH/for_metaanalysis/
rm -r ~/EPoCH/for_metaanalysis/*

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/moba/results/MOBA_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/results/ALSPAC_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIB_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIBSA_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIBWE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/results/MCS_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/moba/results/MOBA_FEMALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/results/ALSPAC_FEMALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIB_FEMALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/results/MCS_FEMALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/moba/results/MOBA_MALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/results/ALSPAC_MALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIB_MALE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/results/MCS_MALE_model* ~/EPoCH/for_metaanalysis/



