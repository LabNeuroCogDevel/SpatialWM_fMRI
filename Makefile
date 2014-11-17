all: dlydur

trialdata: 
	./00_EprimeLogToLargeTxt.bash
	# creates: alltimes_withExperiment.txt subjRuns.txt
dlydur: trialdata
	R --vanilla < genDlyForMarry.R # generates files for dly1d/*
