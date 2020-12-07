********************************************************************************
*Script to change alcohol PRS .profile files into Stata
*Written by Kayleigh Easey 
*October 2018
********************************************************************************

*Changing alcohol PRS .profile files into Stata

clear
cd "\\ads.bris.ac.uk\filestore\BRMS\Studies\PheWAS_sub\PRS\Alcohol"

infile str6 FID str6 IID PHENO CNT CNT2 SCORE using 20190220_scores_alcohol_children.profile


*Drop the first row if the column titles are here
drop in 1


*Separate FID or IID into aln and qlet to merge with other files

gen  aln = regexs(0) if regexm(FID, ("[0-9]+"))

destring aln, replace

gen qlet = substr(FID,-1,.)
 

gen prs_child_alc = SCORE

sum SCORE

sum prs_child_alc

keep aln qlet prs_child_alc 


save "\\ads.bris.ac.uk\filestore\BRMS\Studies\PheWAS_sub\PRS\Alcohol\prs_alc_child.20.02.19.dta", replace

***Mums PRS

clear
cd "\\ads.bris.ac.uk\filestore\BRMS\Studies\PheWAS_sub\PRS\Alcohol"

infile str6 FID str6 IID PHENO CNT CNT2 SCORE using 20190220_scores_alcohol_mothers.profile

*Drop the first row if the column titles are here
drop in 1

gen  aln = regexs(0) if regexm(FID, ("[0-9]+"))

destring aln, replace

gen qlet = substr(FID,-1,.)
 

gen prs_mum_alc = SCORE

sum SCORE

sum prs_mum_alc

keep aln prs_mum_alc



save "\\ads.bris.ac.uk\filestore\BRMS\Studies\PheWAS_sub\PRS\Alcohol\prs_alc_mum.20.02.19.dta", replace
 
