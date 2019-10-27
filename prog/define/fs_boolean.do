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

  1. boolean control in stata
*/

///--- Start log
set more off
capture log close
cd "${root_log}"
global curlogfile "~\Stata4Econ\prog\define\fs_boolean"
log using "${curlogfile}" , replace
log on

///--- Load Data
set more off
sysuse auto, clear

///--- Control
local bl_includereg1 = 1
local bl_includereg2 = 0
global bl_includereg3 = 0
global bl_includereg4 = 1
scalar bl_includereg5 = 0
scalar bl_includereg6 = 1

///--- Define Multiple Variables as global in delimit
	#delimit;
	global vars_rhs "
		mpg
		ib1.rep78
		headroom trunk
		weight
	  ";
	#delimit cr

	di `"$vars_rhs"'

///--- Define String with Quotes
	#delimit;
	global st_coef_label "
		mpg "mpg variable"
		1.rep78 "BASE GROUP CONSTANT = rep78 is 1"
		2.rep78 "rep78 is 2"
		3.rep78 "rep78 is 3"
		4.rep78 "rep78 is 4"
		5.rep78 "rep78 is 5"
		headroom "headroom variable"
		trunk "this is the trunk variable"
		weight "and here the weight variable"
	  ";
	#delimit cr

	di `"$st_coef_label"'

///--- Describe and Summarize
	d $rhs_vars_list, f
	summ $rhs_vars_list

///--- Run Regression

	eststo clear
if (`bl_includereg1') {
	eststo, title("reg1"): regress price $vars_rhs if foreign == 0
}
if (`bl_includereg2') {
	eststo, title("reg2"): regress price $vars_rhs if foreign == 1
}
if ($bl_includereg3) {
    eststo, title("reg3"): regress price $vars_rhs if foreign == 1
}
if ($bl_includereg4) {
    eststo, title("reg4"): regress price $vars_rhs if foreign == 1
}
if (bl_includereg5) {
    eststo, title("reg5"): regress price $vars_rhs if foreign == 1
}
if (bl_includereg6) {
    eststo, title("reg6"): regress price $vars_rhs if foreign == 1
}
	esttab, title("include reg 1 2 and 4 but not 3, and 6 but not 5.") ///
		mtitle ///
		coeflabels($st_coef_label) ///
		varwidth(50)

///--- End Log and to HTML
log close
capture noisily {
  log2html "${curlogfile}", replace
}

///--- to PDF
capture noisily {
	translator set Results2pdf logo off
	translator set Results2pdf fontsize 10
	translator set Results2pdf pagesize custom
	translator set Results2pdf pagewidth 11.69
	translator set Results2pdf pageheight 16.53
	translator set Results2pdf lmargin 0.2
	translator set Results2pdf rmargin 0.2
	translator set Results2pdf tmargin 0.2
	translator set Results2pdf bmargin 0.2
	translate @Results "${curlogfile}.pdf", replace translator(Results2pdf)
}
capture noisily {
  erase "${curlogfile}.smcl"
}
