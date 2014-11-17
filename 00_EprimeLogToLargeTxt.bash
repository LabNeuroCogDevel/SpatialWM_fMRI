#!/usr/bin/env bash
outname=alltimes_withExperiment_$(date +%F).txt
./parseEprimeTxt.pl data/multimodalWM_fMRI* > $outname
# get some stats
R --vanilla <<EOF 
library(plyr)
df<-read.table(sep="\t",'$outname',header=T)
o<-ddply(df,.(subj,date), function(x){c(runs=paste(collapse=", ",sep=",",unique(x\$Experiment)),count=nrow(x) )})
write.table(o,'subjRuns.txt',row.names=F,sep="\t",quote=F)
print(o)
EOF

