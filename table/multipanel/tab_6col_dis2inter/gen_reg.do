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

	Regression with discrete variables, discrete variables could interact with each other


*/

///--- File Names
global st_file_root "~\Stata4Econ\table\multipanel\tab_6col_dis2inter\"
global st_log_file "${st_file_root}gen_reg"
global st_out_html "${st_file_root}tab_6col_dis2inter.html"
global st_out_rtf "${st_file_root}tab_6col_dis2inter.rtf"
global st_out_tex "${st_file_root}tab_6col_dis2inter_texbody.tex"

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

/////////////////////////////////////////////////
///--- A1. Define Regression Variables
/////////////////////////////////////////////////

	* shared regression outcome lhs variable
	global svr_outcome "bp"

	* for each panel, rhs variables differ
	global svr_rhs_panel_a "agegrp sex"
	global svr_rhs_panel_b "ib1.agegrp ib1.sex_when"
	global svr_rhs_panel_c "sex io(1 3).sex_when io(1 4).sex_agegrp"

	* for each column, conditioning differs
	global it_reg_n = 6
	global sif_col_1 "bp <= 185"
	global sif_col_2 "bp <= 180"
	global sif_col_3 "bp <= 175"
	global sif_col_4 "bp <= 170"
	global sif_col_5 "bp <= 165"
	global sif_col_6 "bp <= 160"

	* esttad strings for conditioning what were included
	scalar it_esttad_n = 4
	matrix mt_bl_estd = J(it_esttad_n, $it_reg_n, 0)
	matrix rownames mt_bl_estd = bpge185 bpge180 bpge170 bpge160
	matrix colnames mt_bl_estd = reg1 reg2 reg3 reg4 reg5 reg6
	matrix mt_bl_estd[1, 1] = (1\1\1\1)
	matrix mt_bl_estd[1, 2] = (0\1\1\1)
	matrix mt_bl_estd[1, 3] = (0\0\1\1)
	matrix mt_bl_estd[1, 4] = (0\0\1\1)
	matrix mt_bl_estd[1, 5] = (0\0\0\1)
	matrix mt_bl_estd[1, 6] = (0\0\0\1)
	global st_estd_rownames : rownames mt_bl_estd
	global slb_estd_1 "blood pressure >= 185"
	global slb_estd_2 "blood pressure >= 180"
	global slb_estd_3 "blood pressure >= 170"
	global slb_estd_4 "blood pressure >= 160"

/////////////////////////////////////////////////
///--- A2. Define Regression Technical Strings
/////////////////////////////////////////////////

///--- Technical Controls
	global stc_regc "regress"
	global stc_opts ", vce(robust)"

/////////////////////////////////////////////////
///--- B1. Define Regressions Panel A
/////////////////////////////////////////////////

	/*
		di "$srg_panel_a_col_1"
		di "$srg_panel_a_col_2"
		di "$srg_panel_a_col_6"
	*/
	foreach it_regre of numlist 1(1)$it_reg_n {
		#delimit;
		global srg_panel_a_col_`it_regre' "
		  $stc_regc $svr_outcome $svr_rhs_panel_a if ${sif_col_`it_regre'} $stc_opts
		  ";
		#delimit cr
		di "${srg_panel_a_col_`it_regre'}"
	}

/////////////////////////////////////////////////
///--- B2. Define Regressions Panel B
/////////////////////////////////////////////////

	/*
		di "$srg_panel_b_col_1"
		di "$srg_panel_b_col_2"
		di "$srg_panel_b_col_6"
	*/
	foreach it_regre of numlist 1(1)$it_reg_n {
		#delimit;
		global srg_panel_b_col_`it_regre' "
		  $stc_regc $svr_outcome $svr_rhs_panel_b if ${sif_col_`it_regre'} $stc_opts
		  ";
		#delimit cr
		di "${srg_panel_b_col_`it_regre'}"
	}

/////////////////////////////////////////////////
///--- B3. Define Regressions Panel C
/////////////////////////////////////////////////

	/*
		di "$srg_panel_c_col_1"
		di "$srg_panel_c_col_2"
		di "$srg_panel_c_col_6"
	*/

	foreach it_regre of numlist 1(1)$it_reg_n {
		#delimit;
		global srg_panel_c_col_`it_regre' "
		  $stc_regc $svr_outcome $svr_rhs_panel_c if ${sif_col_`it_regre'} $stc_opts
		  ";
		#delimit cr
		di "${srg_panel_c_col_`it_regre'}"
	}

/////////////////////////////////////////////////
///--- C. Run Regressions
/////////////////////////////////////////////////

	eststo clear
	local it_reg_ctr = 0
	foreach st_panel in panel_a panel_b panel_c {

	  global st_cur_sm_stor "smd_`st_panel'_m"
	  global ${st_cur_sm_stor} ""

	  foreach it_regre of numlist 1(1)$it_reg_n {

		  local it_reg_ctr = `it_reg_ctr' + 1
		  global st_cur_srg_name "srg_`st_panel'_col_`it_regre'"

		  di "st_panel:`st_panel', it_reg_ctr:`it_reg_ctr', st_cur_srg_name:${st_cur_srg_name}"

		  ///--- Regression
		  eststo m`it_reg_ctr', title("${sif_col_`it_regre'}") : ${$st_cur_srg_name}

		  ///--- Estadd Controls
			foreach st_estd_name in $st_estd_rownames {
				scalar bl_estad = el(mt_bl_estd, rownumb(mt_bl_estd, "`st_estd_name'"), `it_regre')
				if (bl_estad) {
					estadd local `st_estd_name' "Yes"
				}
				else {
					estadd local `st_estd_name' "No"
				}
			}

		  ///--- Track Regression Store
		  global $st_cur_sm_stor "${${st_cur_sm_stor}} m`it_reg_ctr'"
	  }

	  di "${${st_cur_sm_stor}}"

	}

	di "$smd_panel_a_m"
	di "$smd_panel_b_m"
	di "$smd_panel_c_m"

/////////////////////////////////////////////////
///--- D1. Labeling
/////////////////////////////////////////////////

///--- Title overall
	global slb_title "Outcome: Blood Pressure"
	global slb_title_inner "\textbf{Categories}: Discrete Categories and BP"
	global slb_label_tex "tab:scminter"

///--- Several RHS Continuous Variables
	global slb_panel_a "Panel A: Continuous Right Hand Side Variables"

///--- Continuous Variables + Several Discrete Variables
	global slb_panel_b "Panel B: Two Discrete Right Hand Side Variables"
	global slb_panel_b_ga "Age Groups (Compare to 30-45)"
	global slb_panel_b_gb "Gender/Time Groups (Compare to Female Before)"

///--- Continuous Variables + Several Discrete Variables Interated with More Discrete Variables
	global slb_panel_c "Panel C: Two Discrete Interacted Variables"
	global slb_panel_c_sa "Male Dummy Interactions:"
	global slb_panel_c_sb "Female Dummy Interactions:"
	global slb_panel_c_sa_ga "Time Groups (Compare to Before)"
	global slb_panel_c_sa_gb "Age Groups (Compare to 30-45)"
	global slb_panel_c_sb_ga "Time Groups (Compare to Before)"
	global slb_panel_c_sb_gb "Age Groups (Compare to 30-45)"

///--- Notes
	global slb_bottom "Controls for each panel:"
	global slb_note "${slb_starLvl}. Robust standard errors. Each column is a spearate regression."

///--- Show which coefficients to keep
	#delimit;
	global svr_coef_keep_panel_a "
	  agegrp sex
	  ";
	global svr_coef_keep_panel_b "
		2.agegrp 3.agegrp
		2.sex_when 3.sex_when 4.sex_when
	  ";
	global svr_coef_keep_panel_c "

		sex

		2.sex_when
		2.sex_agegrp 3.sex_agegrp

		4.sex_when
		5.sex_agegrp 6.sex_agegrp
	  ";
	#delimit cr

///--- Labeling for for Coefficients to Show
	global slb_title_spc "\vspace*{-5mm}\hspace*{-8mm}"
	global slb_dis_tlt_spc "\vspace*{-5mm}\hspace*{-8mm}"
	global slb_dis_ele_spc "\vspace*{0mm}\hspace*{5mm}"
	global slb_1st_ele_spc "\vspace*{0mm}\hspace*{5mm}"
	global slb_fot_lst_spc "\vspace*{0mm}\hspace*{2mm}"

	#delimit;
	global svr_starts_var_panel_a "agegrp";
	global slb_coef_label_panel_a "
		agegrp "${slb_1st_ele_spc}age group"
		sex "${slb_1st_ele_spc}sex variable"
	  ";
	#delimit cr

	#delimit;
	global svr_starts_var_panel_b "2.agegrp";
	global svr_starts_var_panel_b_ga "2.agegrp";
	global svr_starts_var_panel_b_gb "2.sex_when";
	global slb_coef_label_panel_b "
		2.agegrp "${slb_dis_ele_spc} x (46-59 yrs)"
		3.agegrp "${slb_dis_ele_spc} x (>60 years)"
		2.sex_when "${slb_dis_ele_spc} x male after"
		3.sex_when "${slb_dis_ele_spc} x female before"
		4.sex_when "${slb_dis_ele_spc} x female after"
	  ";
	#delimit cr

	#delimit;
	global svr_starts_var_panel_c "sex";
	global svr_starts_var_panel_c_sa "2.sex_when";
	global svr_starts_var_panel_c_sa_ga "2.sex_when";
	global svr_starts_var_panel_c_sa_gb "2.sex_agegrp";
	global svr_starts_var_panel_c_sb "4.sex_when";
	global svr_starts_var_panel_c_sb_ga "4.sex_when";
	global svr_starts_var_panel_c_sb_gb "5.sex_agegrp";
	global slb_coef_label_panel_c "

		sex "${slb_1st_ele_spc}male dummy"

		2.sex_when "${slb_dis_ele_spc} x male x after"
		2.sex_agegrp "${slb_dis_ele_spc} x male x (46-59 yrs)"
		3.sex_agegrp "${slb_dis_ele_spc} x male x (>60 years)"

		4.sex_when "${slb_dis_ele_spc} x male x after"
		5.sex_agegrp "${slb_dis_ele_spc} x female x (46-59 yrs)"
		6.sex_agegrp "${slb_dis_ele_spc} x female x (>60 years)"

	  ";
	#delimit cr

/////////////////////////////////////////////////
///--- D2. Regression Display Controls
/////////////////////////////////////////////////

	global slb_reg_stats "N ${st_estd_rownames}"

	global slb_starLvl "* 0.10 ** 0.05 *** 0.01"
	global slb_starComm "nostar"

	global slb_sd_tex `"se(fmt(a2) par("\vspace*{-2mm}{\footnotesize (" ") }"))"'
	global slb_cells_tex `"cells(b(star fmt(a2)) $slb_sd_tex)"'
	global slb_esttab_opt_tex "booktabs label collabels(none) nomtitles nonumbers star(${slb_starLvl})"

	global slb_sd_txt `"se(fmt(a2) par("(" ")"))"'
	global slb_cells_txt `"cells(b(star fmt(a2)) $slb_sd_txt)"'
	global slb_esttab_opt_txt "stats(${slb_reg_stats}) collabels(none) mtitle nonumbers varwidth(30) modelwidth(15) star(${slb_starLvl}) addnotes(${slb_note})"

	#delimit ;
	global slb_panel_a_main "
		title("${slb_panel_a}")
		keep(${svr_coef_keep_panel_a}) order(${svr_coef_keep_panel_a})
		coeflabels($slb_coef_label_panel_a)
		";

	global slb_panel_b_main "
		title("${slb_panel_b}")
		keep(${svr_coef_keep_panel_b}) order(${svr_coef_keep_panel_b})
		coeflabels($slb_coef_label_panel_b)
		";

	global slb_panel_c_main "
		title("${slb_panel_c}")
		keep(${svr_coef_keep_panel_c}) order(${svr_coef_keep_panel_c})
		coeflabels($slb_coef_label_panel_c)
		";
	#delimit cr

/////////////////////////////////////////////////
///--- E. Regression Shows
/////////////////////////////////////////////////

	esttab ${smd_panel_a_m}, ${slb_panel_a_main} ${slb_esttab_opt_txt}
	esttab ${smd_panel_b_m}, ${slb_panel_b_main} ${slb_esttab_opt_txt}
	esttab ${smd_panel_c_m}, ${slb_panel_c_main} ${slb_esttab_opt_txt}

/////////////////////////////////////////////////
///--- F1. Define Latex Column Groups and Column Sub-Groups
/////////////////////////////////////////////////

	///--- Column Groups
	global it_max_col = 8
	global it_min_col = 2
	global it_col_cnt = 6
	global colSeq "2 4 6 8"
// 	global st_cmidrule "\cmidrule(lr){2-3}\cmidrule(lr){4-5}\cmidrule(lr){6-7}"
	global st_cmidrule "\cmidrule(lr){2-7}"

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
	global labColWid = 5

	///--- Column Fractional Adjustment, 1 = 100%
	global tableAdjustBoxWidth = 1.0

/////////////////////////////////////////////////
///--- F2. Tabling Calculations
/////////////////////////////////////////////////

	///--- Width Calculation
	global totCoefColWid = ${perCoefColWid}*${it_col_cnt}
	global totColCnt = ${it_col_cnt} + 1
	global totColWid = ${labColWid} + ${totCoefColWid} + ${perCoefColWid}
	global totColWidFootnote = ${labColWid} + ${totCoefColWid} + ${perCoefColWid} + ${perCoefColWid}/2
	global totColWidLegend = ${labColWid} + ${totCoefColWid} + ${perCoefColWid}
	global totColWidLegendthin = ${totCoefColWid} + ${perCoefColWid}

	di "it_col_cnt:$it_col_cnt"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"
	di "totCoefColWid:$totCoefColWid"

	global ampersand ""
	foreach curLoop of numlist 1(1)$it_col_cnt {
	  global ampersand "$ampersand &"
	}
	di "ampersand:$ampersand"

	global alignCenter "m{${labColWid}cm}"
	local eB1 ">{\centering\arraybackslash}m{${perCoefColWid}cm}"
	foreach curLoop of numlist 1(1)$it_col_cnt {
	  global alignCenter "$alignCenter `eB1'"
	}
	di "alignCenter:$alignCenter"

/////////////////////////////////////////////////
///--- G1a. Tex Sectioning panel A
/////////////////////////////////////////////////

	#delimit ;
	global slb_titling_panel_a "
		${svr_starts_var_panel_a} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_panel_a}}} \\"
		";
	global slb_refcat_panel_a `"refcat(${slb_titling_panel_a}, nolabel)"';
	#delimit cr

/////////////////////////////////////////////////
///--- G1b. Tex Sectioning panel B
/////////////////////////////////////////////////

	if ("${svr_starts_var_panel_b}" == "${svr_starts_var_panel_b_ga}") {
		#delimit ;
		global svr_starts_pb_andga "
			${svr_starts_var_panel_b}
				"\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_panel_b}}} \\
				 \multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_b_ga}}} \\"
			";
		#delimit cr
	}
	else {
		#delimit ;
		global svr_starts_pb_andga "
			${svr_starts_var_panel_b}
				"\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_panel_b}}} \\"
			${svr_starts_var_panel_b_ga}
				"\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_b_ga}}} \\"
			";
		#delimit cr
	}

	#delimit ;
	global slb_titling_panel_b "
		${svr_starts_pb_andga}
		${svr_starts_var_panel_b_gb}
			"\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_b_gb}}} \\"
		";
	global slb_refcat_panel_b `"refcat(${slb_titling_panel_b}, nolabel)"';
	#delimit cr

/////////////////////////////////////////////////
///--- G1c. Tex Sectioning panel C
/////////////////////////////////////////////////

if (("${svr_starts_var_panel_c}" == "${svr_starts_var_panel_c_sa}") & ("${svr_starts_var_panel_c_sa}" == "${svr_starts_var_panel_c_sa_ga}") ) {
///--- if main = sub headings = subsub heading
	#delimit ;
	global slb_titling_panel_c "
		${svr_starts_var_panel_c} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_panel_c}}} \\
																	\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textbf{\textit{${slb_panel_c_sa}}}} \\
																	\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sa_ga}}} \\"
		${svr_starts_var_panel_c_sa_gb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sa_gb}}} \\"
		${svr_starts_var_panel_c_sb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textbf{\textit{${slb_panel_c_sb}}}} \\
																	\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sb_ga}}} \\"
		${svr_starts_var_panel_c_sb_gb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sb_gb}}} \\"
		";
	global slb_refcat_panel_c `"refcat(${slb_titling_panel_c}, nolabel)"';
	#delimit cr
}
else if ("${svr_starts_var_panel_c_sa}" == "${svr_starts_var_panel_c_sa_ga}") {
///--- if main, sub headings differ, but subsub = sub heading
	#delimit ;
	global slb_titling_panel_c "
		${svr_starts_var_panel_c} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_panel_c}}} \\"
		${svr_starts_var_panel_c_sa} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textbf{\textit{${slb_panel_c_sa}}}} \\
																	\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sa_ga}}} \\"
		${svr_starts_var_panel_c_sa_gb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sa_gb}}} \\"
		${svr_starts_var_panel_c_sb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textbf{\textit{${slb_panel_c_sb}}}} \\
																	\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sb_ga}}} \\"
		${svr_starts_var_panel_c_sb_gb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sb_gb}}} \\"
		";
	global slb_refcat_panel_c `"refcat(${slb_titling_panel_c}, nolabel)"';
	#delimit cr
}
else {
///--- if main, sub, subsub heading vars differ
	#delimit ;
	global slb_titling_panel_c "
		${svr_starts_var_panel_c} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_title_spc}\textbf{${slb_panel_c}}} \\"
		${svr_starts_var_panel_c_sa} "${st_cmidrule}\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textbf{\textit{${slb_panel_c_sa}}}} \\"
		${svr_starts_var_panel_c_sa_ga} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sa_ga}}} \\"
		${svr_starts_var_panel_c_sa_gb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sa_gb}}} \\"
		${svr_starts_var_panel_c_sb} "${st_cmidrule}\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textbf{\textit{${slb_panel_c_sb}}}} \\"
		${svr_starts_var_panel_c_sb_ga} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sb_ga}}} \\"
		${svr_starts_var_panel_c_sb_gb} "\multicolumn{$totColCnt}{L{${totColWidLegend}cm}}{${slb_dis_tlt_spc}\textit{${slb_panel_c_sb_gb}}} \\"
		";
	global slb_refcat_panel_c `"refcat(${slb_titling_panel_c}, nolabel)"';
	#delimit cr
}

/////////////////////////////////////////////////
///--- G1d. Bottom
/////////////////////////////////////////////////

	#delimit ;
	global slb_titling_bottom `"
	stats(N $st_estd_rownames,
			labels(Observations
			"\midrule \multicolumn{${totColCnt}}{L{${totColWid}cm}}{${slb_title_spc}\textbf{\textit{\normalsize ${slb_bottom}}}} \\ $ampersand \\ ${slb_fot_lst_spc}${slb_estd_1}"
			"${slb_fot_lst_spc}${slb_estd_2}"
			"${slb_fot_lst_spc}${slb_estd_3}"
			"${slb_fot_lst_spc}${slb_estd_4}"))"';
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

			global curRow2 "\multicolumn{$gapCnt}{L{${gapWidth}cm}}{\small ${labG${colCtr}}}"
			global row2 "$row2 & $curRow2"

		}
		local lastCol = `curCol'

	}

	///--- C. Row 3
	* Initial & for label column
	foreach curLoop of numlist 1(1)$it_col_cnt {
		global curText "${labC`curLoop'}"
		global textUse "(`curLoop')"
		if ("$curText" != "") {
			global textUse "$curText"
		}
		global curRow3 "\multicolumn{1}{C{${perCoefColWid}cm}}{$textUse}"
		global row3 "$row3 & $curRow3"
	}

	///--- D. Row 1 and midline:
	global row1 "${row1} \multicolumn{${it_col_cnt}}{L{${totCoefColWid}cm}}{${slb_title_inner}}"
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
			\addlinespace[-0.5em]
			\multicolumn{${totColCnt}}{L{${totColWidFootnote}cm}}{\footnotesize\justify${slb_note}}\\
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

	esttab ${smd_panel_a_m} using "${st_out_html}", ${slb_panel_a_main} ${slb_esttab_opt_txt} replace
	esttab ${smd_panel_b_m} using "${st_out_html}", ${slb_panel_b_main} ${slb_esttab_opt_txt} append
	esttab ${smd_panel_c_m} using "${st_out_html}", ${slb_panel_c_main} ${slb_esttab_opt_txt} append

/////////////////////////////////////////////////
///--- H2. Output Results to RTF
/////////////////////////////////////////////////

	esttab ${smd_panel_a_m} using "${st_out_rtf}", ${slb_panel_a_main} ${slb_esttab_opt_txt} replace
	esttab ${smd_panel_b_m} using "${st_out_rtf}", ${slb_panel_b_main} ${slb_esttab_opt_txt} append
	esttab ${smd_panel_c_m} using "${st_out_rtf}", ${slb_panel_c_main} ${slb_esttab_opt_txt} append

/////////////////////////////////////////////////
///--- H3. Output Results to Tex
/////////////////////////////////////////////////

	esttab $smd_panel_a_m using "${st_out_tex}", ///
		${slb_panel_a_main} ///
 		${slb_refcat_panel_a} ///
		${slb_esttab_opt_tex} ///
		fragment $headlineAll postfoot("") replace

	esttab $smd_panel_b_m using "${st_out_tex}", ///
		${slb_panel_b_main} ///
 		${slb_refcat_panel_b} ///
		${slb_esttab_opt_tex} ///
		fragment prehead("") postfoot("") append

	esttab $smd_panel_c_m using "${st_out_tex}", ///
		${slb_panel_c_main} ///
 		${slb_refcat_panel_c} ///
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
