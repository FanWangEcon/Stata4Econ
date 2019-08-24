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

  Stata matrix basic generation and matrix slicing

  1. Generate Matrix
  2. Replace single cell values from matrix
  3. Replace subset of matrix by row or column array
  4. Row and Column Names
  5. Retrieve matrix row and column values

*/

///--- Start log
set more off
capture log close

cd "${root_log}"
global curlogfile "~\Stata4Econ\matrix\define\basic"
log using "${curlogfile}" , replace
log on

///--- Generate matrix with all 0
	scalar it_rowcnt = 4
	scalar it_colcnt = 6
	scalar bl_fillval = 0
	matrix mt_bl_estd = J(it_rowcnt, it_colcnt, bl_fillval)

///--- Give Matrix Row and Column Names
	matrix rownames mt_bl_estd = hhfe vilfe provfe morecontrols
	matrix colnames mt_bl_estd = reg1 reg2 reg3 reg4 reg5 reg6

///--- Assign value to matrix cell single
	matrix mt_bl_estd[rownumb(mt_bl_estd, "hhfe"), colnumb(mt_bl_estd, "reg1")] = 1
	matrix mt_bl_estd[2,2] = 3

///--- Assign value to 4th row, 3nd to 6th
	matrix mt_bl_estd[4,3] = (9,8,7,6)

///--- Assign value to 4th column, 2nd 3rd values
	matrix mt_bl_estd[2,4] = (-3\-44.3)

///--- Obtain value from matrix
	scalar bl_hhfe_reg1 = mt_bl_estd[rownumb(mt_bl_estd, "hhfe"), colnumb(mt_bl_estd, "reg1")]
	di bl_hhfe_reg1
	di el(mt_bl_estd, rownumb(mt_bl_estd, "hhfe"), colnumb(mt_bl_estd, "reg1"))

///--- Select a column from matrix
	matrix mt_bl_estd_colreg1 = mt_bl_estd[1..., colnumb(mt_bl_estd, "reg1")]
	matrix list mt_bl_estd_colreg1

///--- Get Row and Column Names
	global st_colnames : colnames mt_bl_estd
	di "${st_colnames}"
	global st_rownames : rownames mt_bl_estd
	di "${st_rownames}"

///--- Show Matrix
	matrix list mt_bl_estd

///--- End Log and to HTML
log close
capture noisily {
  log2html "${curlogfile}", replace
}
///--- to PDF
capture noisily {
	// translator query Results2pdf
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
