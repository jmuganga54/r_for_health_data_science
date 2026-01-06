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


  
