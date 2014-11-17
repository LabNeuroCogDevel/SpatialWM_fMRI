all: trialdata

trialdata: 
	./00_EprimeLogToLargeTxt.bash
	# creates: alltimes_withExperiment.txt subjRuns.txt
