summaries <- readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/bib/results/BIB_ALL_model1a_summaries.rds")
table_names <- names(summaries)
table_names_split <- strsplit(table_names,split=".",fixed = T)
exposures <- unlist(lapply(table_names_split,function(X) X[[1]]))

for(i in 1:length(exposures)){
  exposure <- exposures[i]

cat(paste('
# ',exposure,'
```{r, results="asis",echo=FALSE, message=FALSE}
outcomes <- outcomes[exposures=="',exposure,'"]

for (i in 1:length(outcomes)) {
  outcome <- outcomes[i]
  cat(paste("## ",outcome))
  print(summaries[[i]])
  cat("\n\n<!-- -->\n\n")
}

```
\n',sep=""),
    file=paste("~/University of Bristol/grp-EPoCH - Documents/EPoCH GitHub/meta_analysis/results_summaries/summarising_BIB_RMD_",exposure,".Rmd",sep="")
)
}