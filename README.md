This is a work-in-progress [website](https://fanwangecon.github.io/Stata4Econ/) of sample Stata files, produced by [Fan](https://fanwangecon.github.io/). Materials gathered from various [projects](https://fanwangecon.github.io/research) in which STATA code is used. The goal of this repository is to make it easier to find/re-use codes produced for various projects.

STATA files are linked below by section. Various functions are stored in corresponding .do files. To use the files, clone the repository. Some files have examples/instructions created using Jupyter notebooks or STATA translator and are shown as HTML and PDF files. See [here](docs/gitsetup.md) for Github set up.

Please contact [FanWangEcon](https://fanwangecon.github.io/) for issues or problems.

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

# 3. Programming

## 3.1 Matrix

1. [Define and Slice Matrix](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/matrix/define/basic.html) \| [**PDF**](https://fanwangecon.github.io/Stata4Econ/matrix/define/basic.pdf)
    + matrix definition and slicing, get column and row names, replace matrix subset.
    + **core**: *matrix + rownumb/colnumb +	matrix mt_bl_estd = J(it_rowcnt, it_colcnt, bl_fillval) + mat_a[1..., colnumb(mat_a, "reg1")] + ...*

# 4. Support

## 4.1 Logging

1. [LOG2HTML and Translator](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html_results.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html.do) \| [**Translator PDF**](https://fanwangecon.github.io/Stata4Econ/output/log/fs_log2html_results.pdf) \| [**SMCL Log PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html_results.pdf)
    + translator to export console buffer to PDF, or to export log file to pdf; log2html to convert to html.
    + **core**: *log2html + translate @Results*
