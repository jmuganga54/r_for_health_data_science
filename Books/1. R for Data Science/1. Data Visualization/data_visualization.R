library(tidyverse)

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



  
  








