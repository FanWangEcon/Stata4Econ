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
global st_link "/prog/basics/fs_loop"
global curlogfile "~/Stata4Econ/${st_link}"
global st_logname "stata_fs_loop"
log using "${curlogfile}" , replace name($st_logname)
log on $st_logname

///-- Site Link: Fan's Project Reusable Stata Codes Table of Content
di "https://fanwangecon.github.io/"
di "https://fanwangecon.github.io/Stata4Econ/"

///-- File Title
global filetitle "Loop Over String and Numeric Vectors in Stata"

///////////////////////////////////////////////////////////////////////////////
///--- Loop over String
///////////////////////////////////////////////////////////////////////////////

#delimit;
global ls_svr_outcome "
	el_i_mand_talk_m2a el_i_mand_talk_m2b el_i_mand_talk_m2c
	el_i_mand_write_m2a el_i_mand_write_m2b el_i_mand_write_m2c
	el_i_mnew_m2a el_i_mnew_m2b
	el_i_nnet_m2a el_i_nnet_m2b
	";
#delimit cr

local it_counter = 0
foreach svr_outcome in $ls_svr_outcome {
	local it_counter = `it_counter' + 1
	di "`it_counter'th item of string list: `svr_outcome'"
}

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
