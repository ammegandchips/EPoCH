cp ~/EPoCH/results/alspac_key.rds /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/
cp ~/EPoCH/results/bib_all_key.rds /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/
cp ~/EPoCH/results/bib_sa_key.rds /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/
cp ~/EPoCH/results/bib_we_key.rds /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/
cp ~/EPoCH/results/mcs_key.rds /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/

mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/results/
mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/
mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/results/
mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/meta_analysis/results/

cp ~/EPoCH/results/ALSPAC_model* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/results/
cp ~/EPoCH/results/BIB_ALL_model* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/
cp ~/EPoCH/results/BIB_SA_model* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/
cp ~/EPoCH/results/BIB_WE_model* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/results/
cp ~/EPoCH/results/MCS_model* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/results/
cp ~/EPoCH/results/meta_analysis* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/meta_analysis/

mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/data_checks/
mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/data_checks/
mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/data_checks/

cp ~/EPoCH/results/alspac_checks* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/alspac/data_checks/
cp ~/EPoCH/results/bib_checks* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/bib/data_checks/
cp ~/EPoCH/results/mcs_checks* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/mcs/data_checks/

mkdir -p /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/meta_analysis_results/

cp ~/EPoCH/results/meta* /projects/MRC-IEU/research/projects/ieu2/p5/015/working/data/meta_analysis_results/

rm ~/epoch_master*