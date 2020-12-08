mkdir -p ~/EPoCH/data/

cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/alspac_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/bib_pheno.rds ~/EPoCH/data/
cp /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/mcs_pheno.rds ~/EPoCH/data/

mkdir -p ~/EPoCH/scripts/

rm -r ~/EPoCH/scripts/*

wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/data_prep/check_prepared_data/SUMMARISE_DATA.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/making_key/MAKE_KEY.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/phewas/RUN_PHEWAS.R -P ~/EPoCH/scripts/
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/meta_analysis/RUN_META_ANALYSIS.R -P ~/EPoCH/scripts/

mkdir -p ~/EPoCH/out/
