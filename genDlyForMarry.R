# use alltimes_withExperiment to write delay duration times for each subject
# output in dly1d with run per line, * if no run
# N.B. code here confirms all runs of the same run number have identical sequence of cue delays
#     that is, delay durations for run 3 of 11196 == run 3 of 10841 


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


# write out files
for(subj in names(l)){
 # open dly1d/<subj>.1D for writting
 sink( paste(sep="",'dly1d/',subj,'.1D') )

 # run through each run, put dlys or *
 for(run in c("1","2","3","4") ){
     rundly<-l[[subj]][[run]]
     if(is.null(rundly)){
         rundly<-'*'
     } else {
         rundly<-rundly/1000
     }
     cat( rundly, "\n" )
 }
 # close file
 sink()
}

## write out generic dly dur file
for( r in c("1","2","3","4") ){

    # look at all run 1s
    run <- sapply(l,'[[',r)
    run[ sapply(run,is.null) | sapply(run,length)!=36 ] <- NULL # remove nulls and weird runs
    # see how many have the same delay length for that trial
    #apply(run1s,1,function(x){r<-rle(sort(x)); rbind(r$values,r$lengths)})
    tab <- apply(sapply(run,unlist),1,function(x){r<-rle(sort(x));rbind(r$values,r$lengths)})
    if(length(unique(tab[2,]))!=1L)
        error('not all subjects of run %d have the same delay duration sequence!',r)

    sink(paste(sep="",'dly1d/RUN',r,'.1D'))
    cat(tab[1,]/1000,"\n")
    sink()
 }

