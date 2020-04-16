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

1. given a discrete variable
2. recode the discrete variable to reduce the number of categories, generate larger category categorical

Note there are several ingredients to consider here:
1. current variable name
2. new variable name
3. new variable label
4. new value labels
5. new note
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
global filetitle "Stata Recode a Discrete Variable with Alternative Labels and Values Subgroups: recode, inrange, inlist"

///--- Load Data
set more off
sysuse auto, clear

///////////////////////////////////////////////////////////////////////////////
///--- Recode Method 1
///////////////////////////////////////////////////////////////////////////////
capture drop turn_m5
recode turn ///
	(min/35 = 1 "Turn <35") ///
	(36 = 2 "Turn = 36") ///
	(37 = 3 "Turn = 37") ///
	(38/45 = 4 "Turn 38 to 45") ///
	(46/max = 5 "Turn > 45") ///
	(else  =. ) ///
	, gen(turn_m5)

///////////////////////////////////////////////////////////////////////////////
///--- Recode Method 2
///////////////////////////////////////////////////////////////////////////////
clonevar turn_m5_alt = turn
label variable turn_m5_alt "Recode using inlist and inrange"
replace turn_m5_alt = 1 if inrange(turn, 31, 35)
replace turn_m5_alt = 2 if inlist(turn, 36)
replace turn_m5_alt = 3 if inlist(turn, 37)
replace turn_m5_alt = 4 if inrange(turn, 38, 45)
replace turn_m5_alt = 5 if inlist(turn, 46, 48, 51)
label define turn_m5_alt 1 "Turn <35" 2 "Turn = 36" 3 "Turn = 37" 4 "Turn 38 to 45" 5 "Turn > 45", modify
label values turn_m5_alt turn_m5_alt

///////////////////////////////////////////////////////////////////////////////
///--- Recode Method 3: Recode based on single variable, 
///    slightly less typing, compose ingredients together
///////////////////////////////////////////////////////////////////////////////
/*
Define string using local strings to avoid some retyping. 
try to make variable label not longer than width limit. 
*/

//-- Set Variable Strings
global svr_newv "trunk_new"
global svr_oldv "trunk"
global slb_labl "this is the new version of the trunk variable"
global slb_note "we reset this variable be grouping values 5 to 10, 11 to 13, 14 "
global slb_note "$slb_note to 18, 20 to 22, and 23 into subgroups. We did this "
global slb_note "$slb_note test things out for reseting variables"

//-- value resetting
#delimit;
global slb_valv "
	(min/4 = 1 "trunk <5")
	(5/10  = 2 "Turn = 36")
	(11/13 = 3 "Turn = 37")
	(14/18 = 4 "Turn 38 to 45")
	(20/22 = 5 "Turn > 45")
	(23 = 5 "Turn > 45")
	(else  =. )
  ";
#delimit cr

//-- recode
* generate
capture drop $svr_newv
recode $svr_oldv $slb_valv, gen($svr_newv)
label variable $svr_newv "$slb_labl"
notes $svr_newv: $slb_note
* summ
d $svr_oldv $svr_newv, f
notes $svr_oldv $svr_newv
summ $svr_oldv $svr_newv
tab $svr_oldv $svr_newv
tab $svr_newv


///////////////////////////////////////////////////////////////////////////////
///--- Recode Method 4: same as method 3, but do it for multiple variables loop loop
///////////////////////////////////////////////////////////////////////////////
/*
1. Define string using local strings to avoid some retyping. 
2. Summarize outputs iteration by iteration, verbose or not
3. Summarize outputs at the end overall
4. if new and old variables have the same name, understand we want to use the 
	same name, will relabel generate a new variable with the same variable name
	and keep old variable as old_abc, where abc is the current var name
*/
global svr_newv_all ""
foreach it_var of numlist 1 2 3 {
	
	//-- Variable by Variable Naming Settings	
	if (`it_var' == 1) {
		//-- Set Variable Strings
		global svr_newv "price_2m"
		global svr_oldv "price"
		global slb_labl "price discretized 2 levels"
		global slb_note "reset the price variable into two groups, original variable has"
		global slb_note "$slb_note 74 observations with 74 unique values. "

		//-- value resetting
		#delimit;
		global slb_valv "
			(min/6000 = 1 "price <= 6000")
			(6001/max = 2 "price >  6000")
			(else  =. )
		  ";
		#delimit cr

		//-- states verbose show or not
		global bl_verbose_print = 0
	}
	if (`it_var' == 2) {
		//-- Set Variable Strings
		global svr_newv "price_3m"
		global svr_oldv "price"
		global slb_labl "price discretized 3 levels"
		global slb_note "reset the price variable into two groups, original variable has"
		global slb_note "$slb_note 74 observations with 74 unique values. "

		//-- value resetting
		#delimit;
		global slb_valv "
			(min/5500  = 1 "price <= 5500")
			(5501/8500 = 2 "5501 <= price <= 8500")
			(8501/max  = 3 "8501 <= price")
			(else  =. )
		  ";
		#delimit cr

		//-- states verbose show or not
		global bl_verbose_print = 0
	}
	if (`it_var' == 3) {
		//-- Set Variable Strings
		* this is an example where I relabel and revalue names, but keep variable name
		* auto keep an old version
		global svr_newv "foreign"
		global svr_oldv "foreign"
		global slb_labl "is car domestic (relabled, previous 1 is foreign now 0)"
		global slb_note "reseting the foreign variable previously 1 is foreign 0"
		global slb_note "$slb_note is domestic, now 1 is domestic 0 is foreign"

		//-- value resetting
		#delimit;
		global slb_valv "
			(1 = 0 "foreign car")
			(0 = 1 "domestic car")
			(else  =. )
		  ";
		#delimit cr

		//-- states verbose show or not
		global bl_verbose_print = 1
	}
	
	//-- recode
	di "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	di "Generate the `it_var'th variable: Generates $svr_newv based on $svr_oldv"
	di "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
	* generate
	global svr_oldv_use "${svr_oldv}"
	if ("$svr_newv" == "$svr_oldv") {
		* allows for relabeling the same variable keeping name
		global svr_oldv_use "_prev_${svr_oldv}"
		clonevar _prev_${svr_oldv} = $svr_oldv
		notes $svr_oldv_use: "this variable $svr_oldv_use is replaced by $svr_newv"
	}
	capture drop $svr_newv
	recode $svr_oldv_use $slb_valv, gen($svr_newv)
	label variable $svr_newv "$slb_labl"
	notes $svr_newv: $slb_note
	
	//-- summarize
	d $svr_newv, f
	summ $svr_oldv_use $svr_newv
	tab $svr_newv
	pwcorr $svr_oldv_use $svr_newv, sig
	if ($bl_verbose_print) {
		d $svr_oldv_use $svr_newv, f
		notes $svr_oldv_use $svr_newv
		tab $svr_oldv_use $svr_newv
		label list $svr_newv
	}
	
	//-- Store all strings for easier later retrieval
	global svr_newv_all `"$svr_newv_all $svr_newv"'
	
}
//-- recode
di "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
di "We just finished Generating `it_var' Variables, here is their joint summary"
di "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
d $svr_newv_all, f
summ $svr_newv_all
pwcorr $svr_newv_all, sig


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
