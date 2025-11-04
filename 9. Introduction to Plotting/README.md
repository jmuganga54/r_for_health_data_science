## Topic

## Keyword and Notes
# 🧭 Session 9: Introduction to Plotting in R

This guide introduces the **basics of data visualization in R**, starting from **built-in functions** like `plot()`, `barplot()`, `boxplot()`, and `hist()`, to help you explore and understand data effectively.

---

## 9.1 Data Visualization — The Basics

Data visualization helps us see relationships, trends, and outliers in data.  
In R, there are two main ways to visualize data:

1. **Built-in plotting functions** (e.g., `plot()`, `barplot()`, `hist()`)
2. **ggplot2 package** for advanced, publication-ready graphics.

We will begin with **base R plots** using the built-in dataset `swiss`.

---

### 🧩 The Swiss Dataset

R includes a dataset called **`swiss`**, containing fertility and socio-economic indicators for 47 provinces in Switzerland (1888).

```r
swiss
```

Columns include:
- `Fertility`: Birth rate per 1,000 women
- `Agriculture`: % of males in agriculture
- `Examination`: % of draftees with high exam marks
- `Education`: % with education beyond primary school
- `Catholic`: % Catholic
- `Infant.Mortality`: Infant deaths per 1,000 births

---

## 1️⃣ Scatter Plot — `plot()`

A **scatter plot** helps visualize the distribution or relationship between variables.

```r
plot(swiss$Fertility)
```

**What happens:**
- Points are plotted for each Fertility value.
- X-axis shows index numbers (1–47), which can be misleading since they’re not meaningful.

To add labels and title:

```r
plot(swiss$Fertility, 
     main = "Fertility in Swiss Provinces",
     xlab = "Province Index", 
     ylab = "Fertility Rate")
```

**Function details:**
- `plot()` — creates a scatter plot.
- `main` — adds a title.
- `xlab`, `ylab` — label the axes.

---

## 2️⃣ Bar Chart — `barplot()`

Bar charts display comparisons between values.

```r
barplot(swiss$Fertility)
```

Adding province names:

```r
barplot(swiss$Fertility, names.arg = rownames(swiss))
```

⚠️ **Note:** Too many labels can clutter the chart.

**Function details:**
- `barplot()` — creates bar charts.
- `names.arg` — adds names or labels for bars.

---

## 3️⃣ Box Plot — `boxplot()`

A **boxplot** summarizes distribution and outliers.

```r
boxplot(swiss$Fertility)
```

**Interpretation:**
- The **box** shows the middle 50% (interquartile range).
- The **line** inside = median.
- The **whiskers** = min/max within range.
- **Dots** = outliers.

**Function details:**
- `boxplot()` — shows distribution and spread of values.

---

## 4️⃣ Histogram — `hist()`

A **histogram** shows frequency distribution.

```r
hist(swiss$Fertility)
```

**Interpretation:**  
The data is roughly symmetric around 70.

**Function details:**
- `hist()` — divides data into bins and counts how many fall into each.

---

## 5️⃣ Density Plot — `plot(density())`

A **density plot** smooths out the histogram to show the distribution shape.

```r
hist(swiss$Fertility, freq = FALSE)
lines(density(swiss$Fertility))
```

or directly:

```r
plot(density(swiss$Fertility), type = "l")
```

**Function details:**
- `density()` — calculates smoothed distribution.
- `type = "l"` — line plot instead of points.

---

### 🧠 Exercise 1
**Question:** What other values can `type` take in `plot()`?

**Solution:**  
Use help:

```r
?plot
```

Values include:
- `"p"` — points (default)
- `"l"` — lines
- `"b"` — both points and lines
- `"h"` — vertical lines
- `"s"` or `"S"` — steps
- `"n"` — no plotting

Example:

```r
plot(swiss$Fertility, type = "b", main = "Type = 'b' Example")
```

---

## 6️⃣ Relationship Between Two Variables

Plotting two variables to examine correlation.

```r
plot(swiss$Education, swiss$Fertility,
     main = "Fertility vs Education",
     xlab = "% Education beyond primary school",
     ylab = "Fertility rate")
```

**Interpretation:**  
There’s a **negative relationship** — as education increases, fertility decreases.

**Function:**  
`plot(x, y)` — plots one variable against another.

---

## 7️⃣ All Relationships — `plot(swiss)`

To visualize all pairwise relationships between variables:

```r
plot(swiss)
```

This creates a **matrix of scatterplots** for all columns.

---

### 🧠 Exercise 2
**Question:** Choose another dataset and recreate these plots for variables of your choice.

**Solution Example:** Using `mtcars`:

```r
plot(mtcars$mpg)
barplot(mtcars$mpg)
boxplot(mtcars$mpg)
hist(mtcars$mpg)
plot(mtcars$hp, mtcars$mpg)
plot(mtcars)
```

**Interpretation:**  
Cars with higher horsepower (`hp`) tend to have lower fuel efficiency (`mpg`).

---

### 🧠 Exercise 3
**Question:** How do you change the title of the plot?

**Solution:** Use the `main` argument.

```r
plot(swiss$Education, swiss$Fertility,
     main = "Education vs Fertility",
     xlab = "Education (%)",
     ylab = "Fertility Rate")
```

---

## 9.2 Saving Plots as Images

When satisfied with a plot, you can **save** it as an image or PDF.

### 🖼️ Option 1 — Using RStudio Export Button
1. Go to **Plots pane** → click **Export**.  
2. Choose **Save as Image** or **Save as PDF**.  
3. Adjust **filename**, **size**, and **format**.

### 💾 Option 2 — Save Programmatically (Using Code)

#### Save as PNG
```r
png("myplot.png", width = 800, height = 600)
plot(swiss$Education, swiss$Fertility, main = "Education vs Fertility")
dev.off()
```

#### Save as PDF
```r
pdf("myplot.pdf")
hist(swiss$Fertility, main = "Fertility Histogram")
dev.off()
```

**Function details:**
- `png()` / `pdf()` — start the output file.
- `dev.off()` — close the file device (always needed).

---

## 📘 Summary of Key Plot Functions

| Plot Type | Function | Purpose | Key Arguments |
|------------|-----------|----------|----------------|
| Scatter plot | `plot()` | Points or relationships | `main`, `xlab`, `ylab`, `type` |
| Bar chart | `barplot()` | Compare categories | `names.arg` |
| Box plot | `boxplot()` | Spread & outliers | `main` |
| Histogram | `hist()` | Frequency distribution | `freq`, `breaks` |
| Density plot | `plot(density())` | Smoothed distribution | `type = "l"` |
| Save plot | `png()`, `pdf()` | Save image/PDF | `width`, `height`, `dev.off()` |

---

✅ **Key Takeaways**
- Use **base R plots** to explore data quickly.  
- Label axes and add titles for clarity.  
- Use `density()` with `type = "l"` for smooth distributions.  
- Save your plots with `png()` or `pdf()`.  
- Practice with built-in datasets like `swiss` and `mtcars`.

Once you’re comfortable, move on to **ggplot2** for advanced plotting.

---
