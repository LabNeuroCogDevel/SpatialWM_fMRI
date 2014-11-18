
# Get Data
see `Makefile`

## Trial Data

`./00_EprimeLogToLargeTxt.bash`

creates: 

*  `alltimes_withExperiment_2014-11-17.txt`
*  `subjRuns.txt`

from all subject eprime log files in  `data/multimodalWM_fMRI_v1_*.txt`

# Fix timing

A few runs were collected before EPrime was set to log the onset times of all events. There are 4 runs, each with a distinct timing sequence that is shared for every subject. The same run from different subjects will have millisecond varations due to screen refresh rate and processing times.

* get run timing: `install("MMSWM");library(MMSWM);` and look to `?getGridOffsetTimes` (`MMSWM/R/getGridOffsetTimes.R`)
  * also can install remotely  `install_github('LabNeuroCogDevel/SpatialWM_fMRI',subdir='MMSWM')`

* `genDlyForMarry.R`: generate per run and per subj+run delay files in `dly1d/*.1D` 
