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

  When we run regressions, what change:
  1. LHS
  2. RHS
  3. Conditioning
  4. Regression Method

  We hope to store regression results to an estimates table that has columns and panels. Each column in each panel represents the results from one regression. This is a fully generic regression function.

  The way program works is that:
  1. define default strings for each regression ingredient
  2. for panel and column, if we want column and panel specific conditions, if they are defined, then they override generic
  3. could define for each ingredient, col specific, panel specific, or column and panel specific regressions

*/

///--- File Names
global st_file_root "~\Stata4Econ\reglin\multipanel\allpurpose\"
global st_log_file "${st_file_root}allpurpose"

global st_tab_rtf  "${st_file_root}allpurpose_tab.rtf"
global st_tab_html "${st_file_root}allpurpose_tab.html"
global st_tab_tex  "${st_file_root}allpurpose_tab_texbody.tex"

///--- Start log
capture log close
log using "${st_log_file}" , replace
log on

set trace off
set tracedepth 1

/////////////////////////////////////////////////
///--- A0. Load Data
/////////////////////////////////////////////////

set more off
set trace off

sysuse auto, clear

  ///--- Controls
  global quiornot "qui"
  * global quiornot "noi"

  /////////////////////////////////////////////////
  ///--- A1. Core String Initiation
  /////////////////////////////////////////////////
  /*
    A regression has:
      1. reg method
      2. LHS
      3. RHS (to keep)
      4. RHS (controls not to show in table)
      5. Conditions
      6. reg options
  */

  * rgc = regression, opt = option
  global stc_rgc "reg"
  global stc_opt ", robust"

  * sca = what scalar statistics to obtain from reg
  global stc_sca "r2 rank"

  * cdn = conditioning
  global sif_cdn "if price !=. & foreign !=."

  * variable names lists
  global svr_lhs "price"
  global svr_rhs "rep78"
  global svr_cov "gear_ratio"
  global svr_kep "${svr_rhs}"

  /////////////////////////////////////////////////
  ///--- A2. Set Number of Rows and Columns
  /////////////////////////////////////////////////

  * column count, and panel count
  * can specify any numbers here, code will run for any col and row count
  global it_col_cnt = 7
  global it_pan_cnt = 6

  /////////////////////////////////////////////////
  ///--- A3. Labeling
  /////////////////////////////////////////////////
  
  * column title, panel title, and slb_pan_nte = panel notes
  global slb_col "price"
  global slb_pan "current panel results"
  global slb_pan_nte "general notes"

  * eso = esttab options
  global slb_eso "label mtitles p stats(N ${stc_sca}) star(* 0.10 ** 0.05 *** 0.01)"
  global slb_tex_eso "booktabs ${slb_eso}"

/////////////////////////////////////////////////
///--- B1. Column Specific Strings
/////////////////////////////////////////////////

  * Column titling, some columns get column specific titles
  global slb_col_3 "wgt"
  global slb_col_4 "areg"
  global slb_col_5 "gear <= 3"
  global slb_col_6 "reg"
  global slb_col_7 "areg"

  * change regression method for column 4
  global stc_rgc_col_4 "areg"
  global stc_opt_col_4 ", absorb(foreign)"
  global stc_rgc_col_7 "areg"
  global stc_opt_col_7 ", absorb(foreign)"

  * this means the third column's lhs var will be weight
  global svr_lhs_col_3 "weight"

  * below changing condition for 5th and 3rd column, append to existing conditions
  global sif_cdn_col_5 "& gear_ratio <= 3"
  global sif_cdn_col_3 `"& trunk != 5 & ~strpos(make, "Ford")"'

  * append these variables to column 4 and 5 estimations
  global svr_rhs_col_4 "weight"
  global svr_rhs_col_5 "turn"

/////////////////////////////////////////////////
///--- B2. Panel Specific Strings
/////////////////////////////////////////////////

  * Panel titling, 1 2 3 get panel specific titles, other use base
  global slb_pan_1 "Panel A, foreign == 0"  
  global slb_pan_2 "Panel B, foreign == 1"  
  global slb_pan_3 "Panel C, length >= 190"
  
  * Panel Specific Notes
  global slb_pan_nte_1 `""This panel only includes foreign == 0. Absorb no effects.""'
  global slb_pan_nte_2 `""This panel then focuses only on foreign == 1""'
  global slb_pan_nte_2 `"${slb_pan_nte_2} "Hi there, more notes next line""'
  global slb_pan_nte_5 `""This panel is the 5th" "Yes it is the 5th, so what""'
  
  * the 3rd panel and 6 panel lhs variable is mpg, note column override panel lhs
  global svr_lhs_pan_3 "mpg"
  global svr_lhs_pan_6 "mpg"

  * panel specific conditioning, appending to column and base conditioning
  global sif_cdn_pan_1 "& foreign == 0"
  global sif_cdn_pan_2 "& foreign == 1"
  global sif_cdn_pan_3 "& length >= 190"

  * panel specific rhs variables, append to column and base
  global svr_rhs_pan_1 "mpg headroom"
  global svr_rhs_pan_4 "mpg"

  * keeping
  global svr_kep_pan_1 "${svr_rhs_pan_1} ${svr_rhs_col_1} ${svr_rhs_col_5}"
  global svr_kep_pan_4 "${svr_rhs_pan_4} ${svr_rhs_col_1} ${svr_rhs_col_5}"

/////////////////////////////////////////////////
///--- B3. Panel and Column Specific Strings
/////////////////////////////////////////////////

  * RHS for panel 5 and column 4 will have two more covariates
  global svr_rhs_pan_5_col_4 "length turn"
  global svr_kep_pan_4 "${svr_kep_pan_4} ${svr_rhs_pan_5_col_4}"

/////////////////////////////////////////////////
///--- C. Define Regression Strings
/////////////////////////////////////////////////

  foreach it_pan_ctr of numlist 1(1)$it_pan_cnt {
  	foreach it_col_ctr of numlist 1(1)$it_col_cnt {

      ///--- Counters
      global it_col_ctr "`it_col_ctr'"
      global it_pan_ctr "`it_pan_ctr'"

      ///--- Reset Strings to Default Always, _u = use

      * if there are panel or column specific values, replace, eith col or row specific
      * generates: stc_rgc_u and stc_opt_u
      global stc_rgc_u "${stc_rgc}"
      global stc_opt_u "${stc_opt}"
  	  global svr_lhs_u "${svr_lhs}"
  	  global st_ls_rep "stc_rgc stc_opt svr_lhs"
        foreach st_seg in $st_ls_rep {
          global st_seg "`st_seg'"

      		* di `"${st_seg}_pan_${it_pan_ctr}: ${${st_seg}_pan_${it_pan_ctr}}"'
      		* di `"${st_seg}_col_${it_col_ctr}: ${${st_seg}_col_${it_col_ctr}}"'
      		* di `"${st_seg}_pan_${it_pan_ctr}_col_${it_col_ctr}: ${${st_seg}_pan_${it_pan_ctr}_col_${it_col_ctr}}"'

          if (`"${${st_seg}_pan_${it_pan_ctr}}"' != "") {
            global ${st_seg}_u `"${${st_seg}_pan_${it_pan_ctr}}"'
          }
          else if (`"${${st_seg}_col_${it_col_ctr}}"' != "") {
            global ${st_seg}_u `"${${st_seg}_col_${it_col_ctr}}"'
          }
          else if (`"${${st_seg}_pan_${it_pan_ctr}_col_${it_col_ctr}}"' != "") {
            global ${st_seg}_u `"${${st_seg}_pan_${it_pan_ctr}_col_${it_col_ctr}}"'
          }
  		* di `"${st_seg}_u: ${${st_seg}_u}"'
        }

      * if there are panel or column specific values, append
      global svr_rhs_u "${svr_rhs} ${svr_rhs_pan_${it_pan_ctr}} ${svr_rhs_col_${it_col_ctr}}"
      global svr_cov_u "${svr_cov} ${svr_cov_pan_${it_pan_ctr}} ${svr_cov_col_${it_col_ctr}}"
      global sif_cdn_u `"${sif_cdn} ${sif_cdn_pan_${it_pan_ctr}} ${sif_cdn_col_${it_col_ctr}}"'

      ///--- Compose Regression String
  	  global srg_pan_${it_pan_ctr}_col_${it_col_ctr} `"${stc_rgc_u} ${svr_lhs_u} ${svr_rhs_u} ${svr_cov_u} ${sif_cdn_u} ${stc_opt_u}"'

      ///--- Display Regression String
  	  di "PAN={$it_pan_ctr}, COL={$it_col_ctr}"
      di `"${srg_pan_${it_pan_ctr}_col_${it_col_ctr}}"'

  	}
  }

/////////////////////////////////////////////////
///--- D. Run Regressions
/////////////////////////////////////////////////

	eststo clear
	global it_reg_ctr = 0

	///--- Loop over panels
	foreach it_pan_ctr of numlist 1(1)$it_pan_cnt {

		///--- Counters
		global it_pan_ctr "`it_pan_ctr'"

		///--- Model Store Name
		global st_cur_sm_stor "smd_${it_pan_ctr}_m"
		global ${st_cur_sm_stor} ""

		///--- Loop over regression columns
		foreach it_col_ctr of numlist 1(1)$it_col_cnt {

			///--- Counters
			global it_col_ctr "`it_col_ctr'"

			global it_reg_ctr = ${it_reg_ctr} + 1
			global st_cur_srg_name "srg_pan_${it_pan_ctr}_col_${it_col_ctr}"

			///--- Regression String Name
			di "PAN={$it_pan_ctr}, COL={$it_col_ctr}, ${st_cur_srg_name}"
			di `"${${st_cur_srg_name}}"'

			///--- Reset Strings to Default Always
			global slb_col_u "${slb_col}"
			global st_ls_rep "slb_col"
			foreach st_seg in $st_ls_rep {
				global st_seg "`st_seg'"
				if ("${${st_seg}_${it_col_ctr}}" != "") {
					global ${st_seg}_u `"${${st_seg}_${it_col_ctr}}"'
				}
			}

			///--- Regress
			capture $quiornot {
				eststo m${it_reg_ctr}, title("${slb_col_u}") : ${$st_cur_srg_name}
			}
			if _rc!=0 {
				///--- This means this this regression failed, proceed with empty col
				* Generate a fake observation to create a new estimated model
				* Then replace the observation N by setting it to 0, otherwise N = 1
				capture drop aaa
				gen aaa = 0 if _n == 1
				eststo m${it_reg_ctr}, title("${slb_col_u}") : estpost tabstat aaa , statistics(n) c(s)
				estadd scalar N = 0, replace
			}

			///--- Estadd Controls
 			* foreach st_scalar_name in $stc_sca {
 			* 	estadd local ${st_scalar_name} e(${st_scalar_name})
 			* }

			///--- Track Regression Store
			global $st_cur_sm_stor "${${st_cur_sm_stor}} m${it_reg_ctr}"
		}
	}

	di "${${st_cur_sm_stor}}"

	///--- Regression Panel String list
	foreach it_pan_ctr of numlist 1(1)$it_pan_cnt {
		global it_pan_ctr "`it_pan_ctr'"
		global st_cur_sm_stor "smd_${it_pan_ctr}_m"
		di "${st_cur_sm_stor}"
	}

/////////////////////////////////////////////////
///--- E. Show Results
/////////////////////////////////////////////////

	foreach it_pan_ctr of numlist 1(1)$it_pan_cnt {
	
		global it_pan_ctr "`it_pan_ctr'"

		global slb_eso_u "${slb_eso}"
		global slb_tex_eso_u "${slb_tex_eso}"
		
		global slb_pan_u "${slb_pan}"
		global slb_pan_nte_u "${slb_pan_nte}"

		global st_ls_rep "slb_pan slb_pan_nte"
		foreach st_seg in $st_ls_rep {
			global st_seg "`st_seg'"
			if (`"${${st_seg}_${it_pan_ctr}}"' != "") {
				global ${st_seg}_u `"${${st_seg}_${it_pan_ctr}}"'
			}
		}

		global svr_kep_u "${svr_kep} ${svr_kep_pan_${it_pan_ctr}}"
		global st_esttab_opts_main `"addnotes(${slb_pan_nte_u}) title("${slb_pan_u}") keep(${svr_kep_u}) order(${svr_kep_u})"'
		global st_esttab_opts_tex `"${st_esttab_opts_main} ${slb_tex_eso_u}"'
		global st_esttab_opts_oth `"${st_esttab_opts_main} ${slb_eso_u}"'
		
		di "MODELS: ${smd_${it_pan_ctr}_m}"
		di `"st_esttab_opts_main: ${st_esttab_opts_main}"'
		
		///--- output to log
		esttab ${smd_${it_pan_ctr}_m}, ${st_esttab_opts_oth}
				
		///--- save results to html, rtf, as well as tex
		if ($it_pan_ctr == 1) {
			global st_replace "replace"
		}
		else {
			global st_replace "append"
		}		
		esttab ${smd_${it_pan_ctr}_m} using "${st_tab_html}", ${st_esttab_opts_oth} $st_replace
		esttab ${smd_${it_pan_ctr}_m} using "${st_tab_rtf}",  ${st_esttab_opts_oth} $st_replace
		esttab ${smd_${it_pan_ctr}_m} using "${st_tab_tex}",  ${st_esttab_opts_tex} $st_replace

	}

/////////////////////////////////////////////////
///--- F. Log to PDF etc
/////////////////////////////////////////////////

///--- End Log and to HTML
	log close
	capture noisily {
		log2html "${st_log_file}", replace
	}
	capture noisily {
		// translator query smcl2pdf
		translator set smcl2pdf logo off
		translator set smcl2pdf fontsize 8
		translator set smcl2pdf pagesize custom
		translator set smcl2pdf pagewidth 9
		translator set smcl2pdf pageheight 20
		translator set smcl2pdf lmargin 0.4
		translator set smcl2pdf rmargin 0.4
		translator set smcl2pdf tmargin 0.4
		translator set smcl2pdf bmargin 0.4
		translate "${st_log_file}.smcl" "${st_log_file}.pdf", replace translator(smcl2pdf)
	}
	capture noisily {
		erase "${st_log_file}.smcl"
	}
