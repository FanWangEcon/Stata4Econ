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

	Regression with continous varible and discrete variables, discrete variables could interact with each other, and interact with continuous variable
*/

///--- File Names
global st_file_root "~\Stata4Econ\table\tabsumm\tab_mcol_npanel\"
global st_log_file "${st_file_root}gen_reg"
global st_out_html "${st_file_root}tab_mcol_npanel.html"
global st_out_rtf "${st_file_root}tab_mcol_npanel.rtf"
global st_out_tex "${st_file_root}tab_mcol_npanel_texbody.tex"

///--- Start log
capture log close
log using "${st_log_file}" , replace
log on

set trace off
set tracedepth 1

/////////////////////////////////////////////////
///--- Load Data
/////////////////////////////////////////////////

set more off
sysuse bplong, clear

tab sex
tab agegrp
tab when

tab sex when
tab sex agegrp

egen sex_when = group(sex when), label
egen sex_agegrp = group(sex agegrp), label
egen when_agegrp = group(when agegrp), label

drop if agegrp == 2 & sex_when == 3

set seed 123
gen rand1 = floor(runiform()*2)
gen rand2 = floor(runiform()*20)
gen rand3 = floor(runiform()*3000)

/////////////////////////////////////////////////
///--- A1. Define Regression Variables
/////////////////////////////////////////////////

	* shared variables to summarize over
	global svr_summ "bp patient rand1 rand2"

	* for each column, conditioning differs
	global it_colcate_n = 4
	global it_rowcate_n = 3

	global sif_colcate_1 "sex_when == 1"
	global sif_colcate_2 "sex_when == 2"
	global sif_colcate_3 "sex_when == 3"
	global sif_colcate_4 "sex_when == 4"

	global sif_rowcate_1 "agegrp == 1"
	global sif_rowcate_2 "agegrp == 2"
	global sif_rowcate_3 "agegrp == 3"

/////////////////////////////////////////////////
///--- A2. Titling
/////////////////////////////////////////////////

	global slb_title "Cross Tabulate Age, Gender and Time Statistics"
	global slb_title_inner "Tabulate Stats: \textbf{Mean} (\textit{S.D.})"
	global slb_label_tex "tab:sctabsumm"

/////////////////////////////////////////////////
///--- A3. Row Labeling
/////////////////////////////////////////////////

///--- Row Tab Names	
	global slb_rowcate_1 "Group 1: Age 30 to 45"
	global slb_rowcate_2 "Group 2: Age 46 to 59"
	global slb_rowcate_3 "Group 3: Age >60"

///--- Var Subgroup Subtitling	
	global slb_subvargrp_1 "Summ Group One (cts)"
	global slb_subvargrp_2 "Summ Group Two (discrete)"

///--- Labeling for each variable
	global slb_var_spc "\hspace*{3mm}"
	label variable bp "${slb_var_spc}Blood pressure"
	label variable patient "${slb_var_spc}Patient ID"
	label variable rand1 "${slb_var_spc}Random \textit{Male} or \textit{Female}"
	label variable rand2 "${slb_var_spc}Random Three Cates \textbf{after}"
	label variable rand3 "${slb_var_spc}Random Thousands"

///--- Labeling Head Tag	
	global svr_first "bp"
	global svr_first_subvargrp_1 "bp"
	global svr_first_subvargrp_2 "rand1"
	
/////////////////////////////////////////////////
///--- A4. Column Labeling
/////////////////////////////////////////////////

	///--- Column Groups
	global colSeq "2 4 6"
	global st_cmidrule "\cmidrule(lr){2-3}\cmidrule(lr){4-5}"

	///--- Group 1, columns 1 and 2
	global labG1 "Male"
	global labC1 "{\small Before}"
	global labC2 "{\small After}"

	///--- Group 2, columns 3 and 4
	global labG2 "Female"
	global labC3 "{\small Before}"
	global labC4 "{\small After}"

	///--- Column Widths
	global perCoefColWid = 1.75
	global labColWid = 7
	global slb_title_spc "\vspace*{-3mm}"
	global slb_foot_spc "\vspace*{-3mm}"

	///--- Column Fractional Adjustment, 1 = 100%
	global tableAdjustBoxWidth = 1.0

/////////////////////////////////////////////////
///--- A5. Additional Statistics
/////////////////////////////////////////////////

///--- Notes
	global slb_bottom "Controls for each panel:"
	global slb_note "Summary statistics cross tabulate for various variables. Table shows mean and standard deviation for each group in parenthesis."

/////////////////////////////////////////////////
///--- A6. Define Summarizing Technical Strings
/////////////////////////////////////////////////

///--- Technical Controls
	global stc_regc "estpost tabstat"
	global stc_opts ", statistics(mean sd p10 p50 p90) c(s)"
	global stc_stats_main "mean"
	global stc_stats_paren "sd"
	
/////////////////////////////////////////////////
///--- B1. Define Stats Summary for Each Tabulate Category
/////////////////////////////////////////////////

	/*
		di "$srg_cate_row1_col1"
		di "$srg_cate_row2_col2"
		di "$srg_cate_row1_col2"
	*/

	foreach it_rowcate of numlist 1(1)$it_rowcate_n {
		foreach it_colcate of numlist 1(1)$it_colcate_n {
			#delimit;
				global srg_cate_row`it_rowcate'_col`it_colcate' "
				$stc_regc $svr_summ if ${sif_colcate_`it_colcate'} & ${sif_rowcate_`it_rowcate'}
			";
			#delimit cr
			di "${srg_cate_row`it_rowcate'_col`it_colcate'}"
		}
	}

/////////////////////////////////////////////////
///--- C. Run Regressions
/////////////////////////////////////////////////

	eststo clear
	local it_tabcell_ctr = 0
	foreach it_rowcate of numlist 1(1)$it_rowcate_n {

		global st_cur_sm_store "smd_`it_rowcate'_m"
		global ${st_cur_sm_store} ""

		foreach it_colcate of numlist 1(1)$it_colcate_n {

			local it_tabcell_ctr = `it_tabcell_ctr' + 1
			global st_cur_srg_name "srg_cate_row`it_rowcate'_col`it_colcate'"

			di "it_rowcate:`it_rowcate', it_tabcell_ctr:`it_tabcell_ctr', st_cur_srg_name:${st_cur_srg_name}"

			///--- Summ Stats
			count if ${sif_colcate_`it_colcate'} & ${sif_rowcate_`it_rowcate'}
			global curcount = r(N)
			if ($curcount>1) {		  
				eststo m`it_tabcell_ctr', title("${sif_colcate_`it_colcate'}") : ${$st_cur_srg_name} ${stc_opts}
			}
			else {
				///--- This means this tabulated subgroup has N = 0
				* Generate a fake observation to create a new estimated model
				* Then replace the observation N by setting it to 0, otherwise N = 1
				capture drop aaa
				gen aaa = 0 if _n == 1
				eststo m`it_tabcell_ctr', title("${sif_colcate_`it_colcate'}") : estpost tabstat aaa , statistics(n) c(s)
				estadd scalar N = 0, replace
			}
			
			///--- Track Regression Store
			global $st_cur_sm_store "${${st_cur_sm_store}} m`it_tabcell_ctr'"
			
		}

		di "${${st_cur_sm_store}}"

	}

	di "$smd_1_m"
	di "$smd_2_m"
	di "$smd_3_m"

/////////////////////////////////////////////////
///--- D2. Regression Display Controls
/////////////////////////////////////////////////

	global slb_reg_stats "N"

	global sd `""'	
	global keepcellstats "cells(mean(fmt(a2)) $sd) wide"

	global slb_sd_tex `"${stc_stats_paren}(fmt(a2) par("\vspace*{-2mm}{\footnotesize (" ") }"))"'
	global slb_cells_tex `"cells(${stc_stats_main}(fmt(a2)) $slb_sd_tex) wide"'
	global slb_esttab_opt_tex "${slb_cells_tex} booktabs label collabels(none) nomtitles nonumbers star(${slb_starLvl})"

	global slb_sd_txt `"${stc_stats_paren}(fmt(a2) par("(" ")"))"'
	global slb_cells_txt `"cells(${stc_stats_main}(fmt(a2)) $slb_sd_txt) wide"'
	global slb_esttab_opt_txt "${slb_cells_txt} stats(${slb_reg_stats}) collabels(none) mtitle nonumbers varwidth(30) modelwidth(15) star(${slb_starLvl}) addnotes(${slb_note})"

/////////////////////////////////////////////////
///--- E. Summ Stats Shows
/////////////////////////////////////////////////
	
	foreach it_rowcate of numlist 1(1)$it_rowcate_n {
		esttab ${smd_`it_rowcate'_m}, title("${slb_rowcate_`it_rowcate'}") ${slb_esttab_opt_txt}
	}
	
/////////////////////////////////////////////////
///--- F2. Tabling Calculations
/////////////////////////////////////////////////

	///--- Width Calculation
	global totCoefColWid = ${perCoefColWid}*${it_colcate_n}
	global totColCnt = ${it_colcate_n} + 1
	global totColWid = ${labColWid} + ${totCoefColWid}
	global totColWidFootnote = ${labColWid} + ${totCoefColWid}
	global totColWidLegend = ${labColWid} + ${totCoefColWid}
	global totColWidLegendthin = ${totCoefColWid} 

	di "it_colcate_n:$it_colcate_n"
	di "totCoefColWid:$totCoefColWid"

	global ampersand ""
	foreach curLoop of numlist 1(1)$it_colcate_n {
	  global ampersand "$ampersand &"
	}
	di "ampersand:$ampersand"

	global alignCenter "m{${labColWid}cm}"
	local eB1 ">{\centering\arraybackslash}m{${perCoefColWid}cm}"
	foreach curLoop of numlist 1(1)$it_colcate_n {
	  global alignCenter "$alignCenter `eB1'"
	}
	di "alignCenter:$alignCenter"

/////////////////////////////////////////////////
///--- G1a. Tex Sectioning each panel
/////////////////////////////////////////////////
	
	foreach it_rowcate of numlist 1(1)$it_rowcate_n {
	
		#delimit ;
		global slb_titling_panel_`it_rowcate' "
			${svr_first} "\multicolumn{$totColCnt}{p{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_rowcate_`it_rowcate'}}} \\"
			";
		global slb_refcat_panel_`it_rowcate' `"refcat(${slb_titling_panel_`it_rowcate'}, nolabel)"';
		#delimit cr
	}
	
/////////////////////////////////////////////////
///--- G1d. Bottom
/////////////////////////////////////////////////

	#delimit ;
	global slb_titling_bottom `"
	stats(N,
			labels(Observations
			"\midrule \multicolumn{${totColCnt}}{L{${totColWid}cm}}{${slb_title_spc}\textbf{\textit{\normalsize ${slb_bottom}}}}"))"';
	#delimit cr

/////////////////////////////////////////////////
///--- G2. Tex Headline
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
	foreach curLoop of numlist 1(1)$it_colcate_n {
		global curText "${labC`curLoop'}"
		global textUse "(`curLoop')"
		if ("$curText" != "") {
			global textUse "$curText"
		}
		global curRow3 "\multicolumn{1}{C{${perCoefColWid}cm}}{$textUse}"
		global row3 "$row3 & $curRow3"
	}

	///--- D. Row 1 and midline:
	global row1 "${row1} \multicolumn{${it_colcate_n}}{p{${totCoefColWid}cm}}{${slb_title_inner}}"
	global row1MidLine "\cmidrule(l{5pt}r{5pt}){${minCoefCol}-${curCol1Min}}"

	///--- C.3.E Print lines
	di "$row1 \\"
	di "$row1MidLine "
	di "$row2 \\"
	di "$row2MidLine"
	di "$row3 \\"

	///--- C.4 Together
	#delimit ;

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
			\multicolumn{${totColCnt}}{p{${totColWidFootnote}cm}}{${slb_foot_spc} \footnotesize\justify ${slb_note}}\\
		";

	global startTable "\begin{table}[htbp]
			\centering
			\caption{${slb_title}\label{${slb_label_tex}}}${adjustBoxStart}\begin{tabular}{`centering'}
			\toprule
			";

	global headlineAll "prehead(${startTable}${headline})";
	global headlineAllNoHead "prehead(${startTable})";
	global postAll "postfoot(\bottomrule ${notewrap} \end{tabular}${adjustBoxEnd}\end{table})";

	#delimit cr

/////////////////////////////////////////////////
///--- H1. Output Results to HTML
/////////////////////////////////////////////////

	esttab ${smd_1_m} using "${st_out_html}", title("${slb_rowcate_`it_rowcate'}") ${slb_esttab_opt_txt} replace
	esttab ${smd_1_m} using "${st_out_rtf}", title("${slb_rowcate_`it_rowcate'}") ${slb_esttab_opt_txt} replace
	foreach it_rowcate of numlist 2(1)$it_rowcate_n {
		esttab ${smd_`it_rowcate'_m} using "${st_out_html}", title("${slb_rowcate_`it_rowcate'}") ${slb_esttab_opt_txt} append
		esttab ${smd_`it_rowcate'_m} using "${st_out_rtf}", title("${slb_rowcate_`it_rowcate'}") ${slb_esttab_opt_txt} append
	}
	
/////////////////////////////////////////////////
///--- H2. Output Results to Tex
/////////////////////////////////////////////////

	esttab ${smd_1_m} using "${st_out_tex}", ///
		title("${slb_rowcate_1}") ///
		${slb_refcat_panel_1} ///
		${slb_esttab_opt_tex} ///
		fragment $headlineAll postfoot("") replace
		
	global it_rowcate_n_mins_1 = $it_rowcate_n - 1	
	foreach it_rowcate of numlist 2(1)$it_rowcate_n_mins_1 {
	
		esttab ${smd_`it_rowcate'_m} using "${st_out_tex}", ///
			title("${slb_rowcate_`it_rowcate'}") ///
			${slb_refcat_panel_`it_rowcate'} ///
			${slb_esttab_opt_tex} ///
			fragment prehead("") postfoot("") append
			
	}
	
	esttab ${smd_${it_rowcate_n}_m} using "${st_out_tex}", ///
		title("${slb_rowcate_${it_rowcate_n}}") ///
		${slb_refcat_panel_${it_rowcate_n}} ///
		${slb_esttab_opt_tex} ///
		${slb_titling_bottom} ///
		fragment prehead("") $postAll append
	

/////////////////////////////////////////////////
///--- I. Out Logs
/////////////////////////////////////////////////

///--- End Log and to HTML
log close

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
	translate @Results "${st_log_file}.pdf", replace translator(Results2pdf)
}
capture noisily {
  erase "${st_log_file}.smcl"
}
