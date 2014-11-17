# DO NOT USE (WF:20141117)
#  does not know about "Experiment" (i.e. run#). Guesses based on SessionTime. This is inadequate.
# 

library(plyr)
df<-read.table('alltimes_withExperiment.txt',header=T,sep="\t")
df <- df[!is.na(df$subj),]
df$runno <- substr(as.character(df$Experiment),1,1)

l <-
  dlply(df,.(subj), function(x){
     dlply(x,.(runno), function(y){
        dly<-as.numeric(as.character(y$Delay_time))
        dly<-dly[!is.na(dly)]
     })
  })
# l[["10662"]][["1"]]

# look at all run 1s
run <- sapply(l,'[[','4')
run[ sapply(run,is.null) | sapply(run,length)!=36 ] <- NULL # remove nulls and weird runs
# see how many have the same delay length for that trial
#apply(run1s,1,function(x){r<-rle(sort(x)); rbind(r$values,r$lengths)})
tab <-sapply(run,unlist) 
apply(tab,1,function(x){r<-rle(sort(x));rbind(r$values,r$lengths)})

# write out files
for(subj in names(l)){
 # open dly1d/<subj>.1D for writting
 sink( paste(sep="",'dly1d/',subj,'.1D') )

 # run through each run, put dlys or *
 for(run in c("1","2","3","4") ){
   rundly<-l[[subj]][[run]]
   cat(ifelse(rundly,rundly,'*'),"\n")
 }
 # close file
 sink()
}


