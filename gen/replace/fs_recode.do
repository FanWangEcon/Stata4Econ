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

  1. given a discrete variable
  2. recode the discrete variable to reduce the number of categories, generate larger category categorical

*/

///--- Start log
set more off
capture log close _all
cd "${root_log}"
global st_link "/gen/replace/fs_recode"
global curlogfile "~/Stata4Econ/${st_link}"
global st_logname "stata_recode_discrete_subset"
log using "${curlogfile}" , replace name($st_logname)
log on $st_logname

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Stata Recode a Discrete Variable with Alternative Labels and Values Subgroups"

///--- Load Data
set more off
sysuse auto, clear

capture drop turn_m5
recode turn ///
  (min/35 = 1 "Turn <35") ///
  (36 = 2 "Turn = 36") ///
  (37 = 3 "Turn = 37") ///
  (38/45 = 4 "Turn 38 to 45") ///
  (46/max = 5 "Turn > 45") ///
  (else  =. ) ///
  , gen(turn_m5)


///--- Summarize
codebook turn*
tab turn_m5
tab turn turn_m5


///--- End Log and to HTML
log close _all
capture noisily {
  log2html "${curlogfile}", replace title($filetitle (<a href="https://github.com/FanWangEcon/Stata4Econ/blob/master${st_link}.do">DO</a>, more see: <a href="https://fanwangecon.github.io/">Fan</a> and <a href="https://fanwangecon.github.io/Stata4Econ">Stata4Econ</a>))
}

///--- to PDF
capture noisily {
	translator set Results2pdf logo off
	translator set Results2pdf fontsize 10
	translator set Results2pdf pagesize custom
	translator set Results2pdf pagewidth 8.27
	translator set Results2pdf pageheight 11.69
	translator set Results2pdf lmargin 0.2
	translator set Results2pdf rmargin 0.2
	translator set Results2pdf tmargin 0.2
	translator set Results2pdf bmargin 0.2
	translate @Results "${curlogfile}.pdf", replace translator(Results2pdf)
}
capture noisily {
  erase "${curlogfile}.smcl"
}
