cls
clear
macro drop _all

/*
Back to Fan's Stata4Econ or other repositories:

- http://fanwangecon.github.io

- http://fanwangecon.github.io/Stata4Econ
- http://fanwangecon.github.io/R4Econ
- http://fanwangecon.github.io/REconTools
- http://fanwangecon.github.io/M4Econ
- http://fanwangecon.github.io/Tex4Econ
- http://fanwangecon.github.io/CodeDynaAsset/
- http://fanwangecon.github.io/Math4Econ/
- http://fanwangecon.github.io/Stat4Econ/

The file works out a variety of within group operations.

1. spread and popolate within group value to all elements of the group
*/

///--- Start log
set more off
capture log close _all
cd "${root_log}"
global st_link "/gen/group/fs_group"
global curlogfile "~/Stata4Econ/${st_link}"
global st_logname "stata_recode_discrete_subset"
log using "${curlogfile}" , replace name($st_logname)
log on $st_logname

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Stata By Group Fill Missing Values by Nonmissing Values"

///--- Load Data
set more off
sysuse auto, clear

///////////////////////////////////////////////////////////////////////////////
///--- Fill Missing Values with NonMissing Min
///////////////////////////////////////////////////////////////////////////////

///--- there are 18 trunk categories
codebook trunk

* generate some random variable
gen var_one_val_in_group = uniform()

* keep one only value each group, all else null
* keep lowest weight length not null
bys trunk (weight length): replace var_one_val_in_group =. if _n != 1

* now populate this randomly selected value within each trunk group to all in group
* sort by var_test, the non-missing value shows up first
bys trunk (var_one_val_in_group): gen var_test_fill = var_one_val_in_group[1]

sort trunk price
list trunk price weight length var_one_val_in_group var_test_fill, sepby(trunk)

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
