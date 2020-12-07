#!/bin/bash
 
# set -e
 
snplistfile=${1}
plinkrt=${2}
outfile=${3}
 
touch ${outfile}_mergelist.txt
rm ${outfile}_mergelist.txt
touch ${outfile}_mergelist.txt
firstchr="01"
flag="0"
for i in {01..23}
do
	filename=$(sed -e "s/CHR/$i/g" <<< ${plinkrt})
	echo ""
	echo "$filename"
	echo "${outfile}_${i}"
	echo ""
	plink --noweb --bfile ${filename} --extract ${snplistfile} --make-bed --out ${outfile}_${i}
	echo "$?"
	if [ -f "${outfile}_${i}.bed" ]; then
		echo "${outfile}_${i}.bed ${outfile}_${i}.bim ${outfile}_${i}.fam" >> ${outfile}_mergelist.txt		  
		if [ "${flag}" == "0" ]; then
			firstchr=${i}
		fi
		flag="1"
	fi
done
 
sed -i 1d ${outfile}_mergelist.txt
 
plink --noweb --bfile ${outfile}_${firstchr} --merge-list ${outfile}_mergelist.txt --make-bed --out ${outfile}
 
rm ${outfile}_*


