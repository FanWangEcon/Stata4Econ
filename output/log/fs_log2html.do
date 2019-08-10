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
///--- to PDF
capture noisily {
	// translator query smcl2pdf
	translator set smcl2pdf logo off
	translator set smcl2pdf fontsize 8
	translator set smcl2pdf pagesize custom
	translator set smcl2pdf pagewidth 17
	translator set smcl2pdf pageheight 17
	translator set smcl2pdf lmargin 0.4
	translator set smcl2pdf rmargin 0.4
	translator set smcl2pdf tmargin 0.4
	translator set smcl2pdf bmargin 0.4
	translate "${curlogfile}.smcl" "${curlogfile}.pdf", replace translator(smcl2pdf)

	// translator query Results2pdf
	translator set Results2pdf logo off
	translator set Results2pdf fontsize 8
	translator set Results2pdf pagesize custom
	translator set Results2pdf pagewidth 9
	* 20 is max height
	translator set Results2pdf pageheight 20
	translator set Results2pdf lmargin 0.2
	translator set Results2pdf rmargin 0.2
	translator set Results2pdf tmargin 0.2
	translator set Results2pdf bmargin 0.2
	translate @Results "${curlogfile}_res.pdf", replace translator(Results2pdf)
}
capture noisily {
  erase "${curlogfile}.smcl"
}
