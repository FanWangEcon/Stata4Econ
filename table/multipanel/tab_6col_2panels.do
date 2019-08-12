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

  1. Get statistics from regression, for example the p value
  2. Show alll subgroup coefficients in one regression
*/


///--- Start log
capture log close
cd "${root_log}"
global curlogfile "~\Stata4Econ\table\multipanel\tab_6col_2panels"
log using "${curlogfile}" , replace
log on

set trace off

///--- Load Data
set more off
sysuse auto, clear
tab rep78
tab foreign


/////////////////////////////////////////////////
///--- A1. Define Regression Variables
/////////////////////////////////////////////////

	global svr_outcome "price"

	global svr_rhs_panel_a "mpg ib1.rep78 displacement gear_ratio"
	global svr_rhs_panel_b "headroom mpg trunk weight displacement gear_ratio"
	global svr_rhs_panel_c "headroom turn length weight trunk"

	global sif_col_1 "weight <= 4700"
	global sif_col_2 "weight <= 4500"
	global sif_col_3 "weight <= 4300"
	global sif_col_4 "weight <= 4100"
	global sif_col_5 "weight <= 3900"
	global sif_col_6 "weight <= 3700"

/////////////////////////////////////////////////
///--- A2. Define Regression Technical Strings
/////////////////////////////////////////////////

///--- Technical Controls
	global stc_regc "regress"
	global stc_opts ", noc"

/////////////////////////////////////////////////
///--- B1. Define Regressions Panel A
/////////////////////////////////////////////////

	foreach it_regre of numlist 1(1)6 {
		#delimit;	
		global srg_panel_a_col_`it_regre' "
		  $stc_regc $svr_outcome $svr_rhs_panel_a if $sif_col_`it_regre' $stc_opts
		  ";
		#delimit cr
	}
	
	di "$srg_panel_a_col_1"
	di "$srg_panel_a_col_2"
	di "$srg_panel_a_col_3"
	di "$srg_panel_a_col_4"
	di "$srg_panel_a_col_5"
	di "$srg_panel_a_col_6"

/////////////////////////////////////////////////
///--- B2. Define Regressions Panel B
/////////////////////////////////////////////////

	foreach it_regre of numlist 1(1)6 {
		#delimit;
		global srg_panel_b_col_`it_regre' "
		  $stc_regc $svr_outcome $svr_rhs_panel_b if $sif_col_`it_regre' $stc_opts
		  ";
		#delimit cr
	}
	
	di "$srg_panel_b_col_1"
	di "$srg_panel_b_col_2"
	di "$srg_panel_b_col_3"
	di "$srg_panel_b_col_4"
	di "$srg_panel_b_col_5"
	di "$srg_panel_b_col_6"

/////////////////////////////////////////////////
///--- B3. Define Regressions Panel C
/////////////////////////////////////////////////

	foreach it_regre of numlist 1(1)6 {
		#delimit;
		global srg_panel_c_col_`it_regre' "
		  $stc_regc $svr_outcome $svr_rhs_panel_c if $sif_col_`it_regre' $stc_opts
		  ";
		#delimit cr
	}
	
	di "$srg_panel_c_col_1"
	di "$srg_panel_c_col_2"
	di "$srg_panel_c_col_3"
	di "$srg_panel_c_col_4"
	di "$srg_panel_c_col_5"
	di "$srg_panel_c_col_6"
	
	
/////////////////////////////////////////////////
///--- C. Run Regressions
/////////////////////////////////////////////////
		
qui {
	eststo clear
	local it_reg_ctr = 0
	foreach it_panel of numlist 1 2 3 {

	  if (`it_panel' == 1) {
		local st_panel "panel_a"
	  }
	  if (`it_panel' == 2) {
		local st_panel "panel_b"
	  }
	  if (`it_panel' == 3) {
		local st_panel "panel_c"
	  }

	  global st_cur_sm_stor "smd_`st_panel'_m"
	  global ${st_cur_sm_stor} ""

	  foreach it_regre of numlist 1(1)6 {

		  local it_reg_ctr = `it_reg_ctr' + 1
		  global st_cur_srg_name "srg_`st_panel'_col_`it_regre'"

		  ///--- Regression
		  eststo m`it_reg_ctr', title("${sif_col_`it_regre'}") : ${$st_cur_srg_name}

		  ///--- Estadd Controls
		  if (`it_regre' == 1) {
			estadd local provage "No"
			estadd local countfe "No"
		  }
		  if (`it_regre' == 2) {
			estadd local provage "No"
			estadd local countfe "No"
		  }
		  if (`it_regre' == 3) {
			estadd local provage "Yes"
			estadd local countfe "Yes"
		  }
		  if (`it_regre' == 4) {
			estadd local provage "Yes"
			estadd local countfe "Yes"
		  }
		  if (`it_regre' == 5) {
			estadd local provage "No"
			estadd local countfe "No"
		  }
		  if (`it_regre' == 6) {
			estadd local provage "Yes"
			estadd local countfe "Yes"
		  }

		  ///--- Track Regression Store
		  global $st_cur_sm_stor "${${st_cur_sm_stor}} m`it_reg_ctr'"
	  }

	  di "${${st_cur_sm_stor}}"

	}
}
	di "$smd_panel_a_m"
	di "$smd_panel_b_m"
	di "$smd_panel_c_m"

/////////////////////////////////////////////////
///--- D1. Labeling
/////////////////////////////////////////////////

///--- Title overall
	global slb_title "Outcome: Attending School or Not"
	global slb_panel_a "Group A: Coefficients for Distance to Elementary School Variables"
	global slb_panel_b "Group B: Coefficients for Elementary School Physical Quality Variables"
	global slb_panel_c "Group C: More Coefficientss"
	global slb_note "${slb_starLvl}. Standard Errors clustered at village level. Each Column is a spearate regression."

///--- Show which coefficients to keep
	#delimit;
	global svr_coef_keep_panel_a "
	  mpg
	  2.rep78 3.rep78
	  4.rep78 5.rep78
	  ";
	global svr_coef_keep_panel_b "
	  headroom
	  mpg
	  trunk
	  weight
	  ";
	global svr_coef_keep_panel_c "
	  turn
	  ";	  
	#delimit cr

///--- Labeling for for Coefficients to Show
	#delimit;
	global svr_starts_var_panel_a "mpg";
	global slb_coef_label_panel_a "
	  mpg "miles per gallon"
	  2.rep78 "rep78 is 2"
	  3.rep78 "rep78 is 3"
	  4.rep78 "rep78 is 4"
	  5.rep78 "rep78 is 5"
	  ";
	#delimit cr
	
	#delimit;
	global svr_starts_var_panel_b "headroom";
	global slb_coef_label_panel_b "
	  headroom "headroom variable"
	  mpg "miles per gallon"
	  trunk "this is the trunk variable"
	  weight "and here the weight variable"
	  ";
	#delimit cr

	#delimit;
	global svr_starts_var_panel_c "turn";
	global slb_coef_label_panel_c "
	  turn "variable is turn"
	  ";
	#delimit cr
	
/////////////////////////////////////////////////
///--- D2. Regression Display Controls
/////////////////////////////////////////////////

	global slb_starLvl "* 0.10 ** 0.05 *** 0.01"
	global slb_starComm "nostar"

	global slb_sd `"se(fmt(a2) par("\vspace*{-2mm}{\footnotesize (" ") }"))"'
	global slb_cells `"cells(b(star fmt(a2)) $slb_sd)"'

	global slb_sd_local `"se(fmt(a2) par("(" ")"))"'
	global slb_cells_local `"cells(b(star fmt(a2)) $slb_sd_local)"'

	global slb_esttab_local_opt "collabels(none) mtitle nonumbers varwidth(30) modelwidth(15)"

/////////////////////////////////////////////////
///--- E. Regression Shows
/////////////////////////////////////////////////

	esttab $smd_panel_a_m , ///
		title("${slb_panel_a}") ///
		keep(${svr_coef_keep_panel_a}) order(${svr_coef_keep_panel_a}) ///
		coeflabels($slb_coef_label_panel_a) ///
		stats(N provage countfe) ///
		star($starLvl) $slb_cells_local ///		
		${slb_esttab_local_opt} addnotes(${slb_note})
			
	esttab $smd_panel_b_m , ///
		title("${slb_panel_b}") ///
		keep(${svr_coef_keep_panel_b}) order(${svr_coef_keep_panel_b}) ///
		coeflabels($slb_coef_label_panel_b) ///
		stats(N provage countfe) ///
		star($starLvl) $slb_cells_local ///		
		${slb_esttab_local_opt} addnotes(${slb_note})

	esttab $smd_panel_c_m , ///
		title("${slb_panel_c}") ///
		keep(${svr_coef_keep_panel_c}) order(${svr_coef_keep_panel_c}) ///
		coeflabels($slb_coef_label_panel_c) ///
		stats(N provage countfe) ///
		star($starLvl) $slb_cells_local ///		
		${slb_esttab_local_opt} addnotes(${slb_note})		

/////////////////////////////////////////////////
///--- F1. Define Latex Column Groups and Column Sub-Groups
/////////////////////////////////////////////////

	///--- Column Groups
	global it_max_col = 8
	global it_min_col = 2
	global colSeq "2 4 6 8"

	///--- Group 1, columns 1 and 2
	global labG1 "All Age 5 to 12"
	global labC1 "{\small All Villages}"
	global labC2 "{\small No Teachng Points}"

	///--- Group 2, columns 3 and 4
	global labG2 "Girls Age 5 to 12"
	global labC3 "{\small All Villages}"
	global labC4 "{\small No Teachng Points}"

	///--- Group 3, columns 5 and 6
	global labG3 "Boys Age 5 to 12"
	global labC5 "{\small All Villages}"
	global labC6 "{\small No Teachng Points}"

	///--- Column Widths
	global perCoefColWid = 1.85
	global labColWid = 6.75

	///--- Column Fractional Adjustment, 1 = 100%
	global tableAdjustBoxWidth = 1.0

/////////////////////////////////////////////////
///--- F2. Tabling Calculations
/////////////////////////////////////////////////

	///--- Width Calculation
	global totCoefColWid = ${perCoefColWid}*${totCoefColCnt}
	global totColCnt = $totCoefColCnt + 1
	global totColWid = ${labColWid} + ${totCoefColWid} + ${perCoefColWid}
	global totColWidFootnote = ${labColWid} + ${totCoefColWid} + ${perCoefColWid} + ${perCoefColWid}/2
	global totColWidLegend = ${labColWid} + ${totCoefColWid} + ${perCoefColWid}
	global totColWidLegendthin = ${totCoefColWid} + ${perCoefColWid}

	di "totCoefColCnt:$totCoefColCnt"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"

/////////////////////////////////////////////////
///--- G1. Tex Sectioning
/////////////////////////////////////////////////
	
	global rcSpaceInit "\vspace*{-5mm}\hspace*{-3mm}"
	
	#delimit ;	
	global slb_titling_panel_a "
		${slb_coef_label_panel_a} "\multicolumn{$totColCnt}{L{${totColWidLegendthin}cm}}{${rcSpaceInit}\textbf{${slb_panel_a}}} \\"
		";
	global slb_refcat_panel_a `"refcat(${slb_titling_panel_a}, nolabel)"';
	#delimit cr
	
	#delimit ;
	global slb_titling_panel_b "
		${slb_coef_label_panel_b} "\multicolumn{$totColCnt}{L{${totColWidLegendthin}cm}}{${rcSpaceInit}\textbf{${slb_panel_b}}} \\"
		";
	global slb_refcat_panel_b `"refcat(${slb_titling_panel_b}, nolabel)"';
	#delimit cr

	#delimit ;
	global slb_titling_panel_c "
		${slb_coef_label_panel_c} "\multicolumn{$totColCnt}{L{${totColWidLegendthin}cm}}{${rcSpaceInit}\textbf{${slb_panel_c}}} \\"
		";
	global slb_refcat_panel_c `"refcat(${slb_titling_panel_c}, nolabel)"';
	#delimit cr
	
/////////////////////////////////////////////////
///--- G2. Tex Align
/////////////////////////////////////////////////

	global ampersand ""
	foreach curLoop of numlist 1(1)$totCoefColCnt {
	  global ampersand "$ampersand &"
	}
	di "$ampersand"

	global alignCenter "m{${labColWid}cm}"
	local eB1 ">{\centering\arraybackslash}m{${perCoefColWid}cm}"
	foreach curLoop of numlist 1(1)$totCoefColCnt {
	  global alignCenter "$alignCenter `eB1'"
	}
	di "$alignCenter"

/////////////////////////////////////////////////
///--- G3. Tex Headline
/////////////////////////////////////////////////

	///--- C.3.A. Initialize
	global row1 "&"
	global row1MidLine ""
	global row2 ""
	global row2MidLine ""
	global row3 ""

	///--- B. Row 2 and row 2 midline
	* global colSeq "2 3 6"
	global cmidrule ""
	global colCtr = -1
	foreach curCol of numlist $colSeq {

		global colCtr = $colCtr + 1
		global curCol1Min = `curCol' - 1
		if ($colCtr == 0 ) {
			global minCoefCol = "`curCol'"
		}
		if ($colCtr != 0 ) {
			global gapCnt = (`curCol' - `lastCol')
			global gapWidth = (`curCol' - `lastCol')*$perCoefColWid
			di "curCol1Min:$curCol1Min, lastCol:`lastCol'"
			di "$gapCnt"

			di "\multicolumn{$gapCnt}{C{${gapWidth}cm}}{\small no Control}"
			di "\cmidrule(l{5pt}r{5pt}){`lastCol'-$curCol1Min}"

			global curRow2MidLine "\cmidrule(l{5pt}r{5pt}){`lastCol'-$curCol1Min}"
			global row2MidLine "$row2MidLine $curRow2MidLine"

			global curRow2 "\multicolumn{$gapCnt}{C{${gapWidth}cm}}{\small ${labG${colCtr}}}"
			global row2 "$row2 & $curRow2"

		}
		local lastCol = `curCol'

	}

	///--- C. Row 3
	* Initial & for label column
	foreach curLoop of numlist 1(1)$totCoefColCnt {
		global curText "${labC`curLoop'}"
		global textUse "(`curLoop')"
		if ("$curText" != "") {
			global textUse "$curText"
		}
		global curRow3 "\multicolumn{1}{C{${perCoefColWid}cm}}{$textUse}"
		global row3 "$row3 & $curRow3"
	}

	///--- D. Row 1 and midline:
	global row1 "${row1} \multicolumn{${totCoefColCnt}}{C{${totCoefColWid}cm}}{${allCoefRowHeading}}"
	global row1MidLine "\cmidrule(l{5pt}r{5pt}){${minCoefCol}-${curCol1Min}}"

	///--- C.3.E Print lines
	di "$row1 \\"
	di "$row1MidLine "
	di "$row2 \\"
	di "$row2MidLine"
	di "$row3 \\"

	///--- C.4 Together
	#delimit ;

	local fileTitle "${MainCaption}";
	local tableLabelName "${labelName}";

	///--- 1. Section
	* local section "
		* \section{`fileTitle'}\vspace*{-6mm}
		* ";

	///--- 2. Align and Column Define
	local centering "$alignCenter";

	global headline "
			$row1 \\
			$row1MidLine
			$row2 \\
			$row2MidLine
			$row3 \\
		";

	#delimit cr

/////////////////////////////////////////////////
///--- G4. Head
/////////////////////////////////////////////////

	#delimit ;

	global adjustBoxStart "\begin{adjustbox}{max width=${tableAdjustBoxWidth}\textwidth}";
	global adjustBoxEnd "\end{adjustbox}";

	global notewrap "
			\addlinespace[-0.5em]
			\multicolumn{${totColCnt}}{L{${totColWidFootnote}cm}}{
				\footnotesize
				\justify
				$notelong} \\
		";

	global startTable "\begin{table}[htbp]
			\centering
			\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}
			\caption{`fileTitle'\label{`tableLabelName'}}
			${adjustBoxStart}
			\begin{tabular}{`centering'}
			\toprule
			";

	global headlineAll "prehead(${startTable}${headline})";
	global headlineAllNoHead "prehead(${startTable})";
	global postAll "postfoot(\bottomrule ${notewrap} \end{tabular}${adjustBoxEnd}\end{table})";

	#delimit cr

/////////////////////////////////////////////////
///--- H1. Latex Controls
/////////////////////////////////////////////////

	global slb_starLvl "* 0.10 ** 0.05 *** 0.01"
	global slb_starComm "nostar"

	global slb_esttab_tex_opt "collabels(none) nomtitles nonumbers booktabs"
	global slb_esttab_tex_opt "stats(N provage countfe) star($starLvl) $slb_cells ${slb_esttab_tex_opt} "
		
/////////////////////////////////////////////////
///--- H2. Output Results to Tex
/////////////////////////////////////////////////

	esttab $smd_panel_a_m using "${curlogfile}.tex", ///
		title("${slb_panel_a}") ///
		keep(${svr_coef_keep_panel_a}) order(${svr_coef_keep_panel_a}) ///
		coeflabels($slb_coef_label_panel_a) ///
		$slb_refcat_panel_a ///
		$slb_esttab_tex_opt ///		
		fragment ///
		$headlineAll postfoot("") replace
			
	esttab $smd_panel_b_m using "${curlogfile}.tex", ///
		title("${slb_panel_b}") ///
		keep(${svr_coef_keep_panel_b}) order(${svr_coef_keep_panel_b}) ///
		coeflabels($slb_coef_label_panel_b) ///
		$slb_refcat_panel_b ///
		$slb_esttab_tex_opt ///		
		fragment ///
		prehead("") postfoot("") append

	esttab $smd_panel_c_m using "${curlogfile}.tex", ///
		title("${slb_panel_c}") ///
		keep(${svr_coef_keep_panel_c}) order(${svr_coef_keep_panel_c}) ///
		coeflabels($slb_coef_label_panel_c) ///
		$slb_refcat_panel_c ///
		$slb_esttab_tex_opt ///
		addnotes(${slb_note}) ///		
		prehead("") $postAll append

		
/////////////////////////////////////////////////
///--- I. Out Logs
/////////////////////////////////////////////////
		
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
		
