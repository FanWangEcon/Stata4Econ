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

  1. define variables through delimit
  2. define string with quotes
  3. run regression, and use defined string as labels for rows in esttab
  4. replace all occurances of elements in strings

*/

///--- Start log
set more off
capture log close _all
cd "${root_log}"
global st_link "/prog/define/fs_strings"
global curlogfile "~/Stata4Econ/${st_link}"
global st_logname "stata_fs_strings"
log using "${curlogfile}" , replace name($st_logname)
log on $st_logname

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Stata string delimit, string with quotes, string regression labels, etc."

///////////////////////////////////////////////////////////////////////////////
///--- String Operations
///////////////////////////////////////////////////////////////////////////////

///--- Search and Replace Text in Substring

* replace quote in string
di subinstr(`"dataVar1 " dataVar2"',`"""',"",.)

* Replace quotes in string
di subinstr(`" "dataVar1 dataVar2 " "dataVar2 dataVar3" "',`"""',"",.)

* Replace & with /& in long string
global scd ""
global scd "${scd} Conditions: PA=(& el\_i\_mand\_talk\_m2a != -999 & S\_han !=.);"
global scd "${scd} PB=(& el\_i\_mand\_talk\_m2a != -999 & S\_han == 0);"
global scd "${scd} PC=(& el\_i\_mand\_talk\_m2a != -999 & S\_han == 1);"
global scd "${scd} common=(S\_han !=. & AgeCloseYr\_i\_G1 <= 30 & H\_age <= 44"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
global scd "${scd} & (vE\_schCloseYr\_full >= 1998 | vE\_schCloseYr\_full == 0)"
    
global scd = subinstr("${scd}","&","\&",.)
di "${scd}"

* Replace dash
local tableRefName = "a_b_c"
local tableRefName = subinstr("`tableRefName'","_","",.)
di "`tableRefName'"

* replace pound
local instrCap = "_d1_l1#_d1_l2 _d2_l2#_d2_l4"
local cinstrCapF = subinstr(word("`instrCap'",1),"#"," ",.)
di "`cinstrCapF'"

///////////////////////////////////////////////////////////////////////////////
///--- String Definitions and Regressions
///////////////////////////////////////////////////////////////////////////////
///--- Load Data
set more off
sysuse auto, clear

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
	eststo, title("reg1"): regress price $vars_rhs if foreign == 0
	eststo, title("reg2"): regress price $vars_rhs if foreign == 1

	esttab, title("regtest") ///
		mtitle ///
		coeflabels($st_coef_label) ///
		varwidth(50)

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
