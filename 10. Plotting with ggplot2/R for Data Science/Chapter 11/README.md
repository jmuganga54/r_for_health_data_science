# Communication (Chapter 11) — Beginner-Friendly Guide

> **Packages used**
>
> ```r
> library(tidyverse)   # ggplot2 + dplyr + readr + etc.
> library(scales)      # axis/legend formatting helpers (percent, dollar, etc.)
> library(ggrepel)     # non-overlapping text/label geoms
> library(patchwork)   # combine multiple ggplots into one layout
> ```
>
> Tip: Install missing packages with `install.packages("<name>")`.

---

## Table of Contents
- [11.1 Introduction](#111-introduction)
- [11.2 Labels](#112-labels)
- [11.3 Annotations](#113-annotations)
- [11.4 Scales](#114-scales)
- [11.5 Themes](#115-themes)
- [11.6 Layout (patchwork)](#116-layout-patchwork)
- [11.7 Summary](#117-summary)

---

## 11.1 Introduction

When we move from **exploring** data to **communicating** results, we keep the same data but improve the plot’s clarity: good titles, readable axes, annotations that point out key findings, sensible scales, and a clean theme. The goal is a plot that “speaks for itself,” even to people who don’t know your dataset.

---

## 11.2 Labels

Use `labs()` to add a **title**, **subtitle**, **caption**, and readable **axis/legend titles**.

```r
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +          # color by car class
  geom_smooth(se = FALSE) +                 # trend line (no band)
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two-seaters are an exception (lighter cars)",
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type",
    caption = "Source: fueleconomy.gov"
  )
```

**Math in labels**: use `quote()` (from base R) for mathematical expressions.

```r
df <- tibble(x = 1:10, y = cumsum(x^2))

ggplot(df, aes(x, y)) +
  geom_point() +
  labs(x = quote(x[i]), y = quote(sum(x[i]^2, i == 1, n)))
```

---

## 11.3 Annotations

Label **specific points** or **regions** to guide attention.

### 11.3.1 Data-driven labels (`geom_text()` / `geom_label()`)

```r
label_info <- mpg |>
  group_by(drv) |>
  arrange(desc(displ)) |>
  slice_head(n = 1) |>                     # largest engine per drivetrain
  mutate(
    drive_type = case_when(
      drv == "f" ~ "front-wheel drive",
      drv == "r" ~ "rear-wheel drive",
      drv == "4" ~ "4-wheel drive"
    )
  )

ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  geom_text(
    data = label_info,
    aes(label = drive_type),
    fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
  ) +
  theme(legend.position = "none")
```

**Avoid overlaps** with **ggrepel**:

```r
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point(alpha = 0.3) +
  geom_smooth(se = FALSE) +
  ggrepel::geom_label_repel(
    data = label_info,
    aes(label = drive_type),
    fontface = "bold", size = 5, nudge_y = 2
  ) +
  theme(legend.position = "none")
```

### 11.3.2 Highlight & label special cases

```r
outliers <- mpg |> filter(hwy > 40 | (hwy > 20 & displ > 5))

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  ggrepel::geom_text_repel(data = outliers, aes(label = model)) +
  geom_point(data = outliers, color = "red", size = 3, shape = 21)
```

### 11.3.3 Reference lines, rectangles, arrows, and `annotate()`

```r
trend_text <- "Larger engines tend to have lower fuel economy." |>
  stringr::str_wrap(30)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  annotate("label", x = 3.5, y = 38, label = trend_text,
           hjust = "left", color = "red") +
  annotate("segment", x = 3, y = 35, xend = 5, yend = 25,
           color = "red", arrow = arrow(type = "closed"))
```

---

## 11.4 Scales

Scales control how mapped values **look**: tick positions (`breaks`), text (`labels`), color palettes, transforms (e.g., log), zooming, etc.

### 11.4.1 Ticks and labels

```r
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
```

Hide axis tick labels, rename legend entries:

```r
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL) +
  scale_color_discrete(labels = c("4" = "4-wheel", "f" = "front", "r" = "rear"))
```

Format numbers using **scales** (currency, percent, etc.)

```r
ggplot(diamonds, aes(price, cut)) +
  geom_boxplot(alpha = 0.05) +
  scale_x_continuous(labels = scales::label_dollar())

ggplot(diamonds, aes(cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Percentage", labels = scales::label_percent())
```

**Dates:**

```r
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(start, id)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_x_date(name = NULL,
               breaks = presidential$start,
               date_labels = "'%y")
```

### 11.4.2 Replace scales (transforms & palettes)

**Log axes (keep original scale labels):**
```r
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10()
```

**Color (categorical) with ColorBrewer:**
```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")
```

**Manual color mapping:**
```r
presidential |>
  mutate(id = 33 + row_number()) |>
  ggplot(aes(start, id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3"))
```

**Continuous color (viridis):**
```r
df <- tibble(x = rnorm(10000), y = rnorm(10000))

ggplot(df, aes(x, y)) +
  geom_hex() +
  scale_fill_viridis_c() +
  coord_fixed()
```

### 11.4.3 Zooming

Three options:
1. **Filter the data** (changes model fits)
2. **Scale limits** via `limits =` (drops out-of-range data)
3. **`coord_cartesian(xlim=, ylim=)`** (zooms without dropping data — best for zooming)

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 6), ylim = c(10, 25))
```

**Share scales across plots** (useful when not faceting):

```r
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_color_discrete(limits = unique(mpg$drv))

ggplot(mpg |> filter(class == "suv"), aes(displ, hwy, color = drv)) +
  geom_point() + x_scale + y_scale + col_scale
```

---

## 11.5 Themes

Themes style the **non-data** parts: background, grid, legend box, fonts, margins, etc.

**Built-in theme:**
```r
ggplot(mpg, aes(displ, hwy, color = class)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  theme_bw()
```

**Customize with `theme()` + `element_*()`:**
```r
ggplot(mpg, aes(displ, hwy, color = drv)) +
  geom_point() +
  labs(
    title = "Larger engines → lower fuel economy",
    caption = "Source: fueleconomy.gov"
  ) +
  theme(
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal",
    legend.box.background = element_rect(color = "black"),
    plot.title = element_text(face = "bold"),
    plot.title.position = "plot",
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 0)
  )
```

---

## 11.6 Layout (patchwork)

Combine separate `ggplot` objects into one figure.

**Side-by-side:**

```r
p1 <- ggplot(mpg, aes(displ, hwy)) + geom_point() + labs(title = "Plot 1")
p2 <- ggplot(mpg, aes(drv,  hwy)) + geom_boxplot() + labs(title = "Plot 2")
p1 | p2
```

**Grid:**

```r
p3 <- ggplot(mpg, aes(cty, hwy)) + geom_point() + labs(title = "Plot 3")
(p1 | p3) / p2
```

**Collect legends & custom heights:**

```r
pA <- ggplot(mpg, aes(drv, cty, color = drv)) + geom_boxplot(show.legend = FALSE)
pB <- ggplot(mpg, aes(drv, hwy, color = drv)) + geom_boxplot(show.legend = FALSE)
pC <- ggplot(mpg, aes(cty, color = drv, fill = drv)) + geom_density(alpha = 0.5)
pD <- ggplot(mpg, aes(hwy, color = drv, fill = drv)) + geom_density(alpha = 0.5)
pE <- ggplot(mpg, aes(cty, hwy, color = drv)) + geom_point(show.legend = FALSE) + facet_wrap(~drv)

(guide_area() / (pA + pB) / (pC + pD) / pE) +
  plot_annotation(
    title = "City & highway mileage by drive train",
    caption = "Source: fueleconomy.gov"
  ) +
  plot_layout(guides = "collect", heights = c(1, 3, 2, 4)) &
  theme(legend.position = "top")
```

---

## 11.7 Summary

To communicate clearly with plots:
- Add strong **labels** with `labs()` (title, subtitle, caption, readable axis & legend titles).
- Use **annotations** (`geom_text/label(_repel)`, `annotate()`, reference lines/boxes/arrows) to point out key takeaways.
- Tune **scales** (ticks, formatted labels, log transforms, color palettes, and zooming with `coord_cartesian()`).
- Pick and customize **themes** for clean presentation.
- Use **patchwork** to arrange multiple plots into one coherent figure.

With these tools, your plots will be understandable and convincing to any audience.
