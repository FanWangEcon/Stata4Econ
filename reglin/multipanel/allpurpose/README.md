This is the *All Purpose N Columns M Panels Regression Structure* folder in [Fan](https://fanwangecon.github.io/)'s [Stata4Econ](https://fanwangecon.github.io/Stata4Econ/) git folder. Materials gathered from various [projects](https://fanwangecon.github.io/research) in which STATA code is used. Please contact [FanWangEcon](https://fanwangecon.github.io/) for issues or problems.

## All Purpose N Columns M Panels Regression Structure

Multiple Panels, Multiple Columns regression results. Similar to [multipanel](https://github.com/FanWangEcon/Stata4Econ/tree/master/table/multipanel) under the table folder. The PDF outputs here are less fancy looking. The idea is that a regression table has these ingredients:

1. regression method
2. LHS
3. RHS (to keep)
4. RHS (controls not to show in table)
5. conditions
6. regression options
7. row and column title and footnotes labeling

The program here allows one to:

+ Specify regression table column and panel specific ingredients for all, none, any row or column subsets freely
+ Versatile structure that can test large sets of regression specifications

## File Links

[All Purpose N Columns M Panels Regression Structure](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose.pdf):

+ *Code*: [**DO**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose.do) \| [**PDF Gen Tables Log**](https://fanwangecon.github.io/Stata4Econ/reglin/multipanel/allpurpose/allpurpose.pdf) \| [**HTML Gen Tables Log**](https://fanwangecon.github.io/Stata4Econ/reglin/multipanel/allpurpose/allpurpose.html)
+ *Output*: [**PDF Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose_tab.pdf) \| [**HTML Table**](https://fanwangecon.github.io/Stata4Econ/reglin/multipanel/allpurpose/allpurpose_tab.html) \| [**DOC Table**](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose_tab.rtf)

The file [allpurpose_prog.do](https://github.com/FanWangEcon/Stata4Econ/blob/master/reglin/multipanel/allpurpose/allpurpose_prog.do) contains the core reusable component of the all purpose regression files.
