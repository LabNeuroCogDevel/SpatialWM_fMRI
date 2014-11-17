# this fifunction generates a matrix of trial-to-trial gridonset to gridonset times.
# each column is a run (1 to 4)
# rows are trial num
# N.B. expects to be run in same directory as alltimes_withExperiment.txt
#     or given the file name
# e.g. ost<-getGridOffsetPerRun('path/to/textfile.txt')
#      ost<-getGridOffsetPerRun() # if in same directory


getGridOffsetTimes <- function(datafile='alltimes_withExperiment.txt') {
   require(plyr)
   df<-read.table(datafile,header=T,sep="\t")
   df <- df[!is.na(df$subj),]
   df$runno <- substr(as.character(df$Experiment),1,1)

   l <- dlply(df,.(subj), function(x){
         dlply(x,.(runno), function(y) { y$Grid1.OnsetTime })
       })
   # l[["10662"]][["1"]] # look at run 1 for subj 10662

   # last thing set, also what is returned
   offsets <- sapply(c("1","2","3","4"), function(x){ 
      # get all the runs of one type
      thisrun <- lapply(l,'[[',x)
      # remove nulls and weird runs
      thisrun [ sapply(thisrun,is.null) | sapply(thisrun,length)!=48 ] <- NULL 
      # coearse into matrix, columns of subj, trial per rows 
      allonset <- sapply(thisrun,rbind)


      # get time between each grid onset
      alloffsets <- apply(allonset, 2, diff)
      
      # check that our estimates make sense, aren't very different
      maxdiffs <- apply(alloffsets,1,function(x){diff(range(x,na.rm=T))}) 
      if(any(maxdiffs>500) ) {
         expectval<- median(alloffsets[2,],na.rm=T)
         badval   <- abs(expectval-alloffsets[2,])
         badsubjs <- colnames(alloffsets)[badval>500&!is.na(badval)]
         warning('on run ',x,', some onsets are more than .5s. on subjs: ', badsubjs)
         # show range and median
         #print(rbind(apply(alloffsets,1,range,na.rm=T),apply(alloffsets,1,median,na.rm=T)))
      }

      # final output is median offset per run (line per trial, -- put into column per run by sapply) 
      runoffsets  <- apply( alloffsets,         1, mean, na.rm=T)
      #runoffsets <- apply( apply(sapply( lapply(l,'[[',1), rbind) , 2, diff),         1, mean, na.rm=T)

   })
}
