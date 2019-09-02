// do "C:\Users\fan\Stata4Econ\reglin\multipanel\allpurpose\allpurpose_prog.do"
// content file of allpurpose.do

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
