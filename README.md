[![HitCount](http://hits.dwyl.io/fanwangecon/Stata4Econ.svg)](https://github.com/FanWangEcon/Stata4Econ)  [![Star](https://img.shields.io/github/stars/fanwangecon/Stata4Econ?style=social)](https://github.com/FanWangEcon/Stata4Econ/stargazers) [![Fork](https://img.shields.io/github/forks/fanwangecon/Stata4Econ?style=social)](https://github.com/FanWangEcon/Stata4Econ/network/members) [![Star](https://img.shields.io/github/watchers/fanwangecon/Stata4Econ?style=social)](https://github.com/FanWangEcon/Stata4Econ/watchers)

This is a work-in-progress [website](https://fanwangecon.github.io/Stata4Econ/) of sample Stata files, produced by [Fan](https://fanwangecon.github.io/). Materials gathered from various [projects](https://fanwangecon.github.io/research) in which STATA code is used. The goal of this repository is to make it easier to find/re-use codes produced for various projects.

STATA files are linked below by section. Various functions are stored in corresponding .do files. To use the files, clone the repository. Some files have examples/instructions created using Jupyter notebooks or STATA translator and are shown as HTML and PDF files. See [here](docs/gitsetup.md) for Github set up.

From [Fan](https://fanwangecon.github.io/)'s other repositories: For dynamic borrowing and savings problems, see [Dynamic Asset Repository](https://fanwangecon.github.io/CodeDynaAsset/); For example R code, see [R Panel Data Code](https://fanwangecon.github.io/R4Econ/), for example Matlab code, see [Matlab Example Code](https://fanwangecon.github.io/M4Econ/); For intro econ with Matlab, see [Intro Mathematics for Economists](https://fanwangecon.github.io/Math4Econ/), and for intro stat with R, see [Intro Statistics for Undergraduates](https://fanwangecon.github.io/Stat4Econ/). See [here](https://github.com/FanWangEcon) for all of [Fan](https://fanwangecon.github.io/)'s public repositories.

Please contact [FanWangEcon](https://fanwangecon.github.io/) for issues or problems.

[![](https://img.shields.io/github/last-commit/fanwangecon/Stata4Econ)](https://github.com/FanWangEcon/Stata4Econ/commits/master) [![](https://img.shields.io/github/commit-activity/m/fanwangecon/Stata4Econ)](https://github.com/FanWangEcon/Stata4Econ/graphs/commit-activity) [![](https://img.shields.io/github/issues/fanwangecon/Stata4Econ)](https://github.com/FanWangEcon/Stata4Econ/issues) [![](https://img.shields.io/github/issues-pr/fanwangecon/Stata4Econ)](https://github.com/FanWangEcon/Stata4Econ/pulls)

# 1. Regressions

## 1.1 All Purpose Regression Tool

1. [All Purpose N Columns M Panels Regression Structure](https://github.com/FanWangEcon/Stata4Econ/tree/master/reglin/multipanel/allpurpose)
    + *Code*: [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose.do) \| [**PDF Gen Tables Log**](https://fanwangecon.github.io/Stata4Econ/reglin/multipanel/allpurpose/allpurpose.pdf) \| [**HTML Gen Tables Log**](https://fanwangecon.github.io/Stata4Econ/reglin/multipanel/allpurpose/allpurpose.html)
    + *Output*: [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose_tab.pdf) \| [**HTML Table**](https://fanwangecon.github.io/Stata4Econ/reglin/multipanel/allpurpose/allpurpose_tab.html) \| [**DOC Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose_tab.rtf)
    + A regression table has these ingredients: **(1)** regression method **(2)** LHS **(3)** RHS (to keep) **(4)** RHS (controls not to show in table) **(5)** conditions **(6)** regression options **(7)** row and column title and footnotes labeling
    + Specify regression table column and panel specific ingredients for all, none, any row or column subsets freely
    + Versatile structure that can test large sets of regression specifications

## 1.2 Various Examples

1. [Discrete Interactions](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/discrete/fs_reg_d_interact.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/discrete/fs_reg_d_interact.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/reglin/discrete/fs_reg_d_interact.html) \| [**PDF**](https://fanwangecon.github.io/Stata4Econ/reglin/discrete/fs_reg_d_interact.pdf)
    + Regression with interacted discrete regressors
    + **core**: *regress + esttab*

# 2. Generate Table

## 2.1 Multiple Regression Panels

1. [Multiple Panels](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/tab_6col3pan.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/gen_reg.do) \| [**Gen Table Log**](https://fanwangecon.github.io/Stata4Econ/table/multipanel/tab_6col3pan/gen_reg.pdf) \| [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/tab_6col3pan.pdf) \| [**TEX Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/tab_6col3pan_texbody.tex)
    + Three panels, different regressors for each panel, different conditionings each column.
    + **core**: *regres + esttab*

## 2.2 Multiple Regression Panels with Interactions

1. [Continuous and Discrete Interactions](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/tab_6col_cts_dis2inter.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/gen_reg.do) \| [**Gen Table Log**](https://fanwangecon.github.io/Stata4Econ/table/multipanel/tab_6col_cts_dis2inter/gen_reg.pdf) \| [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/tab_6col_cts_dis2inter.pdf) \| [**TEX Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/tab_6col_cts_dis2inter_texbody.tex)
    + Three panels, different regressors for each panel, different conditionings each column.
    + **core**: *regres + esttab*

## 2.3 Cross Tabulation

1. [Continuous and Discrete Interactions](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/tabsumm/tab_mcol_npanel/tab_mcol_npanel.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/tabsumm/tab_mcol_npanel/gen_reg.do) \| [**Gen Table Log**](https://fanwangecon.github.io/Stata4Econ/table/tabsumm/tab_mcol_npanel/gen_reg.pdf) \| [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/tabsumm/tab_mcol_npanel/tab_mcol_npanel.pdf) \| [**TEX Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/tabsumm/tab_mcol_npanel/tab_mcol_npanel_texbody.tex)
    + Three row categories, two interacting column categories, statistics for multiple variables
    + **core**: *regres + estpost tabstat*

# 3. Dataset Wrangling

## 3.1 Generate and Replace

1. [Generate Re-group Categorical Variable](https://github.com/FanWangEcon/Stata4Econ/blob/master/gen/replace/fs_recode.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/gen/replace/fs_recode.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/gen/replace/fs_recode.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/gen/replace/fs_recode.pdf)
    + Change or Reduce the number of categories for a categorical variable.
    + 3 methods: a. recode; b. egen cut; c. inlist/inrange.
    + Semi-automated loop: reset relabel regroup many variables with some time saving.
    + **core**: *recode turn (min/35 = 1 "Turn <35") ... (46/max = 5 "Turn > 45") (else  =. ), gen(turn_m5); egen var = cut(turn), at(31(3)52) label; if inrange(turn, 31, 35), if inlist(turn, 46, 48, 51)*
2. [Within-Group Fill and Replace Values](https://github.com/FanWangEcon/Stata4Econ/blob/master/gen/group/fs_group.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/gen/group/fs_group.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/gen/group/fs_group.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/gen/group/fs_group.pdf)
    + Fill missing values in group by single nonmissing value in group.
    + **core**: *bys trunk (var_one_val_in_group): gen var_test_fill = var_one_val_in_group[1]*

## 3.2 Summary

1. [Multiple Variables Jointly Nonmissing](https://github.com/FanWangEcon/Stata4Econ/blob/master/summ/count/fs_nonmissing.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/summ/count/fs_nonmissing.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/summ/count/fs_nonmissing.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/summ/count/fs_nonmissing.pdf)
    + Find rows where there are no missing values for any variables in a list of variables and where certain conditionings are satisfied
    + **core**: *egen valid = rownonmiss($svr_list) if $scd_bse $scd_one $scd_two*

## 3.3 Random

1. [Drop Random Subset of Data](https://github.com/FanWangEcon/Stata4Econ/blob/master/rand/basic/fs_droprand.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/rand/basic/fs_droprand.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/rand/basic/fs_droprand.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/rand/basic/fs_droprand.pdf)
    + Drop random subset of data for different variables
    + **core**: *round((_n/_N) x it_drop_frac) == round(it_drop_frac x uniform())*


# 4. Programming

## 4.1 Basic

1. [Local, Global and Scalar](https://github.com/FanWangEcon/Stata4Econ/blob/master/prog/define/fs_boolean.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/prog/define/fs_boolean.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/prog/define/fs_boolean.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/prog/define/fs_boolean.pdf)
    + local, global and scalar as boolean controls
    + **core**: *local bl_includereg1 = 1, if (`bl_includereg1'); global bl_includereg3 = 0, if ($bl_includereg3); scalar bl_includereg5 = 0, if (bl_includereg5);*
2. [Loops](https://github.com/FanWangEcon/Stata4Econ/blob/master/prog/basics/fs_loop.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/prog/basics/fs_loop.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/prog/basics/fs_loop.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/prog/basics/fs_loop.pdf)
    + local, global and scalar as boolean controls
    + **core**: *#delimit; global ls "vara varb"; #delimit cr; foreach svr_outcome in $ls {}*

## 4.2 Matrix

1. [Define and Slice Matrix](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/matrix/define/basic.html) \| [**PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.pdf)
    + matrix definition and slicing, get column and row names, replace matrix subset.
    + **core**: *matrix + rownumb/colnumb +	matrix mt_bl_estd = J(it_rowcnt, it_colcnt, bl_fillval) + mat_a[1..., colnumb(mat_a, "reg1")] + ...*

# 5. Support

## 5.1 Logging

1. [LOG2HTML and Translator](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html_results.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html.do) \| [**Translator PDF**](https://fanwangecon.github.io/Stata4Econ/output/log/fs_log2html_results.pdf) \| [**SMCL Log PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html_results.pdf)
    + translator to export console buffer to PDF, or to export log file to pdf; log2html to convert to html.
    + **core**: *log2html + translate @Results*

----
Please contact [![](https://img.shields.io/github/followers/fanwangecon?label=FanWangEcon&style=social)](https://github.com/FanWangEcon) [![](https://img.shields.io/twitter/follow/fanwangecon?label=%20&style=social)](https://twitter.com/fanwangecon) for issues or problems.

![RepoSize](https://img.shields.io/github/repo-size/fanwangecon/Stata4Econ)
![CodeSize](https://img.shields.io/github/languages/code-size/fanwangecon/Stata4Econ)
![Language](https://img.shields.io/github/languages/top/fanwangecon/Stata4Econ)
![Release](https://img.shields.io/github/downloads/fanwangecon/Stata4Econ/total)
![License](https://img.shields.io/github/license/fanwangecon/Stata4Econ)
