## Topic

In this session, we will discuss:

* [5 Getting Data In and Out of R](#5-getting-data-in-and-out-of-r)  
* [5.1 Working Directory](#51-working-directory)  
* [5.2 Base R Solutions to Importing Data**](#52-base-r-solutions-to-importing-data)  
* [5.3 Exporting Data](#53-exporting-data)  
* [5.4 Further Reading](#54-further-reading)


## keywords & Notes

### 5 Getting data in and out of R

Before we can analyse data in R, we first need to bring our data into R — and once we finish, we often need to export our results (for example, as a CSV or Excel file).

In this session, we learn:

  * How to import data from different sources such as text files, CSVs, or Excel sheets.
  * How to view and explore the imported data inside R.
  * How to export results or cleaned data back out of R for reporting or sharing.

>[!NOTE]
> In simple terms:
> This session teaches us how to get data into R, work with it, and then save or export it once we’re done — just like opening and saving files in Word or Excel, but using R commands instead.

#### 5.1 Working directory

Before R can read or save any files, it needs to know where to look — this location is called the `working directory`.

Think of it like a folder on your computer where R keeps and looks for files by default.

**Checking your working directory**

You can check your current working directory using:

```
getwd()

```
✅ This command shows the folder path where R is currently working

Output:

```
[1] "/Users/josephmuganga"
```

**Changing your working directory**
You can change it in two ways:
  1. Through RStudio menu:
    * Go to `Session` → Set Working Directory → Choose Directory...
  2. Or by using code:
  
  ```
  setwd("C:/Users/Joseph/Documents/my_project")

  ```
  ✅ This tells R to use the folder you specify.
  
  Output:
  
  ```
  > setwd("/Users/josephmuganga/Documents/Code/r_for_data_science")
  ```
>[!TIP]
> Tips
> * Keep your data files and R scripts in the same working directory.
> * If your data is inside a subfolder (e.g., “data”), include that in your path when reading files.

```
read.csv("data/myfile.csv")

```

> 📝 Exercise:
Choose a folder where you want to keep your R work (e.g., a “R_Projects” folder), set it as your working directory, and save your R script there.

#### 5.2 Base R solutions to importing data

Before we can analyze data, we need to import it into R.
In this section, we learn how to do that using base R, which means using functions that come built into R — no extra packages required.

>🧾 The `read.csv()` function*

The `read.csv()` function is used to read CSV (Comma Separated Values) files — a common format for spreadsheets and data tables.

CSV files can even be created by saving an Excel sheet as “.csv”.

Here’s the basic syntax:

```
x <- read.csv("file.csv")

```
>[!NOTE]
> ✅ This code reads the file called file.csv and saves it as a data frame named x.
> Make sure the file is in your working directory (you can check using getwd()).

> 📁 Reading from a subfolder

If your data is in a `subfolder` (for example, inside a “data” folder), you must include that in the file path:

```
x <- read.csv("data/file.csv")

```

> 🧠 Exercise

  1. Download the file `CHD.csv` (right-click the link → Save link as…).  
  2. Move it into your working directory.  
  3. Then, load it into R using:
  
  ```
    chd <- read.csv("./data/chd.csv")
  ```
  ✅ Now your file is stored as an R object called chd, and you can start exploring it with functions like:
  
  ```
  head(chd)     # Shows the first few rows
  summary(chd)  # Gives summary statistics of each column
  ```
  
>[!TIP]
> 💡 Always check the name and path of your file carefully — if R says `“file not found”`, it usually means the file isn’t in your current working directory.

#### 5.3 Exporting data

Once you have finished working with your data, you may want to save (export) it — for example, to share it with others or to use it later.

In R, you can do this easily using the `write.csv()` function.

Here’s the general syntax:
```
write.csv(object_name, "file_name.csv")
```
✅ The first part (`object_name)` is the data frame you want to save.
✅ The second part `("file_name.csv")` is the name of the file you want to create.


Example

If you have a dataset called chd, you can save it to a new file called chd2.csv like this:

```
write.csv(chd, "chd2.csv")
```
This will create a new file named chd2.csv in your working directory.

> 📁 Optional: save to a subfolder

You can also choose to save the file in a specific folder, for example inside a “data” folder:

```
write.csv(chd, "data/chd2.csv")

```

> 🔍 To confirm the file was created:

```
list.files()  # Shows all files in your working directory
list.files("./data") #Shows all files in your data directory
```

>[!TIP]
> 💡 Tip:
> * Always include the “.csv” extension.
> * If you open the file in Excel or another program, it will look just like a regular spreadsheet!

#### 5.4 Further reading

There are many, many more options for reading and writing data, here are some resources to find out more:

  * [Chapter 8 of R for Data Science](https://r4ds.hadley.nz/data-import.html) introduces the ‘tidyr’ package (part of the Tidyverse).  
  
  * [Chapters 5, 6, 7, 8 of R Programming for Data Science](https://bookdown.org/rdpeng/rprogdatascience/getting-data-in-and-out-of-r.html) cover options, including handling larger files, and reading data directly from websites.  
  
  * For further technical details see [R data import/export manual](https://cran.r-project.org/doc/manuals/r-release/R-data.html) which also includes details of connecting to databases.  

