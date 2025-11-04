## Topic

## Keyword & Notes

# 🧭 Session 8: Projects and Reproducibility — Beginner Guide

This session introduces how to make your work **organized, transparent, and reproducible** using R Projects and R Markdown.  
You’ll learn to structure projects, combine code and text, and generate professional reports.

---

## 🎯 What You Will Learn

By the end of this session, you’ll understand:

1. What **reproducibility** means and why it matters.  
2. How to **set up a new R project** (the right way).  
3. How to create and use **R Markdown** and **Quarto** for reproducible reports.  
4. How to organize folders and use **version control** (e.g., Git).  
5. How to create your **first reproducible project**.

---

## 🧩 8.1 Reproducibility — What and Why?

**Reproducibility** means that anyone (including your future self) can **run your code and get the same results**.  
It ensures your research is transparent and verifiable.

### Example

```r
bmi <- c(22, 25, 27, 30)
age <- c(21, 34, 45, 54)
mean(bmi)
```

**Output:**

```
[1] 26
```

Sharing both code and data ensures others can reproduce your results.  
If you only report “The average BMI is 26,” others cannot verify it.

---

## 🗂️ 8.2 Setting Up a New R Project

An **R Project** keeps all related files — code, data, and outputs — in one place.

### 🚫 Why not use `setwd()`?

Old practice:

```r
setwd("C:/Users/Joseph/Desktop/my_project")
```

This breaks when someone else runs your code.  
Projects automatically set the working directory for you.

### ✅ How to Create a New Project

1. Go to **File → New Project → New Directory → New Project**
2. Name it (e.g., `Health_Data_Analysis`)
3. Choose a location
4. Click **Create Project**

RStudio automatically sets the project folder as your working directory.

### 🗃️ Example Folder Structure

```
Health_Data_Analysis/
│
├── data/          # raw data files
├── scripts/       # R scripts
├── outputs/       # results and plots
├── reports/       # markdown reports
└── Health_Data_Analysis.Rproj
```

---

## 📝 8.3 R Markdown and Quarto — Reproducible Reports

### 🧠 What They Do

- **R Markdown** combines **text + code + results** into a single document.  
- **Quarto** is a newer version that supports multiple languages (R, Python, Julia).

You can output to:
- HTML pages  
- PDF reports  
- Word documents  
- Slides (Beamer or PowerPoint)  

---

### 🪜 Create an R Markdown Document

#### Step 1 — Create File
**File → New File → R Markdown…**  
Fill in title, author, and choose “HTML” as the output format.

#### Step 2 — Write Text and Code

Use markdown for text and **chunks** for R code:

<pre>
```{r}
summary(cars)
```
</pre>

#### Step 3 — Knit the Document

Click **Knit** → RStudio runs the code and produces an HTML, Word, or PDF report.

---

### 🧪 Example R Markdown File

```yaml
---
title: "Example Report"
author: "Joseph Muganga"
date: "04/11/2025"
output: html_document
---

## Summary of Car Data
```{r}
summary(cars)
```

## My Plot
```{r}
plot(cars)
```
```

### Output Example

```
 speed         dist       
 Min.   : 4   Min.   :  2  
 1st Qu.:12   1st Qu.: 26  
 Median :15   Median : 36  
 Mean   :15   Mean   : 43  
 3rd Qu.:19   3rd Qu.: 56  
 Max.   :25   Max.   :120  
```

And a plot showing how `dist` increases with `speed`.

---

## 🧠 Exercise 1 — Create Your First Project

**Question:**  
> Set up a new RStudio project and create your first R Markdown report. Use the `iris` dataset or the “FizzBuzz” example. Include code, text, and comments.

### ✅ Solution Example

```yaml
---
title: "My First Project"
author: "Joseph Muganga"
output: html_document
---

## Exploring the Iris Dataset
```{r}
summary(iris)
```

## Simple Plot
```{r}
plot(iris$Sepal.Length, iris$Sepal.Width,
     main = "Sepal Length vs Width",
     xlab = "Sepal Length",
     ylab = "Sepal Width")
```
```

### Output

- Summary statistics of `iris`
- Scatter plot showing Sepal Length vs Sepal Width

**Functions explained:**
- `summary()` — gives descriptive statistics.  
- `plot()` — creates a scatter plot.  
- `main`, `xlab`, `ylab` — set title and axis labels.

---

## 💡 Folder Organization Tip

Inside your project:

```
My_First_Project/
├── data/
├── scripts/
├── report/
│   └── my_first_project.Rmd
└── My_First_Project.Rproj
```

---

## 🧠 Exercise 2 — Version Control (Optional)

**Question:**  
How can we track project changes?

**Solution:**  
Use **Git** built into RStudio:
- Go to **Tools → Version Control → Project Setup → Git**
- Commit regularly with descriptive messages.

---

## 📖 Summary of R Markdown Functions

| Function | Purpose | Example |
|-----------|----------|----------|
| `summary()` | Summarize data | `summary(iris)` |
| `plot()` | Draw basic plots | `plot(cars)` |
| `main` | Plot title | `main = "My Plot"` |
| `xlab`, `ylab` | Axis labels | `xlab = "Speed"`, `ylab = "Distance"` |
| `knit` | Generate report | Click “Knit” in RStudio |

---

## 📘 8.5 Further Reading

- *R for Data Science* by Wickham & Grolemund (Chapters 29–30)  
- [RMarkdown Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)  
- *Open Research and Reproducibility* Workshop by Andrew Stewart

---

## ✅ Final Takeaways

| Concept | Meaning | Why Important |
|----------|----------|----------------|
| **Reproducibility** | Re-run code and get same results | Ensures trust and transparency |
| **R Project** | Self-contained workspace | Avoids using `setwd()` |
| **R Markdown** | Combines text, code, and results | Produces professional reports |
| **Knit** | Generates HTML/PDF/Word outputs | Automates workflows |
| **Version Control (Git)** | Tracks code changes | Enables collaboration |

---
