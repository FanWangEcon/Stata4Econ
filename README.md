
# 1. Regressions

1. [Discrete Interactions](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/discrete/fs_reg_d_interact.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/discrete/fs_reg_d_interact.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/reglin/discrete/fs_reg_d_interact.html) \| [**PDF**](https://fanwangecon.github.io/Stata4Econ/reglin/discrete/fs_reg_d_interact.pdf)
    + Regression with interacted discrete regressors
    + **core**: *regres + esttab*

# 2. Table Generation

## 2.1 Multiple Panels with Interactions

1. [Multiple Panels](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/tab_6col3pan.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/gen_reg.do) \| [**Gen Table Log**](https://fanwangecon.github.io/Stata4Econ/table/multipanel/tab_6col3pan/gen_reg.pdf) \| [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/tab_6col3pan.pdf) \| [**TEX Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col3pan/tab_6col3pan_texbody.tex)
    + Three panels, different regressors for each panel, different conditionings each column.
    + **core**: *regres + esttab*

## 2.2 Multiple Panels with Interactions

1. [Continuous and Discrete Interactions](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/tab_6col_cts_dis2inter.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/gen_reg.do) \| [**Gen Table Log**](https://fanwangecon.github.io/Stata4Econ/table/multipanel/tab_6col_cts_dis2inter/gen_reg.pdf) \| [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/tab_6col_cts_dis2inter.pdf) \| [**TEX Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/table/multipanel/tab_6col_cts_dis2inter/tab_6col_cts_dis2inter_texbody.tex)
    + Three panels, different regressors for each panel, different conditionings each column.
    + **core**: *regres + esttab*

# 3. Programming

# 3.1 Matrix

1. [Define and Slice Matrix](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/matrix/define/basic.do) \| [**HTML**](https://fanwangecon.github.io/Stata4Econ/matrix/define/basic.html) \| [**PDF**](https://fanwangecon.github.io/Stata4Econ/matrix/define/basic.pdf)
    + matrix definition and slicing, get column and row names, replace matrix subset.
    + **core**: *matrix + rownumb/colnumb +	matrix mt_bl_estd = J(it_rowcnt, it_colcnt, bl_fillval) + mat_a[1..., colnumb(mat_a, "reg1")] + ...*

# 4. Support

# 4.1 Logging

1. [LOG2HTML and Translator](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html_results.pdf): [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html.do) \| [**Translator PDF**](https://fanwangecon.github.io/Stata4Econ/output/log/fs_log2html_results.pdf) \| [**SMCL Log PDF**](https://github.com/FanWangEcon/Stata4Econ/blob/master/output/log/fs_log2html_results.pdf)
    + translator to export console buffer to PDF, or to export log file to pdf; log2html to convert to html.
    + **core**: *log2html + translate @Results*
