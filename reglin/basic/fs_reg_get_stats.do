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

  1. Get statistics from regression, for example the p value
  2. Show alll subgroup coefficients in one regression
*/

///--- Start log
set more off
capture log close
cd "${root_log}"
global curlogfile "~\Stata4Econ\reglin\basic\fs_reg_get_stats"
log using "${curlogfile}" , replace
log on

///--- Load Data
set more off
sysuse auto, clear

tab rep78
tab foreign

///--- Regression
regress weight ib3.rep78 if foreign == 0

///--- Get r(table) Column Names
global colnames : colnames r(table)
di "$colnames"
global rownames : rownames r(table)
di "$rownames"

///--- Regression Statistics as matrix
matrix list r(table)
matrix rtable = r(table)

//-- Get All p values
matrix pval_row = rtable[rownumb(rtable, "pvalue"), 1...]
matrix list pval_row

//-- Get One Particular pValue
di colnumb(rtable, "5.rep78")
di rownumb(rtable, "pvalue")
global pval = rtable[rownumb(rtable, "pvalue"), colnumb(rtable, "5.rep78")]
di "$pval"

///--- End Log and to HTML
log close
capture noisily {
  log2html "${curlogfile}", replace
}

///--- to PDF
capture noisily {
	translator set Results2pdf logo off
	translator set Results2pdf fontsize 8
	translator set Results2pdf pagesize letter
	translator set Results2pdf lmargin 0.2
	translator set Results2pdf rmargin 0.2
	translator set Results2pdf tmargin 0.2
	translator set Results2pdf bmargin 0.2
	translate @Results "${curlogfile}.pdf", replace translator(Results2pdf)
}
capture noisily {
  erase "${curlogfile}.smcl"
}
