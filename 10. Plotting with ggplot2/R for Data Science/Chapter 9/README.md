# Chapter 9 — Layers 

This guide walks you through the **layered grammar of graphics** in **ggplot2**. We’ll build up from aesthetics and geoms, to facets, stats, position adjustments, coordinate systems, and finally the full plotting “grammar”. Each subsection includes simple code snippets and clear explanations.  

> **Setup once per session**
```r
library(tidyverse)   # loads ggplot2, dplyr, readr, etc.
```

---

## 9.1 Introduction

You already know how to make scatterplots, bar charts, and boxplots. Here we go deeper into **how ggplot2 builds plots with layers**:

- **Aesthetics**: how data map to what you see (x, y, color, size…)
- **Geoms**: the geometric shapes (points, lines, bars…)
- **Facets**: split one plot into multiples
- **Stats**: computed values (e.g., bar heights, smoothers, boxplot summaries)
- **Position adjustments**: control overlaps (stack, dodge, jitter…)
- **Coordinate systems**: what x and y mean (Cartesian, polar…)

> We won’t cover every option, but you’ll get all the **most common, practical tools**.

---

## 9.2 Aesthetic mappings

**Aesthetics** (set in `aes()`) connect columns in your data to visual properties.

- `x`, `y`: where to place things
- `color`, `fill`: color of outlines vs interiors
- `shape`, `size`, `alpha`: point type, size, transparency
- `linetype`: line style (solid, dashed…)

### Data we’ll use
```r
mpg   # built-in data from ggplot2
# 234 rows × 11 columns (manufacturer, model, displ, year, cyl, trans, drv, cty, hwy, fl, class)
```

### Basic scatterplots + mapping a third variable
```r
# Color by car class (categorical)
ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()
```

```r
# Shape by class (⚠ shapes are limited to ~6 discrete values)
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()
#> Warning: The shape palette can deal with a maximum of 6 discrete values...
```
- If you map a categorical variable with **>6 levels** to `shape`, some groups won’t display and ggplot2 warns you.

### Mapping vs. setting aesthetics
- **Mapping** (inside `aes()`): **data-driven** (varies by row)
- **Setting** (outside `aes()`): **constant** for the layer

```r
# Set all points blue (not data-driven)
ggplot(mpg, aes(displ, hwy)) +
  geom_point(color = "blue")
```

### Good vs. not recommended mappings
- Mapping `class` to `size` or `alpha` implies an **order** that doesn’t exist → ggplot2 warns (not advised).

#### Exercise 9.2 — with solutions

1) **Scatterplot with pink filled triangles**
```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(shape = 24, fill = "pink", color = "pink")
```
*(Shape 24 is a filled triangle; `fill` colors inside for shapes 21–25.)*

2) **Why isn’t this blue?**
```r
ggplot(mpg) + 
  geom_point(aes(displ, hwy, color = "blue"))
```
- Because `"blue"` inside `aes()` is treated as a **category** called literally “blue”.  
- Fix: move `color = "blue"` **outside** `aes()`.

3) **What is `stroke`?**
```r
?geom_point
```
- `stroke` controls the **border width** of shapes that have borders (21–25).

4) **Map an expression, e.g., `color = displ < 5`**
```r
ggplot(mpg, aes(x = displ, y = hwy, color = displ < 5)) +
  geom_point()
```
- `displ < 5` produces a logical vector (`TRUE`/`FALSE`), i.e., two colors.

---

## 9.3 Geometric objects (Geoms)

**Geoms** choose *how* to draw the data.

```r
# Points vs smooth line
ggplot(mpg, aes(displ, hwy)) + geom_point()
ggplot(mpg, aes(displ, hwy)) + geom_smooth()
#> `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
```

Different geoms accept different aesthetics:
- `geom_point()` understands `shape`, `size`, `color`
- `geom_smooth()` understands `linetype`, `color`, `fill`, etc.

### Multiple layers + local mappings
```r
ggplot(mpg, aes(displ, hwy)) + 
  geom_point(aes(color = class)) +   # local color mapping
  geom_smooth(se = TRUE)              # confidence band
```

### Different data per layer
```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"
  )
```

### Different geoms show different features
```r
ggplot(mpg, aes(hwy)) + geom_histogram(binwidth = 2)
ggplot(mpg, aes(hwy)) + geom_density()
ggplot(mpg, aes(hwy, y = 1)) + geom_boxplot()
```

#### Exercise 9.3 — with solutions

1) **Which geoms?**
- Line chart → `geom_line()`
- Boxplot → `geom_boxplot()`
- Histogram → `geom_histogram()`
- Area chart → `geom_area()`

2) **What does `show.legend = FALSE` do?**
```r
ggplot(mpg, aes(displ, hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)
```
- Suppresses the legend for that layer. Remove it to see the legend.

3) **What does `se` in `geom_smooth()` do?**  
- `se = TRUE` adds a **confidence band** around the smooth; `FALSE` removes it.

4) **Recreate 6 small-multiple examples**  
Tips:
- Use combinations of:
  - `geom_point(color = "black")`
  - `geom_smooth()` (single line) vs `aes(color = drv)` or `aes(linetype = drv)`
  - Point borders: `geom_point(size = 2, stroke = 1, color = "white")`

---

## 9.4 Facets

**Faceting** splits one plot into many small plots by categories.

```r
# One variable faceting
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~ cyl, nrow = 2)
```

```r
# Two variables faceting — rows ~ cols
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)
```

**Free scales** can help if panels have very different ranges:
```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl, scales = "free")
```

#### Exercise 9.4 — with solutions (high level)

- **Facet on a continuous variable?**  
  It will create many panels (one per unique value) → usually **not useful**. Bin/convert to categories first.

- **Empty cells in `facet_grid(drv ~ cyl)`?**  
  Some combinations don’t exist in the data → empty panels.  
  Verify by plotting counts:
  ```r
  ggplot(mpg, aes(drv, cyl)) + geom_point()
  ```

- **What does `.` do in `facet_grid()`?**  
  Placeholder meaning “no facet on this dimension”.
  ```r
  facet_grid(drv ~ .)   # rows by drv, one column
  facet_grid(. ~ cyl)   # columns by cyl, one row
  ```

- **Faceting vs color aesthetic**  
  - Facet: easier to **compare shapes** within each subgroup; less overplotting.  
  - Color: shows all data in one space but can be cluttered.  
  Larger datasets often benefit from **faceting**.

- **`facet_wrap()` layout args**  
  `nrow`, `ncol` control the number of rows/cols. `facet_grid()` doesn’t have them because row/col are determined by the two variables.

- **Rows vs columns for comparison**  
  If you want to compare **distributions across categories**, placing the category on **columns** (`. ~ drv`) may simplify left-to-right comparisons.

- **Recreate `facet_grid(drv ~ .)` using `facet_wrap()`**  
  ```r
  ggplot(mpg, aes(displ, hwy)) +
    geom_point() +
    facet_wrap(~ drv, ncol = 1)  # vertical stack
  ```

---

## 9.5 Statistical transformations (stats)

Some geoms compute values **for you** (bar counts, smooth lines, boxplot summaries). That computation is a **stat**.

### Bar counts (default `stat = "count"`)
```r
ggplot(diamonds, aes(x = cut)) +
  geom_bar()   # y is computed as count
```

### Using your own precomputed y
```r
diamonds |>
  count(cut) |>
  ggplot(aes(cut, n)) +
  geom_bar(stat = "identity")  # use y = n as-is
```

### Proportions with `after_stat()`
```r
ggplot(diamonds, aes(cut, y = after_stat(prop), group = 1)) +
  geom_bar()
```
- `after_stat(prop)` means “use the computed proportion”
- `group = 1` treats all bars as one group when computing proportions

### Summaries per x (min/median/max)
```r
ggplot(diamonds) + 
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min, fun = median, fun.max = max
  )
```

#### Exercise 9.5 — with solutions

- **Default geom for `stat_summary()`?**  
  `geom = "pointrange"` (point + vertical line).  
  Equivalent:
  ```r
  ggplot(diamonds, aes(cut, depth)) +
    geom_pointrange(stat = "summary",
                    fun.min = min, fun = median, fun.max = max)
  ```

- **`geom_col()` vs `geom_bar()`**  
  `geom_col()` expects **y** already in data (like `stat="identity"`).  
  `geom_bar()` computes counts by default.

- **Geom/stat pairs** (examples):  
  `geom_bar()` ↔ `stat_count()`  
  `geom_histogram()` ↔ `stat_bin()`  
  `geom_smooth()` ↔ `stat_smooth()`  
  `geom_boxplot()` ↔ `stat_boxplot()`  
  `geom_density()` ↔ `stat_density()`

- **`stat_smooth()` computes** predicted `y` and `ymin/ymax` for the ribbon (CI). Arguments: `method`, `formula`, `se`, `span` (loess), etc.

- **Why `group = 1` for proportions?**  
  Without it, proportions are computed **within each fill/color group**, not across the whole set.  
  The following two won’t do what you expect:
  ```r
  ggplot(diamonds, aes(cut, y = after_stat(prop))) + geom_bar()          # no group
  ggplot(diamonds, aes(cut, fill = color, y = after_stat(prop))) + geom_bar()
  ```

---

## 9.6 Position adjustments

When geoms overlap, control **position**:

- **stack** (default for bars)  
- **identity** (draw in place; overlaps)  
- **fill** (normalize stacks to height 1 → proportions)  
- **dodge** (place side-by-side)

```r
# Stack (default)
ggplot(mpg, aes(drv, fill = class)) + geom_bar()

# Fill (proportions)
ggplot(mpg, aes(drv, fill = class)) + geom_bar(position = "fill")

# Dodge (side-by-side)
ggplot(mpg, aes(drv, fill = class)) + geom_bar(position = "dodge")
```

### Overplotting in scatterplots → jitter
```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(position = "jitter")   # or geom_jitter()
```
- Adds small random noise to reduce overlap.  
- Control with `width` (x-jitter) and `height` (y-jitter).

#### Exercise 9.6 — with solutions

- **Problem with this plot?**
```r
ggplot(mpg, aes(cty, hwy)) + geom_point()
```
- Discrete grid and heavy overlap. Improve with:
  ```r
  ggplot(mpg, aes(cty, hwy)) + geom_jitter(width = 0.2, height = 0.2)
  ```

- **Identity vs default for points?**
```r
ggplot(mpg, aes(displ, hwy)) + geom_point()
ggplot(mpg, aes(displ, hwy)) + geom_point(position = "identity")
```
- Same result — for points the default is **identity**.

- **Control jitter size**
```r
geom_jitter(width = 0.2, height = 0.2)
```

- **`geom_jitter()` vs `geom_count()`**  
  - `geom_jitter()` spreads overlapping points  
  - `geom_count()` sizes points by **number of duplicates**

- **Default position for `geom_boxplot()`**  
  - `position = "dodge2"` when you map a grouping aesthetic (e.g., `fill`).  
  Example:
  ```r
  ggplot(mpg, aes(class, hwy, fill = drv)) +
    geom_boxplot()   # dodged by drv
  ```

---

## 9.7 Coordinate systems

Default is **Cartesian**. Others:

- **`coord_quickmap()`**: correct aspect ratio for simple maps (fast)
- **`coord_map()`**: map projections (more accurate, slower)
- **`coord_polar()`**: polar coordinates (turn bars → pie/Coxcomb)
- **`coord_fixed()`**: fix aspect ratio (1 unit x = 1 unit y)

```r
# Pie chart = bar chart + coord_polar()
ggplot(diamonds, aes(x = clarity, fill = clarity)) +
  geom_bar(width = 1, show.legend = FALSE) +
  coord_polar()
```

```r
# Equal scaling for comparing cty vs hwy to the diagonal
ggplot(mpg, aes(cty, hwy)) +
  geom_point() +
  geom_abline() +   # reference line y = x
  coord_fixed()     # same scale on x and y
```

#### Exercise 9.7 — with solutions

- **Stacked bar → pie**
```r
ggplot(mpg, aes(x = 1, fill = class)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")
```

- **`coord_quickmap()` vs `coord_map()`**  
  - `quickmap`: fixes aspect ratio using lat/long; **fast**  
  - `map`: real projections; **slower**, more accurate for cartography

- **Why `coord_fixed()` with `geom_abline()`?**  
  Ensures 45° line actually means equal `cty` and `hwy` units, making the “above/below line” comparison meaningful.

---

## 9.8 The layered grammar of graphics (template)

**General template** you can use for almost any plot:

```r
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
    mapping  = aes(<MAPPINGS>),
    stat     = <STAT>,
    position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
```

You rarely need to fill all seven parts—**data**, **aes()**, and a **geom** are usually enough to start. Add the rest as needed.

---

## 9.9 Summary

We learned to build plots by combining:

- **Aesthetics** + **Geoms** (what and how)
- **Facets** (many small plots)
- **Stats** (computed values like counts, smoothers)
- **Positions** (stack/dodge/jitter)
- **Coordinates** (Cartesian, polar, fixed…)
- All living inside a **layered grammar**.

> Cheatsheet and full reference
- Posit ggplot2 cheatsheet: *great overview of geoms/stats/positions*  
- ggplot2 website: *complete, searchable reference*

---

## Quick Function Reference (used above)

- `ggplot(data, aes(...))`: start a plot, define mappings  
- `geom_point()`, `geom_smooth()`, `geom_bar()`, `geom_histogram()`, `geom_density()`, `geom_boxplot()`, `geom_jitter()`, `geom_line()`, `geom_area()`: geoms  
- `facet_wrap(~ var, nrow = , ncol = )`, `facet_grid(rows ~ cols)`: facets  
- `after_stat()`: use computed stat variables (e.g., `prop`)  
- `stat_summary(fun = , fun.min = , fun.max = )`: summary per x  
- Positions: `"stack"`, `"identity"`, `"fill"`, `"dodge"`, `"jitter"`  
- Coordinates: `coord_fixed()`, `coord_quickmap()`, `coord_map()`, `coord_polar()`  
- Helpers: `group = 1` (treat all as one group for stats like proportions)

---

### Tip to remember
- **Inside `aes()` = mapped from data**  
- **Outside `aes()` = fixed style**  
- If the plot looks odd, check **what is mapped** vs **what is set**.
