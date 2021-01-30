mkdir -p ~/EPoCH/data/

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_all_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_sa_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_we_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno.rds ~/EPoCH/data/

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/alspac_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_all_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_sa_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_we_key.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/mcs_key.rds ~/EPoCH/data/

mkdir -p ~/EPoCH/scripts/

wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/data_prep/check_prepared_data/SUMMARISE_DATA.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/making_key/MAKE_KEY.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/phewas/RUN_PHEWAS.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/meta_analysis/RUN_META_ANALYSIS.R -P ~/EPoCH/scripts/

mkdir -p ~/EPoCH/out/
rm -r ~/EPoCH/out/*
mkdir -p ~/EPoCH/results/
rm -r ~/EPoCH/results/*

mkdir -p ~/EPoCH/for_metaanalysis/
rm -r ~/EPoCH/for_metaanalysis/*

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/results/ALSPAC_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIB_ALL_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIB_SA_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/BIB_WE_model* ~/EPoCH/for_metaanalysis/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/results/MCS_model* ~/EPoCH/for_metaanalysis/



