# The EPoCH study

Exploring Prenatal influences on Childhood Health

![](https://cpb-eu-w2.wpmucdn.com/blogs.bristol.ac.uk/dist/c/500/files/2018/11/Untitled-26hzp4l.png)

The Exploring Prenatal influences on Childhood Health, or EPoCH project, investigates how parents’ lifestyles in the important prenatal period might affect the health of their children.

The main analysts for the EPoCH study are Gemma Sharp (PI) and Kayleigh Easey who both work at the University of Bristol’s MRC Integrative Epidemiology Unit.

Please check out the EPoCH website for more information: https://epoch.blogs.bristol.ac.uk

## EPoCH involves four main stages:

### 1. Data harmonisation and preparation

Preparing and harmonising data between the main EPoCH cohorts: ALSPAC, Born in Bradford, Millenium Cohort Study, MoBa, the Cleft Collective.

And the replication cohorts: Generation R, Danish National Birth Cohort.

Code for this stage is found in the [data_prep folder](https://github.com/ammegandchips/EPoCH/tree/main/data_prep).

The prepared data is summarised to check for strange distributions etc using code found in the [data_prep/check_prepared_data folder](https://github.com/ammegandchips/EPoCH/tree/main/data_prep/check_prepared_data).

### 2. Running pheWAS analyses in each cohort

For each cohort, we run multivariable regression analyses of the association between all combinations of exposures and outcomes. What we end up with is a sort of mini phenome-wide association study (pheWAS) for each exposure of interest.

This stage involves:

* Making a pheWAS "key" to describe the covariates that should be adjusted for for each combination of exposure and outcome. The code for this is found in the [making_key folder](https://github.com/ammegandchips/EPoCH/tree/main/making_key).
* Running the pheWAS. The code for this is found in the [phewas folder](https://github.com/ammegandchips/EPoCH/tree/main/phewas).

### 3. Meta-analysing the pheWAS results from each cohort

We meta-analyse the pheWAS results from each cohort together. The code for this stage is found in the [meta_analysis folder](https://github.com/ammegandchips/EPoCH/tree/main/meta_analysis).

### 4. Interpreting results

For the main exposures (usually basic definitions of exposures during pregnancy and/or polygenic risk scores for these behaviours), we use the full pheWAS results. For more nuanced/detailed exposures (e.g. trimester-specific exposures, caffeine from different sources, different doses of alcohol, etc), we only consider results that reach a threshold in the pheWASs of main exposures.

We conduct parental exposure negative control comparisons, mendelian randomization and cross-context analyses to triangulate evidence and attempt to infer causal effects.

## The EPoCH pipeline

Most stages in EPoCH (all except cohort-specific data preparation) can be run using a single bash script (`bash_master.sh`), which takes two arguments: `cohort` and `scriptname`. Before and after running this script (as a job on bluecrystal), it is necessary to run two other scripts (`before.sh` and `after.sh`). This is explained in the file [Pipeline.md](https://github.com/ammegandchips/EPoCH/blob/main/Pipeline.md).










