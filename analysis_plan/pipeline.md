# Pipeline for running an EPoCH script

## Step 1

**Download and run `before.sh` interactively (i.e. do not submit as a job)**

(note that bluepebble is a bit unpredictable. I was advised to login to bp1-login03.acrc.bris.ac.uk rather than bp1-login.acrc.bris.ac.uk. This seems to resolve the issues)

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

The arguments to `epoch_master.sh` are `scriptname` (first) and `cohortORmodel` (second). The submission script can be used to submit any of the R scripts stored in `~/EPoCH/scripts/` as a job. 

(note that in Jan 2022, I had to update the scripts from PBSPro to SLURM, so e.g. qsub changed to sbatch etc)

```
sbatch  ~/EPoCH/scripts/epoch_master.sh ALSPAC MAKE_KEY
```

options for `scriptname` are:

  *   SUMMARISE_DATA
  *   MAKE_KEY
  *   RUN_PHEWAS
  *   RUN_META_ANALYSIS

Options for `cohortORmodel` are:

  *   ALSPAC
  *   BIB
  *   MCS
  *   Or any of the above, plus an underscore followed by "FEMALE" or "MALE", if running the sex-stratified PheWAS (note that a new key is not needed)
  *   Or, when scriptname = RUN_META_ANALYSIS, cohortORmodel is model name (e.g. model1a) eithier alone (unstratified) or plus an underscore followed by "FEMALE" or "MALE" if running the sex-stratified PheWAS meta-analysis

## Step 3

**Move results back to RDSF**

When the job is complete (check the out file), run `after.sh` interactively to move keys/results from home directory to EPoCH project folder on the RDSF

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
sbatch  ~/EPoCH/scripts/epoch_master.sh ALSPAC MAKE_KEY

# STEP 3 [WAIT UNTIL THE JOB SUBMITTED IN STEP 2 IS COMPLETE]
wget https://raw.githubusercontent.com/ammegandchips/EPoCH/main/after.sh -P ~/EPoCH/scripts/
chmod +x ~/EPoCH/scripts/after.sh
~/EPoCH/scripts/after.sh
```

To check on the status of a job:
```
sacct
```
Or to check the output from the script, e.g.:
```
less EPoCH/out/ALSPACMAKE_KEY.out
```
