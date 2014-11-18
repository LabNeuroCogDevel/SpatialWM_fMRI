all: dlydur

trialdata: 
	./00_EprimeLogToLargeTxt.bash
	# creates: alltimes_withExperiment.txt subjRuns.txt
dlydur: trialdata
	R --vanilla < genDlyForMarry.R # generates files for dly1d/*



# doc on how to create and R package
Rpackage:
	R --vanilla -e 'library(devtools);library(roxygen2);create("MMSWM");setwd("MMSWM");cat("edit R/*.R");document();install("MMSWM")'
