#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
# perl -slane '$level=$1 if m/Level: (\d)/; %a=() if(/LogFrame Start/); print map {"$_\t"} sort keys %a if /LogFrame End/ and $level==4; $a{$1}=$2 if /^\s+(.*):(.*)/ and $level==4; print "$level $_" if 0' //mnt/B/bea_res/Data/Tasks/Reversal_MMY3/*.txt|sort |uniq -c
#    2360 LeftStim   NumRight Procedure   RightStim   Running  TrainProbabilistic   TrainProbabilistic.Cycle   TrainProbabilistic.Sample  TrialType   Valid acc   ansr1 incorrect   presentfeedback.DurationError presentfeedback.OnsetDelay presentfeedback.OnsetTime  presentfeedback.StartTime  showstim.ACC   showstim.CRESP showstim.OnsetTime   showstim.RESP  showstim.RT 
#    7564 LeftStim   NumRight Procedure   RightStim   Running  TrainProbabilistic   TrainProbabilistic.Cycle   TrainProbabilistic.Sample              Valid acc   ansr1 incorrect   presentfeedback.DurationError presentfeedback.OnsetDelay presentfeedback.OnsetTime  presentfeedback.StartTime  showstim.ACC   showstim.CRESP showstim.OnsetTime   showstim.RESP  showstim.RT 
#       1 LeftStim   NumRight Procedure   RightStim   Running  TrainProbabilistic   TrainProbabilistic.Cycle   TrainProbabilistic.Sample  TrialType   Valid acc   ansr1 incorrect                                                                                                                  showstim.ACC   showstim.CRESP showstim.OnsetTime   showstim.RESP  showstim.RT 
#     248 Procedure  RepNum   Running  ScanBlockType  ScanBlockType.Cycle  ScanBlockType.Sample
my $level=0;
my %a;

my $subj="";
my $exp="";
my $date="";
my $SessionTime="";

my @columns=qw/	Procedure	Grid1.OnsetTime	Delay.OnsetTime	Target.OnsetTime	Delay_time	ITI		Load	Block	Cue1_img	Cue2_img	Cue3_img	Target_img	Target.RT	Target.RTTime  Target.ACC	Match/;

say join "\t", "subj","date","Experiment","SessionTime","level",@columns;
while(<>){
   $subj=$1       if /Subject: (\d+)/;
   #Experiment: SpatialWM_v1_run2
   $exp=$1        if /^Experiment: multimodalWM_fMRI_v1_run(.*)/;
   $date="$3$1$2" if /SessionDate: (\d{2})-(\d{2})-(\d{4})/;
   $SessionTime=$1 if/SessionTime: (.*)/;
   
   
   # reset if end of file
   if(/^\*\*\* LogFrame End \*\*\*$/){
      $subj="";
      $date="";
      $SessionTime="";
   }

   ### log levels are conained within /log start/ and /log end/
   
   # keep level up to date
   $level=$1 if m/Level: (\d)/;
   # reset hash after every log frame
   %a=() if(/LogFrame Start/);

   # if this is the end of level 4
   if(/LogFrame End/) {
      my @vals=map {$a{$_}||""} @columns;
      next if $#vals<0 ;
      say join "\t", $subj,$date,$exp,$SessionTime,$level,@vals if $subj;
   }
   $a{$1}=$2 if /^\s+(.*):(.*)/;
   print "$level $_" if 0
}
