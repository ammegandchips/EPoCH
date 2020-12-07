# Wiki set up info:
Paths to phenotypic data

data/durable/data/MoBaPhenoData
/cluster/projects/p471/data/MoBaPhenoData
Paths to genotypic data

data/durable/data/genetic/qcd_genetic_data
/cluster/projects/p471/data/genetic_data/qcd_genetic/data
Template scripts for calculating polygenic scores

/cluster/projects/p471/common/prs_scripts
Template script for post-processing of polygenic score data

data/durable/common/prs_processing
Template script for merging datasets across the years

data/durable/common/new_project_template/scripts/01_data_prep.R
Template script for merging phenotypic and genotypic data

data/durable/common/new_project_template/scripts/example_merge_script_MoBa_pheno_geno

# moba genetic data - wiki instructions
Currently, in p471 we are running our analyses on a subset of available MoBa genotype data, 
comprising samples in the HARVEST and Rotterdam1 genotyping batches (batch specific descriptions of
MoBa genotyping are here. In p471 referred to as the Harvest-Njølstad data. Please see the QC 
description for this data by Elizabeth Corfield and Laurie Hannigan, based on information from the 
HARVEST QC documentation and post-imputation QC undertaken in-house.

The file relatedness_exclusion_flag_list.txt in the qcd_genetic_data folder should be used to 
restrict to unrelated individuals (pi_hat>0.15) if your analysis requires this. This file has 
columns flagging exclusions for analyses using (respectively):
  
  Only data from parents
Only data from mothers
Only data from fathers
Only data from children
Data from mother-offspring pairs
Data from father-offspring pairs
Data from entire trios
Exclude individuals flagged in the column most appropriate to your analysis to minimise the number of total exclusions. The exclusions file is created by the R script 02_create_flaglist_relatedness_exclusions.R in the data/durable/common/genotype_metadata Rproject. You can see the rules for exclusions there, but in summary:
  
  One member of each parent gen sibling/half-sibling pair is excluded at random, but prioritising those with more complete trio data available
One member of each child gen sibling/half-sibling pair is excluded, prioritising first those with more complete trio data available, then those born earlier (or at random if this information is not available)
One member of each avuncular pairing is excluded at random, but with rules to maximise complete family duos and trios
Example code for using the exclusions file to restrict to unrelated children (for an analysis using only the child generation data) is below:
  
  
##################################################################################
##Load required packages

require('tidyverse')

##Read in exclusions list and retain only individuals not flagged for exclusion in a children-only analysis

incl <- read.table("data/durable/data/genetic/qcd_genetic_data/relatedness_exclusion_flag_list.txt", header = T) %>%
  filter(children_only_analysis==0)

##Read in geno-pheno ID linkage file and restrict to non-excluded children

ids <- read.table("data/durable/data/Linkage files/core_IDS&covars_hrv_njl_v2.txt", header = T) %>%
  filter(IID %in% incl$IID,
         Role == "Child)    
##################################################################################
If you want to retain the related individuals and account for relatedness using, for example, a clustering-based approach, there is a file listing the relationships in the qcd_genetic_data folders called related_core_final.txt.

         2) Account for population structure and batch effects
         
         Batch and 10 principal components are included as covariates in the ID linkage file (core_IDs&covars_hrv_njl_v2.txt) located at data/durable/data/Linkage files (more details on using this file for linkage to phenotypic data below below). These should be incorporated into analyses or their effects regressed out of polygenic scores (an example script for doing this with PRSice generated scores is available at data/durable/common/prs_processing).
         
         If you are new to genomic analyses, see Background to genetic techniques for a list of papers which can serve as an introductory to key techniques such as genome-wide association studies (GWAS) and polygenic scores (PGS).
         
         Calculating polygenic scores
         If your project involves polygenic scores, we recommend that you create these scores yourself (or with your PsychGen collaborators), even when versions of the scores you want are already available in the data/durable/common/polygenic_scores directory. This is because there are analytic decisions involved right from the start of the polygenic score creation process. You can adapt scripts based on our standard PsychGen PRSice scripts available on the cluster.
         
         Relevant paths for creating your own polygenic scores based on PsychGen standards are detailed below:
         
         A directory of polygenic scores already created by MoBa researchers lives at data/durable/common/polygenic_scores
         Summary statistics for creating the polygenic scores are stored on the cluster at common/gwas_sumstat
         Supporting information detailing the summary statistics used for creating each of the polygenic scores as well as the name of the script used to create each score lives at durable\common\prs_processing\scripts\supporting
         Scripts that run on the cluster for making the polygenic scores live at durable\common\prs_processing\scripts\bash
         Polygenic score scripts are also available as .sh files on the cluster at common\prs_scripts
         The computed raw scores are available on the cluster at common\raw_prsice_output
         The calculated raw polygenic scores are then copied to durable\common\prs_processing\data\colossus_scores In this same folder you will find the covariates (10 PCs)
         A script to process all polygenic scores at once lives at durable\common\prs_processing\scipts\R\01_process_all_scores
         In order to calculate polygenic scores we recommend you take some time to read some of the documentation provided in Appendix 2. Details about the command line and modifiable portions of template PRSice scripts are available here. Polygenic scores can also be created with other software, but in some cases you will need to install this on the cluster yourself or with the help of TSD admin.
         
         Merging phenotypic and genotypic data
         The scripts folder in the new project template (described here) contains an example script for merging genetic and phenotypic data for analyses. This is necessary because the IDs used for each are different and can only be linked using a specific ID linkage file (the filepath to which is included in the script and in Useful files).
         
         Availability of genotype data for the remainder of MoBa
         In PsychGen, Elizabeth Corfield is responsible for the QC and imputation. She is working with Tetyana Zayats to finish QC and imputation of the October 2019 genotype data release (N=98,000). Your PsychGen contact person should update you on the progress and timeline for this. Details of further MoBa genotyping (which is ongoing) and genotype data availability will be updated when new releases are made.
         
         Full details about genotyping in MoBa are available on GitHub here. See the README for the link to the MoBa Genetics slack channel.