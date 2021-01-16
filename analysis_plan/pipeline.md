# Pipeline for running an EPoCH script

## Step 1

**Download and run `before.sh` interactively (i.e. do not submit as a job)**

This script moves all the phenotype data and key files from the RDSF folder to a folder in your home directory on bluecrystal called `EPoCH/data`.

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

**Download and submit a job using `bash_master.sh`**

To download, run the following interactively:

```
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/bash_master.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/bash_master.sh
```

The arguments to `bash_master.sh` are `scriptname` and `cohort`. The bash script can be used to submit any of the R scripts stored in `~/EPoCH/scripts/` as a job. 

```
qsub ~/EPoCH/scripts/bash_master.sh -v cohort=ALSPAC,scriptname=MAKE_KEY
```

options for `scriptname` are:

  *   SUMMARISE_DATA
  *   MAKE_KEY
  *   RUN_PHEWAS
  *   RUN_META_ANALYSIS

Options for `cohort` are:

  *   ALSPAC
  *   BIB
  *   MCS
  *   Or, when scriptname = RUN_META_ANALYSIS, cohort can be any combination of cohort names, separated by an underscore, e.g: ALSPAC_BIB_MCS or MCS_BIB etc.

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
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/bash_master.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/bash_master.sh

qsub ~/EPoCH/scripts/bash_master.sh -v cohort=ALSPAC,scriptname=MAKE_KEY

# STEP 3 [WAIT UNTIL THE JOB SUBMITTED IN STEP 2 IS COMPLETE]
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/after.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/after.sh
~/EPoCH/scripts/after.sh
```

