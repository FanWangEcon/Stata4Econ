cls
clear

/*
  Back to Fan's Stata4Econ or other repositories:
  - http://fanwangecon.github.io
  - http://fanwangecon.github.io/Stata4Econ
  - http://fanwangecon.github.io/R4Econ
  - http://fanwangecon.github.io/M4Econ
  - http://fanwangecon.github.io/CodeDynaAsset/
  - http://fanwangecon.github.io/Math4Econ/
  - http://fanwangecon.github.io/Stat4Econ/
  - http://fanwangecon.github.io/Tex4Econ

  1. Install log2html
  2. Test log2html
*/

///--- Install log2html
ssc install log2html

///--- Start log
set more off
capture log close

cd "${root_log}"
global curlogfile "~\Stata4Econ\output\log\fs_log2html"
log using "${curlogfile}" , replace
log on

///--- log Contents
set more off
sysuse auto, clear

///--- Vars to Show

#delimit ;
global st_ids_etc "
			make
			foreign
			";

global st_outcomes "
			displacement
			weight length
			";

global st_inputs "
			trunk headroom
			price
			turn
			";

#delimit cr

///--- Describe Vars
d $st_ids_etc
d $st_outcomes
d $st_inputs

///--- Summ Vars
summ $st_ids_etc
summ $st_outcomes
summ $st_inputs
		
bys foreign (price): list ///
	$st_ids_etc ///
	$st_outcomes ///
	$st_inputs

///--- End Log and to HTML
log close
capture noisily {
  log2html "${curlogfile}", replace
}
capture noisily {
  erase "${curlogfile}.smcl"
}
