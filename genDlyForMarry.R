# DO NOT USE (WF:20141117)
#  does not know about "Experiment" (i.e. run#). Guesses based on SessionTime. This is inadequate.
# 

library(plyr)
df<-read.table('alltimes2.txt',header=T,sep="\t")
df <- df[!is.na(df$subj),]

if length(unique(paste(df$subj,df$SessionTime))) != length(unique(df$SessionTime))
 error('session times repeat per subject, cannot do my trick')

# relevel session time per subject to get run order number
dfrn<-ddply(df,.(subj),function(x){
   newlevels<-factor(x$SessionTime,levels=sort(as.character(unique(x$SessionTime))))
   x$runnum <- as.numeric(newlevels)
   x
})

# inspect run numbers for bad sort (looks good)
checkrunnums <- ddply(dfrn,.(subj,SessionTime),function(x){c(runnum=paste(unique(x$runnum)))})

l <-
  dlply(dfrn,.(subj), function(x){
     dlply(x,.(runnum), function(y){
        dly<-as.numeric(as.character(y$Delay_time))
        dly<-dly[!is.na(dly)]
     })
  })
# l[["10662"]][["1"]]

# look at all run 1s
run1s <- sapply(l,'[[',1)
# see how many have the same delay length for that trial
apply(run1s,1,function(x){r<-rle(sort(x)); rbind(r$values,r$lengths)})


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


