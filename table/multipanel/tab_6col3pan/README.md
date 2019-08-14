
Multiple columns, each including different conditioning, or different RHS variables etc.

Mutiple Coefficients to report as rows.

Multiple panels to show results with different groups of regressions.

regress y x1 x2 if z

- columns different z conditioning or options, share column titling as well as crossing belows
- rows coefficients for x1
- panels, regression with different RHS variables, changing what x1 coefficients to report

# Program Structure for Full transparency

It should be possible to easily go back to the table generation file, and see exactly what variables etc were included for regression etc.

So conditioning etc that change variables etc, anywhere where variables are named etc should happen within the file.

There should be a single file where all take place


# Porgram outline

Define shared information first, then define panel specific information.

Explicitly define function names etc.

1. Define Titling and Sectional Heading
2. Define Column Group Names and Individual Column Names, define column bottom crossing names
3. Define Regressions Fully Panel by Panel along with Panel Headings
4. Run Regressions etc and done. 
