# The EPoCH study

Exploring Prenatal influences on Childhood Health

![](https://cpb-eu-w2.wpmucdn.com/blogs.bristol.ac.uk/dist/c/500/files/2018/11/Untitled-26hzp4l.png)

The Exploring Prenatal influences on Childhood Health, or EPoCH project, investigates how parents’ lifestyles in the important prenatal period might affect the health of their children.

The main analysts for the EPoCH study are Gemma Sharp (PI) and Kayleigh Easey who both work at the University of Bristol’s MRC Integrative Epidemiology Unit.

Please check out the EPoCH website for more information: https://epoch.blogs.bristol.ac.uk

## EPoCH involves three main stages:

### 1. Data preparation and summarising stage

Preparing and harmonising data between the main EPoCH cohorts: ALSPAC, Born in Bradford, Millenium Cohort Study, MoBa, the Cleft Collective.

And the replication cohorts: Generation R, Danish National Birth Cohort.

Code for this stage is found in the [data_prep folder](https://github.com/ammegandchips/EPoCH/tree/main/data_prep).

The prepared data is summarised to check for strange distributions etc using code found in the [data_prep/check_prepared_data folder](https://github.com/ammegandchips/EPoCH/tree/main/data_prep/check_prepared_data).

### 2. Hypothesis-generating stage: the PheWAS approach

For each cohort, we run multivariable regression analyses of the association between all combinations of exposures and outcomes. What we end up with is a sort of mini phenome-wide association study (pheWAS) for each exposure of interest.

This stage involves:

* Making a pheWAS "key" to describe the covariates that should be adjusted for for each combination of exposure and outcome. The code for this is found in the [making_key folder](https://github.com/ammegandchips/EPoCH/tree/main/making_key).
* Running the pheWAS. The code for this is found in the [phewas folder](https://github.com/ammegandchips/EPoCH/tree/main/phewas).
* Meta-analysing the pheWAS results from each cohort.
	* We meta-analyse the pheWAS results from each cohort together. The code for this stage is found in the [meta_analysis folder](https://github.com/ammegandchips/EPoCH/tree/main/meta_analysis).

### 3. Hypothesis-testing stage

We conduct parental exposure negative control comparisons, mendelian randomization and cross-context analyses to triangulate evidence and attempt to infer causal effects.

## Where to find more information

The full analysis plan is provided in this repository (https://github.com/ammegandchips/EPoCH/blob/main/analysis_plan/analysis_plan.md).

The [EPoCH website](https://epoch.blogs.bristol.ac.uk) also has some additional information. 

