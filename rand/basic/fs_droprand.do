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

  1. drop a random subset of values
  
*/

///--- Start log
set more off
capture log close
cd "${root_log}"
global st_link "/rand/basic/fs_droprand"
global curlogfile "~/Stata4Econ/${st_link}"
log using "${curlogfile}" , replace
log on

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Stata Drop a Random Subset of Observations"

///--- Load Data
set more off
sysuse auto, clear

///--- Generating Index for Dropping
set seed 987
scalar it_drop_frac = 3
gen row_idx_it = round((_n/_N)*it_drop_frac) 
gen row_idx_rand = round(it_drop_frac*uniform())

//--- drop when row_idx_it == row_idx_rand, if it_drop_frac set at 3
list make price mpg row_idx_it row_idx_rand, ab(20)

///--- Drop approximately 1/2 of make randomly
set seed 987
scalar it_drop_frac = 2
clonevar make_wth_mimssing = make
replace make_wth_mimssing = "" if round((_n/_N)*it_drop_frac) == round(it_drop_frac*uniform())

///--- Drop approximately 1/3 of mpg randomly
set seed 987
scalar it_drop_frac = 3
clonevar mpg_wth_mimssing = mpg
replace mpg_wth_mimssing =. if round((_n/_N)*it_drop_frac) == round(it_drop_frac*uniform())

///--- Drop approximately 1/5 of mpg randomly
set seed 987
scalar it_drop_frac = 5
clonevar price_wth_mimssing = price
replace price_wth_mimssing =. if round((_n/_N)*it_drop_frac) == round(it_drop_frac*uniform())

///--- Summarize
codebook make*
summ mpg* price*
list make* mpg* price*

///--- End Log and to HTML
log close
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
