library(tidyverse)
library(ggthemes)

library(palmerpenguins)
# palmerpenguins package, which includes the penguins dataset containing body measurements for penguins on three islands in the Palmer Archipelago, and the ggthemes package, which offers a colorblind safe color palette.

#Do penguins with longer flippers weigh more or less than penguins with shorter flippers?

setwd('/Users/josephmuganga/Documents/Code/r_for_health_data_science/Books/1. R for Data Science/1. Data Visualization')

penguins
# In the tidyverse, we use special data frames called tibbles that you will learn more about soon.

glimpse(penguins)

#Among the variables in penguins are:
# species: a penguin’s species (Adelie, Chinstrap, or Gentoo).
# flipper_length_mm: length of a penguin’s flipper, in millimeters.
# body_mass_g: body mass of a penguin, in grams.



# To learn more about penguins, open its help page by running ?penguins.
?penguins

# 1.2.2 Ultimate goal
# Ultimate goal
# Our ultimate goal in this chapter is to recreate the following visualization displaying the relationship between flipper lengths and body masses of these penguins, taking into consideration the species of the penguin.


# 1.2.3 Creating a ggplot
ggplot(data = penguins)
# ggplot(data = penguins) creates an empty graph that is primed to display the penguins data, but since we haven’t told it how to visualize it yet, for now it’s empty.


# Next, we need to tell ggplot() how the information from our data will be visually represented. The mapping argument of the ggplot() function defines how variables in your dataset are mapped to visual properties (aesthetics) of your plot. The mapping argument is always defined in the aes() function, and the x and y arguments of aes() specify which variables to map to the x and y axes. For now, we will only map flipper length to the x aesthetic and body mass to the y aesthetic. ggplot2 looks for the mapped variables in the data argument, in this case, penguins.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y=body_mass_g)
)

# Our empty canvas now has more structure – it’s clear where flipper lengths will be displayed (on the x-axis) and where body masses will be displayed (on the y-axis). But the penguins themselves are not yet on the plot. This is because we have not yet articulated, in our code, how to represent the observations from our data frame on our plot.

# To do so, we need to define a geom: the geometrical object that a plot uses to represent data. These geometric objects are made available in ggplot2 with functions that start with geom_. People often describe plots by the type of geom that the plot uses. For example, bar charts use bar geoms (geom_bar()), line charts use line geoms (geom_line()), boxplots use boxplot geoms (geom_boxplot()), scatterplots use point geoms (geom_point()), and so on.

# The function geom_point() adds a layer of points to your plot, which creates a scatterplot. ggplot2 comes with many geom functions that each adds a different type of layer to a plot. You’ll learn a whole bunch of geoms throughout the book, particularly in Chapter 9.


ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y=body_mass_g)
) +
  geom_point()


# Before we add more layers to this plot, let’s pause for a moment and review the warning message we got:
## Removed 2 rows containing missing values (geom_point()).

# We’re seeing this message because there are two penguins in our dataset with missing body mass and/or flipper length values and ggplot2 has no way of representing them on the plot without both of these values. Like R, ggplot2 subscribes to the philosophy that missing values should never silently go missing. This type of warning is probably one of the most common types of warnings you will see when working with real data – missing values are a very common issue and you’ll learn more about them throughout the book, particularly in Chapter 18. For the remaining plots in this chapter we will suppress this warning so it’s not printed alongside every single plot we make.

# 1.2.4 Adding aesthetics and layers
# Scatterplots are useful for displaying the relationship between two numerical variables, but it’s always a good idea to be skeptical of any apparent relationship between two variables and ask if there may be other variables that explain or change the nature of this apparent relationship. For example, does the relationship between flipper length and body mass differ by species? Let’s incorporate species into our plot and see if this reveals any additional insights into the apparent relationship between these variables. We will do this by representing species with different colored points.

# To achieve this, will we need to modify the aesthetic or the geom? If you guessed “in the aesthetic mapping, inside of aes()”, you’re already getting the hang of creating data visualizations with ggplot2! And if not, don’t worry. Throughout the book you will make many more ggplots and have many more opportunities to check your intuition as you make them.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y=body_mass_g, color = species)
) +
  geom_point()


# When a categorical variable is mapped to an aesthetic, ggplot2 will automatically assign a unique value of the aesthetic (here a unique color) to each unique level of the variable (each of the three species), a process known as scaling. ggplot2 will also add a legend that explains which values correspond to which levels.
# 
# Now let’s add one more layer: a smooth curve displaying the relationship between body mass and flipper length. Before you proceed, refer back to the code above, and think about how we can add this to our existing plot.
# 
# Since this is a new geometric object representing our data, we will add a new geom as a layer on top of our point geom: geom_smooth(). And we will specify that we want to draw the line of best fit based on a linear model with method = "lm".

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y=body_mass_g, color = species)
) +
  geom_point() + 
  geom_smooth(method = "lm")

# When aesthetic mappings are defined in ggplot(), at the global level, they’re passed down to each of the subsequent geom layers of the plot. However, each geom function in ggplot2 can also take a mapping argument, which allows for aesthetic mappings at the local level that are added to those inherited from the global level. Since we want points to be colored based on species but don’t want the lines to be separated out for them, we should specify color = species for geom_point() only.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y =body_mass_g)) +
  geom_point(mapping = aes(color = species)) +
  geom_smooth(method = "lm")
)


# Voila! We have something that looks very much like our ultimate goal, though it’s not yet perfect. We still need to use different shapes for each species of penguins and improve labels.
# 
# It’s generally not a good idea to represent information using only colors on a plot, as people perceive colors differently due to color blindness or other color vision differences. Therefore, in addition to color, we can also map species to the shape aesthetic.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y =body_mass_g)) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm")
)

# Note that the legend is automatically updated to reflect the different shapes of the points as well.
# 
# And finally, we can improve the labels of our plot using the labs() function in a new layer. Some of the arguments to labs() might be self explanatory: title adds a title and subtitle adds a subtitle to the plot. Other arguments match the aesthetic mappings, x is the x-axis label, y is the y-axis label, and color and shape define the label for the legend. In addition, we can improve the color palette to be colorblind safe with the scale_color_colorblind() function from the ggthemes package.  
  

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y =body_mass_g)) +
  geom_point(mapping = aes(color = species, shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle =  "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm)", y = "Body mass (g)",
    color = "Species", shape = "Species"
    
  ) +
  scale_color_colorblind()

# 1.2.5 Exercises
# 1. How many rows are in penguins? How many columns?
dim(penguins)
nrow(penguins)
#344

# 2. What does the bill_depth_mm variable in the penguins data frame describe? Read the help for ?penguins to find out.
?penguins
#a number denoting bill depth (millimeters)

# 3. Make a scatterplot of bill_depth_mm vs. bill_length_mm. That is, make a scatterplot with bill_depth_mm on the y-axis and bill_length_mm on the x-axis. Describe the relationship between these two variables.
ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y =bill_depth_mm,)) +
  geom_point(mapping = aes(color = species, shape = species )) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Bill length Vs Bill depth",
    subtitle =  "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Bill length (mm)", y = "Bill depth (mm)",
    color = "Species", shape = "Species"
    
  ) + 
  scale_color_colorblind()

#The scatterplot shows a negative relationship between bill length and bill depth. Penguins with longer bills tend to have shallower bill depths. The three species form distinct clusters: Adelie have shorter and deeper bills, Chinstrap have moderate lengths and depths, and Gentoo have long but shallow bills.


# 4. What happens if you make a scatterplot of species vs. bill_depth_mm? What might be a better choice of geom?
  

ggplot(
  data = penguins,
  mapping = aes(x = species, y =bill_depth_mm,)) +
  geom_point(mapping = aes(color = species, shape = species )) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Bill Depth Vs Species",
    subtitle =  "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Species", y = "Bill depth (mm)",
    color = "Species", shape = "Species"
    
  ) + 
  scale_color_colorblind()

#Answer
# If you make a scatterplot of species (a categorical variable) vs. bill_depth_mm (a numeric variable), the plot will not be very useful. All the points for each species will stack vertically on top of each other, creating three vertical stripes. This happens because a scatterplot is designed for two numeric variables, not a numeric and a categorical variable.

# A better choice of geom for showing how a numeric variable varies across categories would be:
# geom_boxplot() → shows median, quartiles, and spread
# geom_violin() → shows the full distribution shape
# geom_jitter() → spreads points to avoid overlap
# geom_col() or geom_bar(stat = "summary") → if you only want the mean


# geom_boxplot() → shows median, quartiles, and spread
ggplot(
  data = penguins,
  mapping = aes(x = species, y =bill_depth_mm,)) +
  geom_boxplot(mapping = aes(color = species, shape = species )) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Bill Depth Vs Species",
    subtitle =  "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Species", y = "Bill depth (mm)",
    color = "Species", shape = "Species"
    
  ) 
  
# Answer
# The boxplot shows clear differences in bill depth across species. Chinstrap penguins have the deepest bills, followed by Adelie penguins. Gentoo penguins have the shallowest bills, with very little overlap with the other two species. This indicates that bill depth varies strongly by species.”
#   scale_color_colorblind()


# 5. Why does the following give an error and how would you fix it?

ggplot(data = penguins) + 
  geom_point()

# ggplot is like telling someone “draw a graph using this dataset.”
# They will ask: “Okay… but what do you want on the x and y axes?”
# 
# Until you tell ggplot which columns to use, it cannot draw the points.


# 6. What does the na.rm argument do in geom_point()? What is the default value of the argument? Create a scatterplot where you successfully use this argument set to TRUE

#Answer 
# In geom_point(), the na.rm argument controls how missing values are handled when creating a scatterplot. By default, na.rm is set to FALSE, meaning that observations with missing x or y values are removed and a warning message is shown. When na.rm = TRUE, rows with missing values are still removed, but no warning is displayed. This option is useful when missing values are expected and do not need to be reported during plotting.

# Example
ggplot(
  data = penguins,
  mapping = aes(x = species, y =bill_depth_mm,)) +
  geom_boxplot(na.rm = TRUE, mapping = aes(color = species, shape = species )) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Bill Depth Vs Species",
    subtitle =  "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Species", y = "Bill depth (mm)",
    color = "Species", shape = "Species"
    
  ) 

# 7. Add the following caption to the plot you made in the previous exercise: “Data come from the palmerpenguins package.” Hint: Take a look at the documentation for labs().

ggplot(
  data = penguins,
  mapping = aes(x = species, y =bill_depth_mm,)) +
  geom_boxplot(na.rm = TRUE, mapping = aes(color = species, shape = species )) + 
  geom_smooth(method = "lm") +
  labs(
    title = "Bill Depth Vs Species",
    subtitle =  "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Species", y = "Bill depth (mm)",
    color = "Species", shape = "Species"
    
  ) 

# 8. Recreate the following visualization. What aesthetic should bill_depth_mm be mapped to? And should it be mapped at the global level or at the geom level?

# Answer
# To match that plot, bill_depth_mm should be mapped to the colour aesthetic (it is a continuous colour scale with a legend).
# 
# And it should be mapped at the geom level (geom_point()), not globally. If you map it globally in ggplot(aes(...)), the smooth line will also inherit the colour mapping, which is not what your figure shows (your smooth is a single blue line with a grey confidence band).

ggplot(data = penguins, 
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = bill_depth_mm)) +
  geom_smooth(se = TRUE) 


# 9 Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE)


# 10 : Will these two graphs look different? Why/why not?
#1
ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
  geom_point() +
  geom_smooth()

# 2

ggplot() +
  geom_point(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  ) +
  geom_smooth(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
  )

# Answer 
# Why?
# Because in both cases, the same data (penguins) and the same aesthetic mappings (x = flipper_length_mm, y = body_mass_g) are applied to both geoms.
# 
# The only difference is where the data and mappings are specified:
#   
#   In the first plot, data and mappings are set globally in ggplot(), so all layers inherit them.
# 
# In the second plot, data and mappings are set separately for each geom, but they are identical for geom_point() and geom_smooth().
# 
# Since geom_point() and geom_smooth() receive the same inputs in both cases, ggplot2 produces the same visual output.
# 
# In short:
#   Global vs geom-level mapping changes the structure of the code, not the appearance of the plot, as long as the mappings are identical.

# 1.3 ggplot2 calls
ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()
  

ggplot(penguins, aex(x = flipper_lenth_mm, y = body_mass_g))+
  geom_point()


# |>

penguins |>
  ggplot(aes(x = flipper_length_mm, y = body_mass_g))+
  geom_point()


# 1.4 Visualizing distributions


# 1.4.1 A categorical variable
# A variable is categorical if it can only take one of a small set of values. To examine the distribution of a categorical variable, you can use a bar chart. The height of the bars displays how many observations occurred with each x value.

ggplot(penguins, aes(x = species))+
  geom_bar()+
  labs(
    title = "Distribution of species",
    subtitle = "Distribution of Adelie, Chinistrap, and Gentoo",
    x = "Species", y = "Count"
  )


# In bar plots of categorical variables with non-ordered levels, like the penguin species above, it’s often preferable to reorder the bars based on their frequencies. Doing so requires transforming the variable to a factor (how R handles categorical data) and then reordering the levels of that factor.

ggplot(penguins, aes(x = fct_infreq(species)))+
  geom_bar()


# 1.4.2 A numerical variable
# A variable is numerical (or quantitative) if it can take on a wide range of numerical values, and it is sensible to add, subtract, or take averages with those values. Numerical variables can be continuous or discrete.
# 
# One commonly used visualization for distributions of continuous variables is a histogram.

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(binwidth = 200)

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(binwidth = 20)

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_histogram(binwidth = 2000)


# An alternative visualization for distributions of numerical variables is a density plot. A density plot is a smoothed-out version of a histogram and a practical alternative, particularly for continuous data that comes from an underlying smooth distribution. We won’t go into how geom_density()

ggplot(penguins, aes(x = body_mass_g)) + 
  geom_density()


# 1.4.3 Exercises
str(penguins)

# 1. Make a bar plot of species of penguins, where you assign species to the y aesthetic. How is this plot different?

penguins |>
  ggplot(aes( y = fct_infreq(species))) +
  geom_bar()


# When species is mapped to the y aesthetic in a bar plot, the result is a horizontal bar chart rather than the usual vertical one. The counts of penguins are shown along the x axis, while the species categories appear on the y axis. The information displayed is the same, but the orientation is different, which can make the plot easier to read when category names are long.

# 2. How are the following two plots different? Which aesthetic, color or fill, is more useful for changing the color of bars?

ggplot(penguins, aes(x = species)) +
  geom_bar(color = "red")

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red")


# The two plots differ in what part of the bars is coloured. In the first plot, color = "red" changes only the outline (border) of the bars, while the inside of the bars remains the default colour. In the second plot, fill = "red" changes the interior of the bars, making the entire bar red. For bar charts, fill is more useful than color because it controls the main area of the bars and is what viewers usually perceive as the bar’s colour.


# 3. What does the bins argument in geom_histogram() do?


# In geom_histogram(), the bins argument controls how many bars (bins) the data are grouped into. Increasing the number of bins creates narrower bars and more detail, while decreasing the number of bins creates wider bars and a smoother, more general pattern. The choice of bins affects how the distribution of the data appears, but it does not change the underlying data itself.


# 4. Make a histogram of the carat variable in the diamonds dataset that is available when you load the tidyverse package. Experiment with different binwidths. What binwidth reveals the most interesting patterns?
view(diamonds
     )

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 20)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 2)

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)


ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)


# When experimenting with different binwidths, a binwidth around 0.01 reveals the most interesting patterns. It clearly shows distinct spikes at popular carat values (such as 0.5, 1.0, and 1.5 carats), which are hidden when the binwidth is too large. Larger binwidths smooth out these details, while very small binwidths can make the plot too noisy.



# 1.5.1 A numerical and a categorical variable
# To visualize the relationship between a numerical and a categorical variable we can use side-by-side box plots. A boxplot is a type of visual shorthand for measures of position (percentiles) that describe a distribution. It is also useful for identifying potential outliers.


# A box that indicates the range of the middle half of the data, a distance known as the interquartile range (IQR), stretching from the 25th percentile of the distribution to the 75th percentile. In the middle of the box is a line that displays the median, i.e. 50th percentile, of the distribution. These three lines give you a sense of the spread of the distribution and whether or not the distribution is symmetric about the median or skewed to one side.
# 
# Visual points that display observations that fall more than 1.5 times the IQR from either edge of the box. These outlying points are unusual so are plotted individually.
# 
# A line (or whisker) that extends from each end of the box and goes to the farthest non-outlier point in the distribution.


# Let’s take a look at the distribution of body mass by species using geom_boxplot():


ggplot(penguins, aes(x = species, y = body_mass_g)) + 
  geom_boxplot()


# Alternatively, we can make density plots with geom_density().

ggplot(penguins, aes( x = body_mass_g, color = species)) + 
  geom_density(linewidth = 0.75)


# We’ve also customized the thickness of the lines using the linewidth argument in order to make them stand out a bit more against the background.
# 
# Additionally, we can map species to both color and fill aesthetics and use the alpha aesthetic to add transparency to the filled density curves. This aesthetic takes values between 0 (completely transparent) and 1 (completely opaque). In the following plot it’s set to 0.5.


ggplot(penguins, aes(x = body_mass_g, color = species, fill = species)) +
  geom_density(alpha = 0.5)


ggplot(penguins, aes( x = body_mass_g, color = species, fill= species)) + 
  geom_density(linewidth = 0.75, alpha = 0.5)


# 1.5.2 Two categorical variables


# We can use stacked bar plots to visualize the relationship between two categorical variables. For example, the following two stacked bar plots both display the relationship between island and species, or specifically, visualizing the distribution of species within each island.
# 
# The first plot shows the frequencies of each species of penguins on each island. The plot of frequencies shows that there are equal numbers of Adelies on each island. But we don’t have a good sense of the percentage balance within each island.

ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar()


# The second plot, a relative frequency plot created by setting position = "fill" in the geom, is more useful for comparing species distributions across islands since it’s not affected by the unequal numbers of penguins across the islands. Using this plot we can see that Gentoo penguins all live on Biscoe island and make up roughly 75% of the penguins on that island, Chinstrap all live on Dream island and make up roughly 50% of the penguins on that island, and Adelie live on all three islands and make up all of the penguins on Torgersen.

ggplot(penguins, aes(x = island, fill = species)) + 
  geom_bar(position = "fill")


# In creating these bar charts, we map the variable that will be separated into bars to the x aesthetic, and the variable that will change the colors inside the bars to the fill aesthetic. Unfortunately, ggplot2 labels the y-axis "count" by default, but this is something we can override by adding a labs() layer where we specify the y-axis label as "proportion".

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") + 
  labs(y = "proportion")


# 1.5.3 Two numerical variables

# So far you’ve learned about scatterplots (created with geom_point()) and smooth curves (created with geom_smooth()) for visualizing the relationship between two numerical variables. A scatterplot is probably the most commonly used plot for visualizing the relationship between two numerical variables.

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() 
  

# 1.5.4 Three or more variables

# As we saw in Section 1.2.4, we can incorporate more variables into a plot by mapping them to additional aesthetics. For example, in the following scatterplot the colors of points represent species and the shapes of points represent islands.

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island))


# However adding too many aesthetic mappings to a plot makes it cluttered and difficult to make sense of. Another way, which is particularly useful for categorical variables, is to split your plot into facets, subplots that each display one subset of the data.
# 
# To facet your plot by a single variable, use facet_wrap(). The first argument of facet_wrap() is a formula3, which you create with ~ followed by a variable name. The variable that you pass to facet_wrap() should be categorical.


ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species, shape = island)) + 
  facet_wrap(~island)

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) + 
  geom_point(aes(color = species)) + 
  geom_smooth(method = "lm") +
  facet_wrap(~species)


# 1.5.5 Exercises

# 1. The mpg data frame that is bundled with the ggplot2 package contains 234 observations collected by the US Environmental Protection Agency on 38 car models. Which variables in mpg are categorical? Which variables are numerical? (Hint: Type ?mpg to read the documentation for the dataset.) How can you see this information when you run mpg?

?mpg
str(mpg)

# Answer
# Categorical variables
# 
# These describe categories or groups:
#   
#   manufacturer
# 
# model
# 
# trans (type of transmission)
# 
# drv (drive type)
# 
# fl (fuel type)
# 
# class (vehicle class)
# 
# year (treated as categorical in context, even though it is numeric)
# 
# Numerical variables
# 
# These are measured quantities:
#   
#   displ (engine displacement)
# 
# cyl (number of cylinders)
# 
# cty (city miles per gallon)
# 
# hwy (highway miles per gallon)


# 2. Make a scatterplot of hwy vs. displ using the mpg data frame. Next, map a third, numerical variable to color, then size, then both color and size, then shape. How do these aesthetics behave differently for categorical vs. numerical variables?

# Scatterplot of hwy vs displ
ggplot(mpg, aes(x = hwy, y = displ)) + 
  geom_point()

# Map a numerical variable (cty) to different aesthetics
ggplot(mpg, aes(hwy, displ, colour = cty)) + 
  geom_point()

# Size
ggplot(mpg, aes(hwy, displ, size = cty)) + 
  geom_point()

# Both color and size
ggplot(mpg, aes(hwy, displ, size = cty, colour = cty)) + 
  geom_point()

# Shape
ggplot(mpg, aes(hwy, displ, shape = manufacturer)) + 
  geom_point()


# How do these aesthetics behave differently?
#   
#   Color and size work well with numerical variables because they can show gradients and continuous changes. For example, higher cty values smoothly change colour or increase point size.
# 
# Shape does not work well for numerical variables. ggplot2 treats shape as a categorical aesthetic, so a numerical variable is forced into discrete groups, often producing warnings or unclear plots.
# 
# For categorical variables, shape and color are useful because each category gets a distinct symbol or colour.
# 
# For numerical variables, color and size are more informative, while shape is best avoided.
# 
# Key takeaway
# 
# Use color and size for numerical variables, and shape (and discrete color) for categorical variables.

# 3. In the scatterplot of hwy vs. displ, what happens if you map a third variable to linewidth?

ggplot(mpg, aes(hwy, displ))+
  geom_point()


# If you map a third variable to linewidth in a scatterplot of hwy vs displ, nothing useful happens.
# 
# This is because linewidth controls the thickness of lines, not points. Since geom_point() draws points (not lines), mapping a variable to linewidth has no visible effect on the plot and may produce a warning.
# 
# In practice, linewidth is meaningful for geoms like geom_line() or geom_smooth(), but not for scatterplots made with geom_point().


# 4. What happens if you map the same variable to multiple aesthetics?

# If you map the same variable to multiple aesthetics, ggplot2 uses that variable to control all of those visual properties at the same time. For example, mapping one variable to both colour and size means that changes in the data are shown using both colour and point size, reinforcing the same pattern in two ways. This can make trends more noticeable, but it can also make the plot harder to read or visually cluttered if overused.


# 5. Make a scatterplot of bill_depth_mm vs. bill_length_mm and color the points by species. What does adding coloring by species reveal about the relationship between these two variables? What about faceting by species?

ggplot(penguins, aes(bill_depth_mm,bill_length_mm)) +
  geom_point()

ggplot(penguins, aes(bill_depth_mm,bill_length_mm, colour = species)) +
  geom_point()

# Coloring the points by species reveals that the overall relationship between bill length and bill depth is actually made up of distinct clusters, with each species occupying a different region of the plot. This shows that species is an important factor explaining the relationship, which is hidden when all penguins are shown in one colour.


# 6. Why does the following yield two separate legends? How would you fix it to combine the two legends?

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm, 
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species" )

# Answer
# This plot produces two separate legends because colour and shape are different aesthetics, and ggplot2 creates a separate legend for each aesthetic by default, even if they are mapped to the same variable (species). Since only the colour legend is relabelled with labs(color = "Species"), the shape legend keeps its own default title, so they appear as two legends.

# To combine the two legends, you need to give both aesthetics the same legend title:

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm,
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species", shape = "Species")


# 7. Create the two following stacked bar plots. Which question can you answer with the first one? Which question can you answer with the second one?

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")


ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")


# What question does each plot answer?
#   
#   First plot (x = island, fill = species):
#   This plot answers the question: “For each island, what proportion of penguins belongs to each species?”
# Each bar represents an island, and the colours show how the species are distributed within that island.
# 
# Second plot (x = species, fill = island):
#   This plot answers the question: “For each species, what proportion of penguins comes from each island?”
# Each bar represents a species, and the colours show how penguins of that species are distributed across islands.
# 
# Key difference
# 
# Both plots show proportions, but they answer different conditional questions depending on what variable is placed on the x axis.


# 1.6 Saving your plots

# Once you’ve made a plot, you might want to get it out of R by saving it as an image that you can use elsewhere. That’s the job of ggsave(), which will save the plot most recently created to disk:

ggplot(penguins, aes(flipper_length_mm, body_mass_g, colour = species)) + 
  geom_point() +
  ggsave(filename = "./graphs/penguin-plot.png")

# 1.6.1 Exercises

# 1. Run the following lines of code. Which of the two plots is saved as mpg-plot.png? Why?
  
ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png")

# Only the last plot (the scatterplot of cty vs hwy) is saved.
# 
# This is because ggsave() always saves the most recently displayed plot by default. Even though you created a bar plot first, it is overwritten as the “last plot” when you run the scatterplot code, so ggsave("mpg-plot.png") saves the scatterplot, not the bar chart.
# 
# If you wanted to save a specific plot, you would need to assign it to an object and pass it to ggsave().

# 2. What do you need to change in the code above to save the plot as a PDF instead of a PNG? How could you find out what types of image files would work in ggsave()?

ggplot(mpg, aes(x = class)) +
  geom_bar() +
  ggsave(filename = "./graphs/class-bar.pdf")

ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()+
 ggsave("./graphs/mpg-plot.pdf")

?ggplot()
