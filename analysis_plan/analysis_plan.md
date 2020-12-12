# EPoCH analysis plan

![](https://cpb-eu-w2.wpmucdn.com/blogs.bristol.ac.uk/dist/c/500/files/2018/11/Untitled-26hzp4l.png)

## Background

We urgently need better evidence about how our experiences before birth might influence our long-term health. Most research in this area has focused on the lifestyles of pregnant mothers, but the evidence is patchy and health advice offered to pregnant women can be confusing and inconsistent. More recent research suggests that a father's behaviour can influence the health of his unborn children, but very little public health advice is currently offered to fathers-to-be. EPoCH is addressing the urgent need for better quality scientific evidence on how the health behaviours of both mums and dads in the prenatal period might affect the health of their children. We aim to contextualise the effects of these individual behaviours relative to the effects of the social determinants of health.

The project can be split into three main stages: a data preparation and summarising stage, a hypothesis-generating stage and a hypothesis-testing stage.

## 1. Data preparation and summarising stage

We are using data from multiple European cohorts:

* In the hypothesis-generating pheWAS stage:
	* ALSPAC
	* Millenium Cohort Study
	* MoBa
	* Born in Bradford

* In the hypothesis-testing replication stage:
	* GenerationR
	* DNBC

* In its own paper(s):
	* Cleft Collective

### Data preparation

We created harmonised variables for each exposure, outcome and covariate (not an easy task and very time consuming... scheduled for the entire first year of the project :wink:). The process is described in the ALSPAC, BiB and MCS data prep HTML files (knitted from Rmd). Basically, we had a good idea of the general concepts we wanted to capture (e.g. "smoking in the first trimester") and then were led by the data in terms of how these could be defined (e.g. ordinal categories).

A list of all exposures and outcomes can be found in separate files.

Exposures are broadly grouped into the following classes (we intend to write separate papers for each):

* Smoking
* Alcohol consumption
* Caffeine consumption
* Physical activity
* Mediterranean diet
* Vegetarian diet

Outcomes are broadly grouped into the following domains:

* Anthropometry/adiposity:
* Psychosocial
* Immunological
* Cardiometabolic

Outcomes are measured during the following stages. Where there are multiple measures within one of these stages, we have taken the oldest available measure:

* At birth or in first year of life (>0 to <1)
* Childhood stage 1 (around age 2; >=1 to <3)
* Childhood stage 2 (around age 4; >=3 to <5)
* Childhood stage 3 (around age 6; >=5 to <8)
* Childhood stage 4 (around age 9; >=8 to <11)

Within each cohort, we perform checks on the data (to check for weird distributions etc). Through this, we can identify any potential coding errors in the data preparation scripts and address these. These data checks are performed using the SUMMARISE_DATA.R script. It produces barcharts summarising counts of categorical variables and histograms of continuous variables. It also produces tables summarising counts, means, ranges, etc.

### Summarise the relationship between different exposures

* Summarise concordance between maternal and paternal behaviours
* Summarise concordance between different health behaviours (observationally and using PRS)
* Summarise concordance of the same health behaviour at different timepoints
* Summarise associations between polygenic risk scores (PRS) and health behaviours

### Create a 'key'

For each cohort, we create a pheWAS "key" to translate the variable names to more understandable terms (for graphs etc) and to describe the covariates that should be adjusted for for each combination of exposure and outcome and each model. The code for this is found in the [making_key folder](https://github.com/ammegandchips/EPoCH/tree/main/making_key).

## 2. Hypothesis-generating stage: the PheWAS approach

We are exploring prenatal influences on childhood health using a semi-hypothesis-free Phenome-Wide Association Study (PheWAS) approach. PheWAS analyse many phenotypic outcomes in relation to a single exposure or genetic variant/score. They allow researchers to identify a subset of outcomes that may be (causally) related to an exposure. The approach can be applied to any richly phenotyped dataset. 

We are conducting two sets of PheWAS (observational and Mendelian randomization; MR) using individual cohort data to explore a wide range of offspring health outcomes in relation to parental health behaviours in the prenatal period.

The pheWASs are conducted using data from four European birth cohorts:

* ALSPAC
* Millenium Cohort Study
* MoBa
* Born in Bradford

PheWAS summary statistics will be compared between cohorts and meta-analysed to improve power.

The hypothesis-generating stage can be split into the following steps:

### Run pheWAS

**Research question: What offspring health outcomes are observationally associated with parental health behaviours during pregnancy?**

**Research question: What offspring health outcomes are potentially causally associated with parental health behaviours during pregnancy?**

In this pheWAS stage, we use a simple definition of each (observational) health behaviour: the most simple definition measured at any point *during pregnancy*. The reason for specifying *during pregnancy* is that this is the most commonly studied stage and the stage when women are given health advice. Pre-conception data is available for only one or two cohorts, and is collected retrospectively and on fewer health behaviours. By contrast, most cohorts have data for mothers and fathers referring to at least one timepoint during pregnancy. Furthermore, in pregnancy, maternal health behaviours could influence fetal health/development via direct intrauterine mechanisms. Although no direct effect of paternal behaviours is possible during pregnancy (except via secondhand smoke), paternal behaviours in pregnancy are likely to correlate with pre-conception behaviours (when direct effects via the germline are possible), so can be used as a proxy.

* Maternal and paternal smoking at any point during pregnancy (binary: any vs none)
* Maternal and paternal alcohol consumption at any point during pregnancy (binary: any vs none)
* Maternal and paternal caffeine consumption at any point during pregnancy (continuous: mg/day)
* Maternal and paternal physical activity at any point during pregnancy (ordinal: very active vs somewhat vs inactive)
* Maternal and paternal mediterranean diet at any point during pregnancy (continuous index: zscore)
* Maternal and paternal vegetarian diet at any point during pregnancy (continuous index: zscore)
* Maternal and paternal polygenic risk score for smoking (continuous score)
* Maternal and paternal polygenic risk score for alcohol (continuous score)
* Maternal and paternal polygenic risk score for caffeine (continuous score)
* Maternal and paternal polygenic risk score for physical activity (continuous score)

Where the exposure is a PRS, we select the SNPs using those identified in the GSCAN consortium for smoking and alcohol. **KAYLEIGH TO ADD DETAIL HERE**

We also use very simple model for the pheWAS:

**Model 1a**

* Observational pheWAS: adjusted for child's sex and age at outcome where necessary (e.g. we would adjust for age at outcome if outcome was BMI in the second stage of childhood, but not if the outcome was birthweight)
* MR pheWAS: adjusted for child's sex and exposed parent's genetic PCs for ancestry

**Model 1b**

* Observational pheWAS: as for Model 1a but with additional adjustment for the health behaviour in the other parent
* MR pheWAS: as for Model 1a but with additional adjustment for child's PRS and child's genetic PCs for ancestry

We use logistic regression (glm, family="binomial") for binary outcomes and linear regression (lm) for continuous outcomes.

*For practical reasons, we actually just run a pheWAS of **every** exposure we consider (so, trimester-specific exposures, pre-conception exposures, caffeine from tea/coffee/cola, etc) using all models (i.e. models 1a/1b/2a/2b/3a/3b/4a/4b). We don't use the full results of these pheWAS though; we just extract what we need in the hypothesis-testing stage.*

The code for runnng all pheWASs is found in the [phewas folder](https://github.com/ammegandchips/EPoCH/tree/main/phewas).

### Meta-analyse pheWAS results

We conduct a fixed effects meta-analysis of all observational and MR pheWAS results across all cohorts. We choose fixed-effects as all cohorts are of European origin and we therefore assume they are estimating effects from the same underlying populations. 

Inter-study heterogeneity is assessed using the I^2 statistic, leave-one-out sensitivity analyses and by generating and observing forest plots.

The code for this is found in the [meta_analysis folder](https://github.com/ammegandchips/EPoCH/tree/main/meta_analysis).

## 3. Hypothesis-testing stage

Exposure-outcome associations that exceed a pre-defined p-value threshold in the meta-analysis results from the hypothesis generating pheWASs will be taken forward for the further analyses outlined below.

**Research question: Are associations robust to adjustment for potential confounding factors?**

Directed Acyclic Graphs (DAGs) were used to select the covariates for adjustment.

**Model 2a**

* As Model 1a but with additional adjustment for exposed parent's age, SEP, (parity if exposed parent is mother), correlated health behaviours (in the current and previous timepoints where exposures are time-specific).

**Model 2b**

* As Model 1b but with additional adjustment for the other parent's age, SEP, and correlated health behaviours in previous timepoints IF they can have a direct effect (or via secondhandsmoke) on fetal development. 

**Model 3a**

* As Model 2a but with additional adjustment for exposed parent's health issue IF the exposure can plausibly be influenced by the health issue AND the outcome is the same/a similar health issue (e.g. adjust for parents' asthma if exposure is smoking and outcome is child's asthma).

**Model 3b**

* As Model 2b but with additional adjustment for both parents' health issues in the same circumstances as described for Model 3a.

**Model 4a**

* As Model 3a, with additional adjustment for potential mediators:

	* Gestational age at birth (if outcome is not LGA/SGA)
	* Birthweight (if outcome is something to do with body size after birth)
	* Child's passive smoking before age 2 (if exposure is parental smoking)
	* Child's caffeine consumption before age 2 (if exposure is parent's caffeine consumption)
	* Child's alcohol consumption before age 2 (if exposure is parent's alcohol consumption)

**Model 4b**

* As Model 3b, with additional adjustment for potential mediators as defined above

**Research question: Is there evidence of potentially causal independent effects of the maternal/paternal exposure (i.e. after mutual adjustment, is there still evidence of a maternal/paternal association?)**

Comparison of maternal and paternal effect estimates from pheWAS meta-analyses to assess relative size of maternal vs paternal effect. This can offer causal insights because if maternal and paternal exposures causally influence offspring outcomes, it is likely to be by different mechanisms, but with similar (shared environmental) confounders (i.e., the other parent’s exposure can be used as a **negative control**).

* Effects will be compared visually by plotting the maternal effect with 95% CIs alongside the paternal effect with 95% CIs. 
* We will also calculate the difference in effect estimates (log odds or mean difference) and compare to the null hypothesis of zero difference.

**Research question: Are the identified associations from the MR-pheWAS robust when assesed formally using MR?**

We will conduct formal MR analyses and conduct sensitivity analyses to assess whether the assumptions are being fulfilled.

**Research question: Does timing of exposure matter?**

We will compare estimates generated using exposure variables at different timepoints: pre-conception, at each trimester during pregnancy, and postnatally. These estimates are generated using linear or logistic regression (depending on the outcome) and all models, but our focus will be on Models 2a and 2b.

**Research question: Does the estimated effect increase with increasing doses of the exposure?**

Where we have been able to derive ordinal and/or continuous variables, we are able to explore the "dose" of the exposure. These estimates are generated using linear or logistic regression (depending on the outcome) and all models, but our focus will be on Models 2a and 2b. We will plot results and observe whether effect estimates show an increasing trend with increasing doses.

**Research question: Are there sex-specific effects?**

**Research question: Does stratifying by parental exposure help to reduce residual confounding?**

Sensitivity analyses: We will conduct additional observational analyses: a) stratified by sex, and b) stratified by other parent's exposure (e.g. maternal smoking on offspring outcomes when fathers do/don't smoke).

**Research question: Do the results replicate in an independent sample?**

Generation R and the DNBC will be used to replicate findings. Once we have a list of exposures/outcomes to assess, we will approach both cohorts to request data access.

**Research question: Considering all the evidence, are the identified associations between maternal/paternal health behaviours and offspring health likely to be causal?**

Qualitative triangulation of findings from the observational pheWAS, MR pheWAS (and formal MR and sensitivity analyses), replication analysis, timing/dose analyses, cross-cohort comparisons.

**Research question: (How) do maternal and paternal prenatal exposures mediate or interact with each other to affect offspring health outcomes?**

Where multiple lines of evidence point towards a causal effect, we will conduct additional mediation analyses to explore the relative direct and indirect effects of the maternal and paternal exposures. This will involve using multivariable MR where possible.


## Dissemination of findings

### Web tool (R Shiny app)

We will generate a great many more results than we can possibly report on in scientific papers. We therefore plan to make these results publicly available and develop an app to explore both the pheWAS and follow-up analysis results.

### Papers

We anticipate publishing three main comprehensive papers. These papers will be grouped by parental exposure (example titles):

* ”Causal relationships between parental prenatal smoking and offspring health: results from a multicohort study”
* ”Causal relationships between parental prenatal alcohol consumption and offspring health: results from a multicohort study”
* ”Causal relationships between parental prenatal caffeine consumption and offspring health: results from a multicohort study”

In addition, we aim to publish additional papers using one or a smaller number of cohorts (due to data and time availability):

* "A phenome-wide association study of maternal prenatal physical activity and offspring health"
	* Paternal physical activity as a negative control
	* Potentially just using ALSPAC
* "A phenome-wide association study of maternal prenatal mediterranean diet and offspring health"
	* Paternal diet as a negative control
	* Potentially just using ALSPAC (maybe GenR for replication)
* "A phenome-wide association study of maternal prenatal plant-based diet and offspring health"
	* Paternal diet as a negative control
* "Causal risk factors for cleft lip/palate identified through observational and mendelian randomization analysis"
	* The Cleft Collective cannot be included in the main papers because the CC participants consented to their data being used ONLY to study cleft, and since there are no controls, we can't include cleft as one of the outcomes in a pheWAS
	* This paper to be carried out in conjunction with Sarah Lewis (MR) and Amy Davies (triangulation of different control groups - ALSPAC, BiB, MCS)

Finally, we aim to publish additional methods/summary papers:

* "Potential selection bias in studies of paternal effects that use birth cohort data"
* "A web-tool to explore results from a multi-cohort study of maternal and paternal prenatal health behaviours and child health"

## Organisation of code and data

All prepared data (for ALSPAC, BiB and MCS) is stored in the EPoCH folder on the RDSF at the University of Bristol, except MoBa data which is stored and analysed on the servers at the Norwegian Institute for Public Health in Oslo.

All code is in this GitHub repository.

Most stages in EPoCH (all except the cohort-specific data preparation) can be run using a single bash script (`bash_master.sh`), which takes two arguments: `cohort` and `scriptname`. Before and after running this script (as a job on bluecrystal), it is necessary to run two other scripts (`before.sh` and `after.sh`). This is explained in the file [pipeline.md](https://github.com/ammegandchips/EPoCH/blob/main/analysis_plan/pipeline.md).



