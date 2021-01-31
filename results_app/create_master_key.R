key_alspac <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/alspac_key.rds")
key_bib <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/bib_all_key.rds")
key_mcs <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/mcs/mcs_key.rds")

master_key <- bind_rows(list(key_alspac,key_bib,key_mcs))
master_key <- master_key[duplicated(paste0(master_key$exposure,master_key$outcome))==F,]

master_key <- master_key[,1:13]

saveRDS(master_key, "/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/master_key.RDS")