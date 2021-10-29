# Pipeline for running an EPoCH script

## Step 1

**Download and run `before.sh` interactively (i.e. do not submit as a job)**

This script moves all the phenotype data and key files from the RDSF folder to a folder in your home directory on blue pebble called `EPoCH/data`.

It also downloads all necessary r files to `EPoCH/scripts` and makes a folder called `EPoCH/out` if it doesn’t already exist. And it deletes any old out files and results so you can start afresh.

To make the `EPoCH/scripts` folder if it doesn’t already exist:

```
mkdir -p ~/EPoCH/scripts/
```

To remove any old scripts:

```
rm -r ~/EPoCH/scripts/*
```

To download `before.sh` from github:

```
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/before.sh -P ~/EPoCH/scripts/
```

To make `before.sh` executable:

```
chmod +x ~/EPoCH/scripts/before.sh
```

To run `before.sh`:

```
~/EPoCH/scripts/before.sh
```

## Step 2

**Download and submit a job using `epoch_master.sh`**

To download, run the following interactively:

```
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/epoch_master.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/epoch_master.sh
```

The arguments to `epoch_master.sh` are `scriptname` and `cohortORmodel`. The submission script can be used to submit any of the R scripts stored in `~/EPoCH/scripts/` as a job. 

```
qsub  -v cohortORmodel="ALSPAC",scriptname="MAKE_KEY" ~/EPoCH/scripts/epoch_master.sh
```

options for `scriptname` are:

  *   SUMMARISE_DATA
  *   MAKE_KEY
  *   RUN_PHEWAS
  *   RUN_META_ANALYSIS_BIB

Options for `cohortORmodel` are:

  *   ALSPAC
  *   BIB
  *   MCS
  *   Or any of the above, plus an underscore followed by "FEMALE" or "MALE", if running the sex-stratified PheWAS (note that a new key is not needed)
  *   Or, when scriptname = RUN_META_ANALYSIS, cohortORmodel is model name (e.g. model1a) eithier alone (unstratified) or plus an underscore followed by "FEMALE" or "MALE" if running the sex-stratified PheWAS meta-analysis

## Step 3

**Move results back to RDSF**

When the job is complete (check using `qstat -u yourusername`), run `after.sh` interactively to move keys/results from home directory to EPoCH project folder on the RDSF

```
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/after.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/after.sh
~/EPoCH/scripts/after.sh
```

## Everything all together, to copy and paste quickly:

```
# STEP 1
mkdir -p ~/EPoCH/scripts/
rm -r ~/EPoCH/scripts/*
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/before.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/before.sh
~/EPoCH/scripts/before.sh

# STEP 2
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/epoch_master.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/epoch_master.sh

# submit job, e.g.:
qsub  -v cohortORmodel="ALSPAC",scriptname="MAKE_KEY" ~/EPoCH/scripts/epoch_master.sh

# STEP 3 [WAIT UNTIL THE JOB SUBMITTED IN STEP 2 IS COMPLETE]
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/after.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/after.sh
~/EPoCH/scripts/after.sh
```

All the options for qsub you might want to submit:
```
qsub  -v cohortORmodel="ALSPAC",scriptname="SUMMARISE_DATA" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="BIB",scriptname="SUMMARISE_DATA" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="MCS",scriptname="SUMMARISE_DATA" ~/EPoCH/scripts/epoch_master.sh

qsub  -v cohortORmodel="ALSPAC",scriptname="MAKE_KEY" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="BIB",scriptname="MAKE_KEY" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="MCS",scriptname="MAKE_KEY" ~/EPoCH/scripts/epoch_master.sh

qsub  -v cohortORmodel="ALSPAC",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="BIB",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="MCS",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="ALSPAC_FEMALE",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="BIB_FEMALE",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="MCS_FEMALE",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="ALSPAC_MALE",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="BIB_MALE",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="MCS_MALE",scriptname="RUN_PHEWAS" ~/EPoCH/scripts/epoch_master.sh

qsub  -v cohortORmodel="model1a",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model1b",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model1c",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2a",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2b",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2c",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3a",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3b",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3c",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4a",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4b",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4c",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh

qsub  -v cohortORmodel="model1a_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model1b_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model1c_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2a_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2b_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2c_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3a_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3b_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3c_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4a_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4b_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4c_FEMALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh

qsub  -v cohortORmodel="model1a_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model1b_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model1c_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2a_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2b_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model2c_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3a_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3b_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model3c_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4a_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4b_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh
qsub  -v cohortORmodel="model4c_MALE",scriptname="RUN_META_ANALYSIS" ~/EPoCH/scripts/epoch_master.sh

```
To check on the status of a job (for my username gs8094):
```
qstat -u "gs8094"
```
Or to check the output from the script, e.g.:
```
less EPoCH/out/ALSPAC_MAKE_KEY.out
```
