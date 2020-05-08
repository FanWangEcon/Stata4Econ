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

Generate loops in Stata

*/

///--- Start log
set more off
capture log close _all
cd "${root_log}"
global st_link "/prog/basics/fs_label"
global curlogfile "~/Stata4Econ/${st_link}"
global st_logname "stata_fs_label"
log using "${curlogfile}" , replace name($st_logname)
log on $st_logname

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Labeling Stata Variables, and Get Label and all Value Labels from Variables"

///--- Load Data
set more off
sysuse auto, clear

///////////////////////////////////////////////////////////////////////////////
///--- Labeling
///////////////////////////////////////////////////////////////////////////////

label variable make "Make and Model from the mtcars dataset"

label define foreign_lab 0 "domestic made" 1 "foreign made", modify
label values foreign foreign_lab 

///////////////////////////////////////////////////////////////////////////////
///--- Get Label Values
///////////////////////////////////////////////////////////////////////////////

///--- Variable Labels show
labelbook foreign_lab, d

///--- Get Variable Label and Values hard-coded
local st_var_label : variable label foreign
local st_foreign_val_0_lab : label foreign_lab 0
local st_foreign_val_1_lab : label foreign_lab 1

di "st_var_label:`st_var_label'"
di "st_foreign_val_0_lab:`st_foreign_val_0_lab'"
di "st_foreign_val_1_lab:`st_foreign_val_1_lab'"

///--- Get Variable Label and Values more Automated
/*
For automated value printing etc:
Given Variable Name:
1. get the label of the variable
2. get all value labels
3. get the number of observation each value of categorical
4. generate string based on these
*/

* 0. Var name
global st_var "foreign"
* 1. get variable label
local st_var_label : variable label ${st_var}
global st_var_label "`st_var_label'"
* 2. all values of foreign label
local st_var_val_lab_name: value label ${st_var}
levelsof ${st_var}, local(ls_var_levels) clean
di "`st_var_val_lab_name'"
di "`ls_var_levels'"
* 3. Number of Observations from Each category
tab ${st_var}, matcell(mt_obs)
* 4. all label values
global st_var_val_labs ""
local it_ctr = 0
foreach it_foreign_lvl of numlist `ls_var_levels' {
	local foreign_lvl_lab : label `st_var_val_lab_name' `it_foreign_lvl'
	di "`it_foreign_lvl':`foreign_lvl_lab'"
	local it_ctr = `it_ctr' + 1
	if (`it_ctr' > 1 ) {
		global st_var_val_labs "${st_var_val_labs}, "
	}
	global it_cate_obs = el(mt_obs, `it_ctr', 1)
	global st_var_val_labs "${st_var_val_labs}`it_foreign_lvl'=`foreign_lvl_lab' [N=${it_cate_obs}]"
}

* 4. final outputs
di "${st_var_label}"
di "For Outcome ${st_var_label}: ${st_var_val_labs}"
global slb_table_varinfo "${st_var_label} (${st_var_val_labs}, NA excluded from Regression)"
di "${slb_table_varinfo}"

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
