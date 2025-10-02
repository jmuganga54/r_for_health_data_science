## Topic
In this session, we will discuss:  

* [2.1 What is R?](#21-what-is-r)
* [2.2 R versus Excel](#22-r-versus-excel)
* [2.3 Installing R and RStudio](#23-installing-r-and-rstudio)
* [2.4 R Scripts](#24-r-scripts)
* [2.5 R as a Calculator](#25-r-as-a-calculator)
* [2.6 Installing and loading R packages to add more functions](#26-installing-and-loading-r-packages-to-add-more-functions)
* [2.7 I need some help!](#27-i-need-some-help)
* [2.8 Common R functions](#28-common-r-functions)

## keywords & Notes

### 2.1 What is R?

R is a computer programming language with many built-in statistical functions. The language can be easily extended with user-written functions. R can also be used to produce high quality visualisations and plots.

>[!NOTE]
> Read More: [History of R](https://bookdown.org/rdpeng/rprogdatascience/history-and-overview-of-r.html)

### 2.2 R versus Excel

Excel is good for simple data entry and quick row or column adjustments, but it is not reliable for serious statistical analysis. This is because:

  * It handles missing values inconsistently.
  
  * Data must often be reorganised differently for each type of analysis.
  
  * Many analyses can only be done one column at a time.
  
  * Results are poorly organised, not well labelled, and lack a record of the steps used.
  
  * Some analyses are either too complex or impossible in Excel.


### 2.3 Installing R and RStudio

* R is the programming language, and RStudio is the IDE (tool) that makes working with R easier and faster.

* First, install R from the R [website](https://www.stats.bris.ac.uk/R/), then install RStudio from the [RStudio website](https://posit.co/download/rstudio-desktop/#download). R must be installed before RStudio.

* Default install settings are fine. A useful manual is [“An Introduction to R”](https://www.stats.bris.ac.uk/R/) (available online or via R’s Help menu).

* RStudio interface has 4 panes:
  
  * Script/code area – write and save your code.
  
  * Console – run commands and see results.
  
  * Workspace/history – shows loaded data and past commands.
  
  * Files/plots/packages/help – manage files, view plots, install packages, and access help.

>[!NOTE]
> In short: Install R, then RStudio. RStudio has four panes (script, console, workspace, and files/plots/help) that make coding, analysis, and plotting in R much easier.

### 2.4 R Scripts

* R works like a calculator but needs precise typing—most errors come from typos.

* Use the console for quick commands, but use scripts (File > New File > R Script) to write, save, and re-run code.

* Best practice: start RStudio with a clean environment

  * Go to Tools > Global Options > General
  
  * Under Workspace, untick “Restore .RData into workspace at startup”
  
  * Set “Save workspace to .RData on exit” to Never

  * Use `#` to add comments and notes in your code.

>[!NOTE]
> In short: Type carefully, work in scripts, adjust RStudio settings for a clean start, and comment your code.


### 2.5 R as a Calculator

In R, you can perform calculations just like on a calculator. Use brackets to control order of operations, which follow standard BIDMAS rules. 

  * Brackets – do what is inside brackets first.
  
  * Indices – powers or roots (e.g., ^ for powers, sqrt() for roots).
  
  * Division and Multiplication – from left to right.
  
  * Addition and Subtraction – from left to right.

>[!NOTE]
> In BIDMAS, D (Division) and M (Multiplication) are at the same level of priority.

> That means you do them in the order they appear, from left to right, not one before the other.

> Same to: Addition and Subtraction

For example:

```
8 + (3 * 6)    # gives 26
4^3            # 4 cubed = 64
2 + 4*20/10    # gives 10

```

R works with vectors, which are sequences of elements of the same type. The [1] before results shows the first element in the vector. You can create sequences with the colon operator:

```
1:8     # 1 to 8
5.5:2   # sequence from 5.5 down to 2

```

You can also compare values using Boolean operators, which return TRUE or FALSE:

```
54 > 45     # TRUE
1 < 2       # TRUE
15 == 15    # TRUE
50 >= 51    # FALSE

```

R includes built-in constants and math functions:

```
pi          # 3.141593
sqrt(pi)    # square root of pi
pi * (10^2) # area of circle with r=10
cos(2*pi)   # 1

```

Key notes:

  * R is case sensitive.
  
  * Commands run line by line.
  
  * Use `#` for comments (ignored by R).
  
  * Use the up/down arrows to recall past commands.

>[!TIP] 
>Try typing these snippets into a script and run them to see how R handles math, vectors, and logic.

### 2.6 Installing and loading R packages to add more functions

One of the main reasons `R` is so popular is its huge collection of user-written packages, available through CRAN and Bioconductor. 

Packages extend `R’s functionality`, from advanced statistics to data import and visualization. You only need to install a package once, but you must load it each time you want to use it. 

A widely used collection is the `tidyverse`, which bundles several powerful packages for data science. You can install it via the console:

```
install.packages("tidyverse")   # install once

```

Then load it whenever needed:

```
library(tidyverse)  # load for current session

```

In `RStudio`, you can also install packages through the `Packages tab` by clicking Install.

Always ensure your R version supports the package; otherwise, update R or install an older compatible version. The variety of packages is vast, enabling tasks from importing data to creating advanced graphics.


### 2.7 I need some help!

R has a powerful help and support system that makes it easier to learn and troubleshoot. In RStudio, you can access it through the Help tab in the bottom-right window. If you are unsure of the exact function name, you can search related terms using:

```
help.search("paste")

```
This finds functions related to the keyword “paste.” Another quick way is using Google—searching with “R function_name” (e.g., R paste) usually brings up the most relevant resources. Note that the RStudio Help search only works if the package containing the function is already loaded into your environment. Help pages show the function name and the package it belongs to (in curly braces).

>[!TIP]
> Use the Help tab, help.search(), or Google (R + function name) to quickly find guidance when using R.


### 2.8 Common R functions

## R Reference Cards & Guides  

### General R Basics  
- [R Reference Card (CRAN)](https://cran.r-project.org/doc/contrib/Short-refcard.pdf)  
- [R Reference Card (Oxford)](https://www.stats.ox.ac.uk/~snijders/siena/Rrefcard.pdf)  

### RStudio Guide  
- [RStudio IDE Cheatsheet](https://raw.githubusercontent.com/rstudio/cheatsheets/main/rstudio-ide.pdf)  
- [Full List of RStudio Cheatsheets](https://posit.co/resources/cheatsheets/)  


## Summary

In this session, we learned the basics of R and RStudio—what R is, how it compares to Excel, how to install and use RStudio, write scripts, perform calculations (BIDMAS, vectors, Boolean logic), install and load packages like tidyverse, and use R’s help system. We also explored key functions, best practices for clean workflows, and handy reference guides/cheatsheets for quick learning.

