cls
clear
macro drop _all

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

  1. given a list of variables, and some conditioning statement
  2. what is the subset of observations where these variables all have non missing values
  3. and satisfying the condioning statements

*/

///--- Start log
set more off
capture log close _all
cd "${root_log}"
global st_link "/summ/count/fs_nonmissing"
global curlogfile "~/Stata4Econ/${st_link}"
global st_logname "select_rows_nonmissing"
log using "${curlogfile}" , replace name($st_logname)
log on $st_logname

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Stata Select Rows where Multiple Variables are All Observed, Jointly Nonmissing"

///--- Load Data
set more off
sysuse auto, clear

///--- Generating Index for Dropping
set seed 987
scalar it_drop_frac = 3
gen row_idx_it = round((_n/_N)*it_drop_frac)
gen row_idx_rand = round(it_drop_frac*uniform())
replace mpg =. if row_idx_it == row_idx_rand

set seed 123
scalar it_drop_frac = 3
replace row_idx_it = round((_n/_N)*it_drop_frac)
replace row_idx_rand = round(it_drop_frac*uniform())
replace price =. if row_idx_it == row_idx_rand

///--- list vars to include in a regression for example
global svr_list "mpg price length weight"

///--- Conditioning
global scd_bse "foreign !=."
global scd_one "& foreign == 1"
global scd_two "& gear_ratio <= 4"

///--- Drop approximately 1/2 of make randomly
egen valid = rownonmiss($svr_list) if $scd_bse $scd_one $scd_two

///--- Tabulate and list Results
tab valid
list $svr_list if valid == wordcount("$svr_list")

///--- List including rows where not all values are observed but conditioning satisfied
tab valid
list $svr_list if valid !=.

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
