# Exploratory Data Analysis (EDA) with ggplot2 & dplyr

A beginner-friendly guide to exploring your data using **R**, **ggplot2**, and **dplyr**. We’ll explain key ideas, show code you can run, and describe what to look for in the output.

> Load the tidyverse (which includes ggplot2 and dplyr):
```r
library(tidyverse)
```

---

## 10.1 Introduction

EDA is an **iterative cycle**:
1. **Ask questions** about your data.
2. **Visualize / transform / model** to look for answers.
3. Use what you learn to **refine your questions**.

EDA is also about **checking data quality** (missing values, outliers, inconsistent entries) and getting quick, honest insights before formal modeling.

---

## 10.2 Questions

Two question types power most EDA:

- **Variation** (within one variable): *“What does the distribution of `x` look like?”*
- **Covariation** (between variables): *“How does `y` change with `x`?”*

Ask many small questions; each answer suggests a new, better question.

---

## 10.3 Variation (one variable at a time)

Use histograms/densities for numeric variables; bar charts for categorical ones.

### Example: distribution of diamond weight (`carat`)
```r
ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth = 0.5)
```
**What you’ll see:** Right-skewed histogram (many small diamonds, fewer big ones).

Zoom into smaller stones for more detail:
```r
smaller <- diamonds |> filter(carat < 3)

ggplot(smaller, aes(carat)) +
  geom_histogram(binwidth = 0.01)
```

### What to look for
- **Typical values / peaks**: What’s common? What’s rare?
- **Shape**: Symmetric? Skewed? Multiple peaks?
- **Clusters**: Any apparent subgroups?
- **Outliers**: Any strange/extreme values?

### Finding unusual values
Outliers can hide in tails—zoom the *y*-axis:
```r
ggplot(diamonds, aes(y)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
```

Extract suspicious rows:
```r
unusual <- diamonds |>
  filter(y < 3 | y > 20) |>
  select(price, x, y, z) |>
  arrange(y)
unusual
```

**Tip:** Recode impossible values (e.g., 0 mm) to `NA`, then check analyses with/without them.

### Exercises (with solutions)

**Q1.** Explore `x`, `y`, `z` distributions.
```r
ggplot(diamonds, aes(x)) + geom_histogram(binwidth = 0.5)
ggplot(diamonds, aes(y)) + geom_histogram(binwidth = 0.5)
ggplot(diamonds, aes(z)) + geom_histogram(binwidth = 0.5)
```

**Q2.** Explore `price` at multiple binwidths.
```r
ggplot(diamonds, aes(price)) + geom_histogram(binwidth = 100)
ggplot(diamonds, aes(price)) + geom_histogram(binwidth = 500)
ggplot(diamonds, aes(price)) + geom_histogram(binwidth = 1000)
```

**Q3.** Count 0.99 vs 1.00 carat.
```r
diamonds |> count(carat == 0.99)
diamonds |> count(carat == 1.00)
```
*Why different?* Market prefers round numbers → more 1.00 ct.

**Q4.** `coord_cartesian()` vs `xlim()/ylim()`:
- `coord_cartesian()` **zooms** view only (keeps data; bin counts stay correct).
- `xlim()/ylim()` **drops** outside data (can change counts and bars).

---

## 10.4 Unusual values (handling)

Two strategies:
1) **Drop rows** (risky; you lose other good variables too).
2) **Replace values with `NA`** (recommended for impossible values).

```r
diamonds2 <- diamonds |>
  mutate(y = if_else(y < 3 | y > 20, NA, y))

ggplot(diamonds2, aes(x, y)) +
  geom_point(na.rm = TRUE)
```

**Missingness can be informative.** In `nycflights13::flights`, `NA` in `dep_time` means *cancelled*. Compare scheduled times:

```r
nycflights13::flights |>
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min  = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min/60
  ) |>
  ggplot(aes(sched_dep_time)) +
  geom_freqpoly(aes(color = cancelled), binwidth = 0.25)
```

### Exercises (with solutions)

**Q1.** Missing values in hist vs bar chart?  
- Histogram (numeric): `NA`s are **ignored**.  
- Bar chart (categorical): can show `NA` as a separate bar (use `addNA()` or handle explicitly).

**Q2.** `na.rm = TRUE` in `mean()`/`sum()` ignores missing values:
```r
mean(c(1, NA, 3), na.rm = TRUE)  # 2
sum(c(1, NA, 3), na.rm = TRUE)   # 4
```

**Q3.** Facet cancelled vs not (free y-scale):
```r
nycflights13::flights |>
  mutate(
    cancelled = is.na(dep_time),
    sched_dep_time = (sched_dep_time %/% 100) + (sched_dep_time %% 100)/60
  ) |>
  ggplot(aes(sched_dep_time)) +
  geom_freqpoly(binwidth = 0.25) +
  facet_wrap(~ cancelled, scales = "free_y")
```

---

## 10.5 Covariation (relationships)

### 10.5.1 One categorical + one numeric

#### Frequency polygons (density)
```r
ggplot(diamonds, aes(price, y = after_stat(density))) +
  geom_freqpoly(aes(color = cut), binwidth = 500, linewidth = 0.75)
```

#### Boxplots (simple, compact comparison)
```r
ggplot(diamonds, aes(cut, price)) +
  geom_boxplot()
```

**Reorder categories for clarity (mpg example):**
```r
ggplot(mpg, aes(fct_reorder(class, hwy, median), hwy)) +
  geom_boxplot()
```

**Flip axes (same plot):**
```r
ggplot(mpg, aes(hwy, fct_reorder(class, hwy, median))) +
  geom_boxplot()
```

**Exercises (with ideas/solutions):**
- Improve cancelled vs non-cancelled: use density, proportions, or faceting with `scales = "free_y"`.
- Price is driven strongly by **carat**; cut relates to carat → confounding can make worse cuts look more expensive overall.
- Try `lvplot::geom_lv()` for very large `n` (fewer “outlier” dots).

### 10.5.2 Two categorical variables

#### Bubble-count plot
```r
ggplot(diamonds, aes(cut, color)) + geom_count()
```

#### Heatmap (tile)
```r
diamonds |>
  count(color, cut) |>
  ggplot(aes(color, cut, fill = n)) +
  geom_tile()
```

**Rescale within categories to compare proportions:**
```r
diamonds |>
  count(color, cut) |>
  group_by(color) |>
  mutate(p = n / sum(n)) |>
  ggplot(aes(color, cut, fill = p)) +
  geom_tile()
```

### 10.5.3 Two numeric variables

#### Scatterplot + transparency (overplotting fix)
```r
smaller <- diamonds |> filter(carat < 3)

ggplot(smaller, aes(carat, price)) +
  geom_point(alpha = 0.01)
```

#### 2D binning
```r
ggplot(smaller, aes(carat, price)) + geom_bin2d()
# install.packages("hexbin")
ggplot(smaller, aes(carat, price)) + geom_hex()
```

#### Condition on x (bin carat, show boxplots)
```r
ggplot(smaller, aes(carat, price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)), varwidth = TRUE)
```

**`cut_width()` vs `cut_number()`**: equal-width vs equal-count bins (trade-offs: comparability of bin sizes vs comparable sample sizes).

---

## 10.6 Patterns and simple modeling

If you see a pattern, ask:
- Could it be random?
- How strong?
- Any confounders?
- Does it change in subgroups?

**Remove carat effect to re-check cut vs price**:
```r
library(tidymodels)

diamonds <- diamonds |>
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )

fit <- linear_reg() |>
  fit(log_price ~ log_carat, data = diamonds)

diamonds_aug <- augment(fit, new_data = diamonds) |>
  mutate(.resid = exp(.resid))

ggplot(diamonds_aug, aes(carat, .resid)) + geom_point(alpha = 0.05)
ggplot(diamonds_aug, aes(cut, .resid)) + geom_boxplot()
```
**What you’ll see:** After adjusting for size, better cuts have higher adjusted prices (as expected).

---

## 10.7 Summary

- We explored **variation** (one variable) and **covariation** (two variables).
- We handled **outliers** and **missing data**.
- We used **binning**, **faceting**, **reordering**, and **position adjustments**.
- Simple **modeling** can clarify relationships by removing dominant effects.

These are the building blocks for deeper analysis and clear communication.

---

## Function cheat-notes (used above)

- `ggplot()`, `aes()`: start a plot; map variables to aesthetics (x, y, color, fill, etc.).  
- `geom_*()`: draw things (points, bars, tiles, hexes, boxplots, etc.).  
- `after_stat()`: reference values computed by a stat (e.g., `density`).  
- `coord_cartesian()`: zoom view (keeps data). `xlim()/ylim()`: drop data outside limits.  
- `facet_*()`: split into subplots by category.  
- `fct_reorder()`: reorder factor levels by a summary (e.g., median).  
- `cut_width()/cut_number()`: bin numeric → categorical (equal width vs equal count).  
- `if_else()`, `is.na()`: recode and test missingness.  
- `group_by()/summarise()/mutate()`: group-level summaries and column transforms.  
- `count()`: shortcut for group counts (`n`).  
- `%/%`, `%%`: integer division and remainder (e.g., split 1340 → 13 and 40).  
- `na.rm = TRUE`: ignore missing values in summaries (`mean`, `sum`, etc.).
